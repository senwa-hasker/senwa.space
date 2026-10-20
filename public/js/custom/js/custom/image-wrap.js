(() => {
  // <stdin>
  function markWrappedText() {
    document.querySelectorAll(".image-figure.img-left, .image-figure.img-right").forEach((figure) => {
      const side = figure.classList.contains("img-right") ? "right" : "left";
      let el = figure.nextElementSibling;
      while (el && !/^H[1-6]$/.test(el.tagName) && !el.classList.contains("image-figure")) {
        if (el.matches("p, blockquote")) {
          el.classList.add("wrap-" + side);
        }
        el = el.nextElementSibling;
      }
    });
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", markWrappedText);
  } else {
    markWrappedText();
  }
})();
