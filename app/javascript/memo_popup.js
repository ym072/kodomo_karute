const escapeHtml = (str) => {
    return (str || "").replace(/[&<>"']/g, (c) => ({
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#39;"
    }[c]));
  };
  
  const setupMemoPopup = () => {
    const popup = document.getElementById("memo-popup");
    const body  = document.getElementById("memo-popup-body");
    const close = document.getElementById("memo-popup-close");
  
    if (!popup || !body || !close) return;
  
    document.addEventListener("click", (e) => {
      const btn = e.target.closest(".memo-tag");
      if (!btn) return;
  
      let memos = [];
      try {
        memos = JSON.parse(btn.dataset.memos || "[]");
      } catch (err) {
        console.error("memo JSON parse error:", err, btn.dataset.memos);
        memos = [];
      }

      console.log("dataset.memos:", btn.dataset.memos);
      console.log("parsed memos:", memos);
  
      if (!Array.isArray(memos) || memos.length === 0) {
        body.innerHTML = `<p class="muted">この日のメモはありません</p>`;
        popup.classList.remove("is-hidden");
        return;
      }
  
      body.innerHTML = memos.map((m) => {
        const at   = m.at   || "";
        const text = m.text || "";
      
        return `
          <div class="memo-popup-item">
            <div class="memo-popup-at">${escapeHtml(at)}</div>
            <div class="memo-popup-text">${escapeHtml(text)}</div>
          </div>
        `;
      }).join("");
  
      popup.classList.remove("is-hidden");
    });
  
    close.addEventListener("click", () => {
      popup.classList.add("is-hidden");
    });
  
    popup.addEventListener("click", (e) => {
      if (e.target === popup) popup.classList.add("is-hidden");
    });
  };
  
  document.addEventListener("turbo:load", setupMemoPopup);
  document.addEventListener("DOMContentLoaded", setupMemoPopup);
  