import { Controller } from "@hotwired/stimulus"
import { heicTo, isHeic } from "heic-to"

export default class extends Controller {
  static targets = ["input", "status", "progress", "error"]

  maxBytes = 8 * 1024 * 1024     // 8MB
  outputSize = 512               // 512x512
  outputQuality = 0.85

  connect() {
    this._onInitialize = (e) => this.onInitialize(e)
    this._onProgress = (e) => this.onProgress(e)
    this._onError = (e) => this.onError(e)
    this._onEnd = (e) => this.onEnd(e)
    this._onTurboSubmitEnd = (e) => this.onTurboSubmitEnd(e)

    document.addEventListener("direct-upload:initialize", this._onInitialize)
    document.addEventListener("direct-upload:progress", this._onProgress)
    document.addEventListener("direct-upload:error", this._onError)
    document.addEventListener("direct-upload:end", this._onEnd)
    document.addEventListener("turbo:submit-end", this._onTurboSubmitEnd)
  }

  disconnect() {
    document.removeEventListener("direct-upload:initialize", this._onInitialize)
    document.removeEventListener("direct-upload:progress", this._onProgress)
    document.removeEventListener("direct-upload:error", this._onError)
    document.removeEventListener("direct-upload:end", this._onEnd)
    document.removeEventListener("turbo:submit-end", this._onTurboSubmitEnd)
  }

  async prepare() {
    this.hideError()

    const input = this.inputTarget
    if (!input.files?.length) return

    const file = input.files[0]
    const type = file.type || ""

    this.statusTarget.hidden = false
    this.progressTarget.textContent = "変換中…"

    if (!type.startsWith("image/")) {
      return this.fail("画像ファイルを選んでください。")
    }

    if (file.size > this.maxBytes) {
      const sizeMB = Math.round((file.size / 1024 / 1024) * 10) / 10
      const maxMB = Math.round((this.maxBytes / 1024 / 1024) * 10) / 10
      return this.fail(`ファイルサイズが大きすぎます（${sizeMB}MB）。上限は${maxMB}MBです。`)
    }

    try {
      const normalized = await this.normalizeImage(file)
      const webpFile = await this.toWebpSquare(normalized)

      const dt = new DataTransfer()
      dt.items.add(webpFile)
      input.files = dt.files

      this.statusTarget.hidden = true
    } catch (e) {
      console.error(e)

      const t = file.type || "不明"
      const sizeMB = Math.round((file.size / 1024 / 1024) * 10) / 10

      return this.fail(
        `画像の変換に失敗しました（形式: ${t}, サイズ: ${sizeMB}MB）。\n` +
        `一眼/高解像度の画像は端末によって変換できないことがあります。JPEGにするか、サイズを小さくして再度お試しください。`
      )
    }
  }

  onSubmit() {
    this.hideError()
    this.statusTarget.hidden = false
    this.progressTarget.textContent = "0"

    const btn = this.element.querySelector('input[type="submit"], button[type="submit"]')
    if (btn) btn.disabled = true
  }

  onTurboSubmitEnd(event) {
    if (event.target !== this.element) return
    this.statusTarget.hidden = true

    const btn = this.element.querySelector('input[type="submit"], button[type="submit"]')
    if (btn) btn.disabled = false
  }

  async normalizeImage(file) {
    if (await isHeic(file)) {
      const jpegBlob = await heicTo({
        blob: file,
        type: "image/jpeg",
        quality: 0.9
      })
      return new File(
        [jpegBlob],
        (file.name || "icon").replace(/\.[^.]+$/, "") + ".jpg",
        { type: "image/jpeg" }
      )
    }
    return file
  }

  async toWebpSquare(file) {
    const bitmap = await createImageBitmap(file)

    const side = Math.min(bitmap.width, bitmap.height)
    const sx = Math.floor((bitmap.width - side) / 2)
    const sy = Math.floor((bitmap.height - side) / 2)

    const canvas = document.createElement("canvas")
    canvas.width = this.outputSize
    canvas.height = this.outputSize

    const ctx = canvas.getContext("2d")
    ctx.drawImage(bitmap, sx, sy, side, side, 0, 0, this.outputSize, this.outputSize)

    const blob = await new Promise((resolve, reject) => {
      canvas.toBlob(
        (b) => (b ? resolve(b) : reject(new Error("toBlob failed"))),
        "image/webp",
        this.outputQuality
      )
    })

    const base = (file.name || "icon").replace(/\.[^.]+$/, "")
    return new File([blob], `${base}.webp`, { type: "image/webp" })
  }

  onInitialize(e) {
    if (e.target !== this.inputTarget) return
    this.statusTarget.hidden = false
    this.progressTarget.textContent = "0"
  }

  onProgress(e) {
    if (e.target !== this.inputTarget) return
    this.progressTarget.textContent = String(e.detail.progress)
  }

  onError(e) {
    if (e.target !== this.inputTarget) return
    e.preventDefault()
    this.showError(e.detail?.error || "アップロードに失敗しました（通信状況をご確認ください）。")
  }

  onEnd(e) {
    if (e.target !== this.inputTarget) return
    this.statusTarget.hidden = true
  }

  fail(msg) {
    this.inputTarget.value = ""
    this.showError(msg)
  }

  showError(msg) {
    this.errorTarget.textContent = msg
    this.errorTarget.hidden = false
    this.statusTarget.hidden = true
  }

  hideError() {
    this.errorTarget.hidden = true
    this.errorTarget.textContent = ""
  }
}
