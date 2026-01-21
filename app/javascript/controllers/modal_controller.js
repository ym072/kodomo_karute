import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (this.element.showModal) this.element.showModal()
  }

  close(event) {
    if (event) event.preventDefault()
    if (this.element.close) this.element.close()

    const frame = document.getElementById("modal")
    if (frame) frame.innerHTML = ""
  }
}
