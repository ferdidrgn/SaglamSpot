// web-genesis — ilerici geliştirme (progressive enhancement) giriş noktası.
// Sepet tamamen istemci tarafında (localStorage) tutulur; sunucu hiçbir
// sepet durumu bilmez. Burada üretilen ürün/sepet linkleri ve HMAC imzası
// lib/core/services/deeplink/deeplink_service.dart ile AYNI algoritma —
// DEĞİŞTİRME (bkz. web-genesis/functions/src/linkSigning.js'teki not).
// Çevrilen metinler (locale'e bağlı) sayfanın kendisinden window.__DATA__
// üzerinden geliyor (bkz. /sepet route'u) — burada ikinci bir i18n motoru
// kurulmuyor.
(function () {
  "use strict";

  const STORAGE_KEY = "saglamspot_sepet_v1";
  const HMAC_SECRET = "SAGLAM_SPOT_CYBER_SECURITY_KEY_2026";
  const SHARE_DOMAIN = "https://saglamspotcu.web.app";
  const PHONE = "905392019961";
  const CART_STRINGS = (window.__DATA__ && window.__DATA__.cartStrings) || {};
  const FAV_STORAGE_KEY = "saglamspot_favoriler_v1";
  const FAV_STRINGS = (window.__DATA__ && window.__DATA__.favStrings) || {};

  function readCart() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      const parsed = raw ? JSON.parse(raw) : [];
      return Array.isArray(parsed) ? parsed : [];
    } catch (_) {
      return [];
    }
  }

  function writeCart(items) {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
    } catch (_) {
      // localStorage engellenmiş olabilir (gizli pencere vb.) — sessizce yok say.
    }
  }

  function findIndex(items, id) {
    return items.findIndex((item) => item.id === id);
  }

  function toggleCartItem(id, name, price) {
    const items = readCart();
    const idx = findIndex(items, id);
    if (idx === -1) {
      items.push({id, name, price, quantity: 1});
    } else {
      items.splice(idx, 1);
    }
    writeCart(items);
    return items;
  }

  function setQuantity(items, id, quantity) {
    const next = items
        .map((item) => (item.id === id ? {...item, quantity} : item))
        .filter((item) => item.quantity > 0);
    writeCart(next);
    return next;
  }

  function cartCount(items) {
    return items.reduce((sum, item) => sum + item.quantity, 0);
  }

  function updateBadge() {
    const badge = document.getElementById("cart-badge");
    if (!badge) return;
    const count = cartCount(readCart());
    badge.textContent = String(count);
    badge.hidden = count === 0;
  }

  function formatPrice(value) {
    return `${Math.round(value).toLocaleString("tr-TR")} ₺`;
  }

  // --- lib/core/common/extentions/reg_exp_extentions.dart ile aynı slug ---
  function toSlug(name) {
    return (name || "")
        .toLowerCase()
        .replace(/ /g, "-")
        .replace(/ş/g, "s")
        .replace(/ı/g, "i")
        .replace(/ç/g, "c")
        .replace(/ö/g, "o")
        .replace(/ü/g, "u")
        .replace(/ğ/g, "g")
        .replace(/[^a-z0-9-]/g, "");
  }

  let hmacKeyPromise = null;
  function getHmacKey() {
    if (!hmacKeyPromise) {
      hmacKeyPromise = crypto.subtle.importKey(
          "raw",
          new TextEncoder().encode(HMAC_SECRET),
          {name: "HMAC", hash: "SHA-256"},
          false,
          ["sign"],
      );
    }
    return hmacKeyPromise;
  }

  async function signHex(message) {
    const key = await getHmacKey();
    const signature = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(message));
    return Array.from(new Uint8Array(signature)).map((b) => b.toString(16).padStart(2, "0")).join("");
  }

  async function productShareUrl(id, name) {
    const slug = toSlug(name);
    const sig = await signHex(id);
    return `${SHARE_DOMAIN}/product/${encodeURIComponent(`${slug}-${id}`)}?sig=${sig}`;
  }

  async function cartShareUrl(items) {
    const itemsParam = items.map((i) => `${i.id}:${i.quantity}`).join(",");
    const sig = await signHex(itemsParam);
    return `${SHARE_DOMAIN}/cart?items=${encodeURIComponent(itemsParam)}&sig=${sig}`;
  }

  // Buton metni locale'e göre sunucuda zaten doğru basıldı (t(locale,
  // 'addToCartCta')) — istemci sadece "sepette mi" görsel durumunu
  // (yeşil arkaplan) değiştiriyor, metni DEĞİŞTİRMİYOR. Böylece "kaldır"
  // kelimesi için ayrı bir çeviri kaynağına ihtiyaç kalmıyor.
  function wireAddButtons() {
    document.querySelectorAll("[data-cart-add]").forEach((btn) => {
      const id = btn.dataset.id;
      const sync = () => {
        const inCart = findIndex(readCart(), id) !== -1;
        btn.classList.toggle("is-in-cart", inCart);
        btn.setAttribute("aria-pressed", String(inCart));
      };
      sync();
      btn.addEventListener("click", () => {
        toggleCartItem(id, btn.dataset.name, Number(btn.dataset.price));
        sync();
        updateBadge();
      });
    });
  }

  function renderCartApp() {
    const root = document.querySelector("[data-cart-app]");
    if (!root) return;

    function render() {
      const items = readCart();

      if (!items.length) {
        root.innerHTML = `<p class="empty-state">${escapeHtml(CART_STRINGS.empty || "")}</p>`;
        return;
      }

      const rowsHtml = items.map((item) => `
        <div class="cart-row" data-row="${item.id}">
          <div class="cart-row-info">
            <p class="cart-row-name">${escapeHtml(item.name)}</p>
            <p class="cart-row-price">${formatPrice(item.price)}</p>
          </div>
          <div class="cart-row-qty">
            <button type="button" data-qty-dec aria-label="−">−</button>
            <span>${item.quantity}</span>
            <button type="button" data-qty-inc aria-label="+">+</button>
          </div>
          <p class="cart-row-subtotal">${formatPrice(item.price * item.quantity)}</p>
          <button type="button" class="cart-row-remove" data-remove>${escapeHtml(CART_STRINGS.remove || "")}</button>
        </div>`).join("");

      const total = items.reduce((sum, item) => sum + item.price * item.quantity, 0);

      root.innerHTML = `
        <div class="cart-list">${rowsHtml}</div>
        <div class="cart-total">
          <span>${escapeHtml(CART_STRINGS.total || "")}</span>
          <strong>${formatPrice(total)}</strong>
        </div>
        <button type="button" class="whatsapp-link cart-send-btn" data-send-whatsapp>${escapeHtml(CART_STRINGS.sendButton || "")}</button>
        <p class="cart-note">${escapeHtml(CART_STRINGS.note || "")}</p>`;

      root.querySelectorAll("[data-row]").forEach((row) => {
        const id = row.dataset.row;
        row.querySelector("[data-qty-inc]").addEventListener("click", () => {
          const current = readCart();
          const item = current.find((i) => i.id === id);
          setQuantity(current, id, (item ? item.quantity : 0) + 1);
          updateBadge();
          render();
        });
        row.querySelector("[data-qty-dec]").addEventListener("click", () => {
          const current = readCart();
          const item = current.find((i) => i.id === id);
          setQuantity(current, id, (item ? item.quantity : 1) - 1);
          updateBadge();
          render();
        });
        row.querySelector("[data-remove]").addEventListener("click", () => {
          setQuantity(readCart(), id, 0);
          updateBadge();
          render();
        });
      });

      const sendBtn = root.querySelector("[data-send-whatsapp]");
      if (sendBtn) {
        sendBtn.addEventListener("click", async () => {
          sendBtn.disabled = true;
          sendBtn.textContent = (CART_STRINGS.sending || "…");
          try {
            // lib/features/cart/presentation/pages/cart_page.dart
            // _sendCartToWhatsApp ile AYNI mesaj biçimi (çeviriler
            // cartWhatsappGreeting/cartWhatsappAllProductsLine'dan).
            let message = CART_STRINGS.greeting || "";
            for (const item of items) {
              const link = await productShareUrl(item.id, item.name);
              message += `• ${item.name}`;
              if (item.quantity > 1) message += ` (x${item.quantity})`;
              message += ` — ${Math.round(item.price * item.quantity)}₺\n`;
              message += `  ${link}\n\n`;
            }
            message += `${CART_STRINGS.total || "Toplam"}: ${Math.round(total)}₺\n\n`;
            const cartUrl = await cartShareUrl(items);
            const allProductsLine = (CART_STRINGS.allProductsLine || "{url}").split("{url}").join(cartUrl);
            message += allProductsLine;

            window.open(`https://wa.me/${PHONE}?text=${encodeURIComponent(message)}`, "_blank", "noopener");
          } finally {
            sendBtn.disabled = false;
            sendBtn.textContent = CART_STRINGS.sendButton || "";
          }
        });
      }
    }

    render();
  }

  // Header, sayfa kaydırıldığında hafif bir gölge/arkaplan kazanır — saf
  // CSS ile yapılamayan tek şey (scroll konumuna bağlı), bu yüzden küçük
  // bir JS dokunuşu. Animasyon değil, tek bir class toggle.
  function wireHeaderScroll() {
    const header = document.querySelector(".site-header");
    if (!header) return;
    const update = () => header.classList.toggle("is-scrolled", window.scrollY > 4);
    update();
    window.addEventListener("scroll", update, {passive: true});
  }

  // Bölümler/kartlar görünüme girerken hafifçe belirip yukarı kayar.
  // `prefers-reduced-motion` veya IntersectionObserver desteği yoksa HİÇBİR
  // şey yapmıyoruz — <html> sınıfı eklenmediği sürece CSS tarafında içerik
  // zaten tam görünür/opak kalır (bkz. base.css ".reveal-ready" kapsamı),
  // yani JS kapalıyken de sayfa eksiksiz okunur.
  function wireRevealAnimations() {
    if (!("IntersectionObserver" in window)) return;
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

    const targets = document.querySelectorAll(
        ".hero, .section, .product-grid, .bento-grid, .gateway-grid, .value-card, .faq-item, .about-panel, .category-rail",
    );
    if (!targets.length) return;

    document.documentElement.classList.add("reveal-ready");
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    }, {threshold: 0.08, rootMargin: "0px 0px -40px 0px"});

    targets.forEach((el) => observer.observe(el));
  }

  // Ana sayfa hero'su — lib/features/home/presentation/widgets/
  // home_page_hero_widgets.dart'taki HeroBanner'ın (PageView + Timer.periodic
  // 6sn) karşılığı: slaytlar arası çapraz geçiş, ok/nokta gezinme.
  function wireHeroCarousel() {
    const root = document.querySelector("[data-hero-carousel]");
    if (!root) return;
    const slides = [...root.querySelectorAll(".hero-slide")];
    const dots = [...root.querySelectorAll(".hero-dot")];
    if (slides.length < 2) return;
    let index = Math.max(0, slides.findIndex((s) => s.classList.contains("is-active")));
    let timer = null;

    function show(next) {
      index = (next + slides.length) % slides.length;
      slides.forEach((s, i) => s.classList.toggle("is-active", i === index));
      dots.forEach((d, i) => d.classList.toggle("is-active", i === index));
    }

    function restart() {
      if (timer) clearInterval(timer);
      timer = setInterval(() => show(index + 1), 6000);
    }

    root.querySelector(".hero-arrow-prev")?.addEventListener("click", () => {
      show(index - 1);
      restart();
    });
    root.querySelector(".hero-arrow-next")?.addEventListener("click", () => {
      show(index + 1);
      restart();
    });
    dots.forEach((d, i) => d.addEventListener("click", () => {
      show(i);
      restart();
    }));

    restart();
  }

  // İstatistik şeridi — home_page_web.dart'taki CountUpOnVisible ile aynı
  // fikir: sayı, kart görünüme girince 0'dan hedefe doğru sayar.
  function wireStatCounters() {
    const targets = document.querySelectorAll("[data-count-to]");
    if (!targets.length) return;
    const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    function animate(el) {
      const to = Number(el.dataset.countTo) || 0;
      const suffix = el.dataset.countSuffix || "";
      if (reduceMotion || !("IntersectionObserver" in window)) {
        el.textContent = to + suffix;
        return;
      }
      const duration = 1200;
      const start = performance.now();
      function step(now) {
        const progress = Math.min(1, (now - start) / duration);
        const eased = 1 - Math.pow(1 - progress, 3);
        el.textContent = Math.round(eased * to) + suffix;
        if (progress < 1) requestAnimationFrame(step);
      }
      requestAnimationFrame(step);
    }

    if (!("IntersectionObserver" in window)) {
      targets.forEach(animate);
      return;
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          animate(entry.target);
          observer.unobserve(entry.target);
        }
      });
    }, {threshold: 0.4});
    targets.forEach((el) => observer.observe(el));
  }

  // Favoriler — sepetten bağımsız, sadece kalp ikonuyla işaretlenen ürünler
  // (bkz. lib/features/products/presentation/providers/favorites_provider.dart
  // ile aynı kavram). Miktar yok, sadece var/yok; ürünün gösterimi için
  // gereken her şeyi (isim/fiyat/görsel/yol) favorilenme anında saklıyoruz
  // ki /favoriler sayfası Firestore'a tekrar gitmeden render edebilsin.
  function readFavorites() {
    try {
      const raw = localStorage.getItem(FAV_STORAGE_KEY);
      const parsed = raw ? JSON.parse(raw) : [];
      return Array.isArray(parsed) ? parsed : [];
    } catch (_) {
      return [];
    }
  }

  function writeFavorites(items) {
    try {
      localStorage.setItem(FAV_STORAGE_KEY, JSON.stringify(items));
    } catch (_) {
      // yok say
    }
  }

  function isFavorited(id) {
    return readFavorites().some((f) => f.id === id);
  }

  function toggleFavorite(data) {
    const items = readFavorites();
    const idx = items.findIndex((f) => f.id === data.id);
    if (idx === -1) items.push(data);
    else items.splice(idx, 1);
    writeFavorites(items);
    return items;
  }

  function updateFavBadge() {
    const badge = document.getElementById("fav-badge");
    if (!badge) return;
    const count = readFavorites().length;
    badge.textContent = String(count);
    badge.hidden = count === 0;
  }

  function wireFavoriteButtons() {
    document.querySelectorAll("[data-favorite-toggle]").forEach((btn) => {
      const data = {
        id: btn.dataset.id,
        name: btn.dataset.name,
        price: Number(btn.dataset.price),
        image: btn.dataset.image || "",
        path: btn.dataset.path || "",
      };
      const sync = () => {
        const fav = isFavorited(data.id);
        btn.classList.toggle("is-favorited", fav);
        btn.setAttribute("aria-pressed", String(fav));
      };
      sync();
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        toggleFavorite(data);
        sync();
        updateFavBadge();
        renderFavoritesApp();
      });
    });
  }

  function renderFavoritesApp() {
    const root = document.querySelector("[data-fav-app]");
    if (!root) return;
    const items = readFavorites();

    if (!items.length) {
      root.innerHTML = `
        <div class="empty-state">
          <p>${escapeHtml(FAV_STRINGS.emptyTitle || "")}</p>
          <p>${escapeHtml(FAV_STRINGS.emptyDesc || "")}</p>
          <a class="whatsapp-link" href="/arama">${escapeHtml(FAV_STRINGS.exploreLabel || "")}</a>
        </div>`;
      return;
    }

    root.innerHTML = `<div class="product-grid">${items.map((item) => `
      <div class="pcard">
        <a class="pcard-link" href="${escapeHtml(item.path)}">
          <div class="pcard-media">
            ${item.image ? `<img src="${escapeHtml(item.image)}" alt="${escapeHtml(item.name)}" loading="lazy">` : "<div class=\"pcard-placeholder\"></div>"}
            <div class="pcard-scrim" aria-hidden="true"></div>
            <div class="pcard-info">
              <div class="pcard-info-text">
                <p class="pcard-name">${escapeHtml(item.name)}</p>
              </div>
              <span class="pcard-price"><span dir="ltr">${formatPrice(item.price)}</span></span>
            </div>
          </div>
        </a>
        <button type="button" class="pcard-cart-btn pcard-fav-btn is-favorited" data-favorite-toggle
          data-id="${escapeHtml(item.id)}" data-name="${escapeHtml(item.name)}" data-price="${item.price}"
          data-image="${escapeHtml(item.image)}" data-path="${escapeHtml(item.path)}"
          aria-label="Favoriden kaldır">${FAV_ICON}</button>
      </div>`).join("")}</div>`;

    wireFavoriteButtons();
  }

  const FAV_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12 21s-7.5-4.6-10-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 10 6c-2.5 4.4-10 9-10 9z\"/></svg>";

  // Ürün detayındaki paylaş butonu — Web Share API varsa (çoğu mobil
  // tarayıcı) native paylaşım sayfası açılır; yoksa link panoya kopyalanır
  // ve kısa ömürlü bir toast gösterilir (window.alert() yerine, admin
  // panelindeki aynı "modern bildirim" fikri).
  function toast(message) {
    let stack = document.querySelector(".toast-stack");
    if (!stack) {
      stack = document.createElement("div");
      stack.className = "toast-stack";
      document.body.appendChild(stack);
    }
    const el = document.createElement("div");
    el.className = "toast";
    el.textContent = message;
    stack.appendChild(el);
    window.setTimeout(() => {
      el.classList.add("is-leaving");
      el.addEventListener("animationend", () => el.remove(), {once: true});
    }, 2600);
  }

  function wireShareButtons() {
    document.querySelectorAll("[data-share-product]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const url = btn.dataset.shareUrl;
        const title = btn.dataset.shareTitle || "";
        if (navigator.share) {
          try {
            await navigator.share({title, url});
            return;
          } catch (_) {
            // Kullanıcı paylaşım sayfasını iptal etti — sessizce yok say,
            // panoya kopyalamaya DÜŞME (iptal = "kopyala" anlamına gelmez).
            return;
          }
        }
        try {
          await navigator.clipboard.writeText(url);
          toast("Bağlantı kopyalandı.");
        } catch (_) {
          toast(url);
        }
      });
    });
  }

  // Ürün kartlarındaki mini görsel karuseli — lib/core/widgets/design_system/
  // product_image_switcher.dart'ın (ProductImageSwitcher, dotsAtTop: true)
  // web karşılığı: kartın KENDİSİNDE, detay sayfasına gitmeden ok/nokta ile
  // gezinme. Her kart kendi index'ini tutar (bağımsız).
  function wireCardCarousels() {
    document.querySelectorAll("[data-card-images]").forEach((card) => {
      let images;
      try {
        images = JSON.parse(card.dataset.cardImages || "[]");
      } catch (_) {
        images = [];
      }
      if (images.length < 2) return;

      const img = card.querySelector("[data-card-img]");
      const dots = [...card.querySelectorAll(".pcard-dot")];
      let index = 0;

      function show(i) {
        index = (i + images.length) % images.length;
        img.src = images[index];
        dots.forEach((d, di) => d.classList.toggle("is-active", di === index));
      }

      card.querySelector("[data-card-prev]")?.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        show(index - 1);
      });
      card.querySelector("[data-card-next]")?.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        show(index + 1);
      });
    });
  }

  function wireLanguageSwitcher() {
    const select = document.getElementById("lang-switcher");
    if (!select) return;
    select.addEventListener("change", () => {
      const url = new URL(window.location.href);
      url.searchParams.set("lang", select.value);
      window.location.href = url.pathname + url.search;
    });
  }

  function escapeHtml(value) {
    return String(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
  }

  document.addEventListener("DOMContentLoaded", () => {
    updateBadge();
    wireAddButtons();
    renderCartApp();
    updateFavBadge();
    wireFavoriteButtons();
    renderFavoritesApp();
    wireLanguageSwitcher();
    wireHeaderScroll();
    wireRevealAnimations();
    wireHeroCarousel();
    wireStatCounters();
    wireShareButtons();
    wireCardCarousels();
  });
})();
