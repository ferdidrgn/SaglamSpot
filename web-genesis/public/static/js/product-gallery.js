// Ürün detay sayfası — birden fazla görsel varsa tam ekran, oklu/noktalı,
// dokunmatik kaydırmalı bir galeri (lightbox). lib/core/widgets/
// gallery_section.dart'taki GalleryViewerDialog'un web karşılığı.
(function () {
  "use strict";

  const root = document.querySelector("[data-gallery]");
  if (!root) return;

  let images = [];
  try {
    images = JSON.parse(root.dataset.images || "[]");
  } catch (_) {
    images = [];
  }
  if (!images.length) return;

  const mainImg = root.querySelector("[data-gallery-main]");
  const thumbs = [...root.querySelectorAll("[data-gallery-thumb]")];
  const lightbox = document.querySelector("[data-gallery-lightbox]");
  // Sunucu bu <div>'i .pdetail-media'nın (position:sticky — bu da kendi
  // stacking context'ini oluşturur) İÇİNE basıyor. position:fixed bir
  // öğe görsel olarak viewport'a göre konumlanır AMA z-index karşılaştırması
  // hâlâ en yakın stacking-context ATASININ İÇİNDE kalır — yani lightbox'ın
  // z-index:300'ü sadece .pdetail-media alt ağacı İÇİNDE geçerli, site
  // header'ın (kök seviyede z-index:50) ÜSTÜNE hiç çıkamıyordu; kapatma
  // butonuna/oklara tıklamak aslında altında kalan header'daki dil
  // seçiciye tıklıyordu (gerçek kullanıcı geri bildirimiyle yakalandı).
  // Standart "portal" çözümü: lightbox'ı doğrudan <body>'nin çocuğu yap,
  // böylece kök seviyede kendi z-index'iyle yarışır.
  if (lightbox && lightbox.parentElement !== document.body) {
    document.body.appendChild(lightbox);
  }
  const lightboxImg = lightbox ? lightbox.querySelector("[data-gallery-lightbox-img]") : null;
  const counters = document.querySelectorAll("[data-gallery-counter]");
  const prevBtns = document.querySelectorAll("[data-gallery-prev]");
  const nextBtns = document.querySelectorAll("[data-gallery-next]");
  const expandBtn = root.querySelector("[data-gallery-expand]");
  const closeBtn = lightbox ? lightbox.querySelector("[data-gallery-close]") : null;

  let index = 0;
  let lightboxOpen = false;

  function render() {
    mainImg.src = images[index];
    thumbs.forEach((t, i) => t.classList.toggle("is-active", i === index));
    if (lightboxOpen && lightboxImg) lightboxImg.src = images[index];
    counters.forEach((c) => {
      c.textContent = `${index + 1} / ${images.length}`;
    });
  }

  function go(delta) {
    index = (index + delta + images.length) % images.length;
    render();
  }

  thumbs.forEach((t) => t.addEventListener("click", () => {
    index = Number(t.dataset.index) || 0;
    render();
  }));

  prevBtns.forEach((b) => b.addEventListener("click", () => go(-1)));
  nextBtns.forEach((b) => b.addEventListener("click", () => go(1)));

  function openLightbox() {
    if (!lightbox) return;
    lightboxOpen = true;
    lightbox.hidden = false;
    document.body.style.overflow = "hidden";
    requestAnimationFrame(() => lightbox.classList.add("is-open"));
    render();
    closeBtn?.focus();
  }

  function closeLightbox() {
    if (!lightbox) return;
    lightboxOpen = false;
    lightbox.classList.remove("is-open");
    document.body.style.overflow = "";
    window.setTimeout(() => {
      lightbox.hidden = true;
    }, 220);
  }

  expandBtn?.addEventListener("click", openLightbox);
  mainImg.addEventListener("click", openLightbox);
  closeBtn?.addEventListener("click", closeLightbox);

  lightbox?.addEventListener("click", (e) => {
    // Sadece karanlık arka plana tıklanınca kapat — görsele/oklara
    // tıklamak kapatmamalı.
    if (e.target === lightbox) closeLightbox();
  });

  document.addEventListener("keydown", (e) => {
    if (!lightboxOpen) return;
    if (e.key === "Escape") closeLightbox();
    else if (e.key === "ArrowLeft") go(-1);
    else if (e.key === "ArrowRight") go(1);
  });

  // Dokunmatik kaydırma (mobil) — hem ana görsel hem lightbox için.
  function wireSwipe(el) {
    if (!el) return;
    let startX = 0;
    let startY = 0;
    el.addEventListener("touchstart", (e) => {
      startX = e.touches[0].clientX;
      startY = e.touches[0].clientY;
    }, {passive: true});
    el.addEventListener("touchend", (e) => {
      const dx = e.changedTouches[0].clientX - startX;
      const dy = e.changedTouches[0].clientY - startY;
      if (Math.abs(dx) > 40 && Math.abs(dx) > Math.abs(dy)) {
        go(dx < 0 ? 1 : -1);
      }
    }, {passive: true});
  }

  wireSwipe(mainImg);
  wireSwipe(lightboxImg);

  render();
})();

// Admin > İstatistikler ekranındaki tarih filtreli "tıklama" metriği —
// bu dosyanın (yukarıdaki) galeri IIFE'si görsel YOKSA erken çıkıyor,
// bu yüzden tıklama günlüğü AYRI, bağımsız bir blokta: tek/hiç görseli
// olan ürünlerde de çalışsın. `data-contact-cta` anchor'ları normal
// şekilde wa.me'ye gider (preventDefault YOK) — fetch `keepalive:true`
// ile sayfa ayrılsa bile isteğin tamamlanmasını garanti eder (bkz.
// functions/src/routes/trackClick.js).
(function () {
  "use strict";
  document.querySelectorAll("[data-contact-cta]").forEach((el) => {
    el.addEventListener("click", () => {
      try {
        fetch("/api/track-click", {
          method: "POST",
          keepalive: true,
          headers: {"Content-Type": "application/json"},
          body: JSON.stringify({
            productId: el.dataset.productId || "",
            category: el.dataset.category || "",
          }),
        }).catch(() => {});
      } catch (_) {
        // Günlükleme ASLA WhatsApp'a gitmeyi engellemez.
      }
    });
  });
})();
