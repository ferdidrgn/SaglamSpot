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
            message += CART_STRINGS.localeNote || "";

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
          </div>
          <div class="pcard-body">
            <p class="pcard-name">${escapeHtml(item.name)}</p>
            <span class="pcard-price"><span dir="ltr">${formatPrice(item.price)}</span></span>
          </div>
        </a>
        <div class="pcard-actions">
          <button type="button" class="pcard-icon-btn pcard-fav-btn is-favorited" data-favorite-toggle
            data-id="${escapeHtml(item.id)}" data-name="${escapeHtml(item.name)}" data-price="${item.price}"
            data-image="${escapeHtml(item.image)}" data-path="${escapeHtml(item.path)}"
            aria-label="Favoriden kaldır">${FAV_ICON}</button>
          <button type="button" class="pcard-icon-btn pcard-share-btn" data-share-product
            data-share-id="${escapeHtml(item.id)}" data-share-title="${escapeHtml(item.name)}"
            aria-label="Paylaş">${FAV_SHARE_ICON}</button>
        </div>
      </div>`).join("")}</div>`;
    wireShareButtons();

    wireFavoriteButtons();
  }

  const FAV_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12 21s-7.5-4.6-10-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 10 6c-2.5 4.4-10 9-10 9z\"/></svg>";
  const FAV_SHARE_ICON = "<svg width=\"15\" height=\"15\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><circle cx=\"18\" cy=\"5\" r=\"2.5\"/><circle cx=\"6\" cy=\"12\" r=\"2.5\"/><circle cx=\"18\" cy=\"19\" r=\"2.5\"/><path d=\"M8.2 10.8l7.6-4.6M8.2 13.2l7.6 4.6\"/></svg>";

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

  const SHARE_CLOSE_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M6 6l12 12M18 6L6 18\"/></svg>";
  const SHARE_WHATSAPP_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12.04 2c-5.46 0-9.9 4.44-9.9 9.9 0 1.75.46 3.45 1.32 4.95L2 22l5.25-1.38a9.9 9.9 0 0 0 4.79 1.22h.01c5.46 0 9.9-4.44 9.9-9.9S17.5 2 12.04 2zm5.8 14.17c-.24.68-1.4 1.3-1.93 1.37-.49.07-1.1.1-1.78-.11-.41-.13-.94-.3-1.62-.6-2.84-1.23-4.7-4.1-4.84-4.29-.14-.19-1.15-1.53-1.15-2.92s.72-2.07.98-2.35c.24-.26.52-.33.7-.33h.5c.16 0 .37-.02.58.44.24.56.8 1.93.87 2.07.07.14.12.3.02.49-.1.19-.15.3-.3.47-.14.17-.3.37-.43.5-.14.14-.29.29-.13.57.17.28.74 1.22 1.6 1.97 1.1.98 2.03 1.28 2.31 1.43.28.14.44.12.6-.07.17-.19.72-.84.91-1.13.19-.28.38-.23.63-.14.26.1 1.64.77 1.92.91.28.14.47.21.54.33.07.12.07.68-.17 1.36z\"/></svg>";
  const SHARE_INSTAGRAM_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" aria-hidden=\"true\"><rect x=\"3\" y=\"3\" width=\"18\" height=\"18\" rx=\"5\"/><circle cx=\"12\" cy=\"12\" r=\"4\"/><circle cx=\"17.2\" cy=\"6.8\" r=\"1\" fill=\"currentColor\" stroke=\"none\"/></svg>";

  // "Paylaş" ikon butonları (ürün kartları, ürün detay, favoriler) —
  // ÖNCEDEN navigator.share varsa işletim sisteminin kendi paylaşım
  // sayfasını açıyordu, yoksa linki sessizce panoya kopyalıyordu.
  // Kullanıcı geri bildirimi: "paylaş butonuna basınca linki kopyalama,
  // wp de mi mesaj mı atsın instagramdan mı atsın o popup'ı aç" — artık
  // her yerde AYNI açık seçim popup'ı açılıyor (OS'un kendi sayfasına
  // bırakmak yerine). WhatsApp gerçek bir web share hedefi sunduğu için
  // (wa.me/?text=) doğrudan çalışıyor; Instagram'ın böyle bir "gönderi
  // oluştur" web adresi YOK (bkz. wireInstagramShare'teki not) — en
  // iyi ihtimalle metni panoya kopyalayıp instagram.com'u açıyoruz.
  let sharePopup = null;
  function buildSharePopup() {
    if (sharePopup) return sharePopup;
    const overlay = document.createElement("div");
    overlay.className = "share-popup-overlay";
    overlay.hidden = true;
    overlay.innerHTML = `
      <div class="share-popup" role="dialog" aria-modal="true" aria-label="Paylaş">
        <button type="button" class="share-popup-close" data-popup-close aria-label="Kapat">${SHARE_CLOSE_ICON}</button>
        <p class="share-popup-title">Nasıl paylaşmak istersin?</p>
        <div class="share-popup-options">
          <button type="button" class="share-popup-option" data-popup-via="whatsapp">${SHARE_WHATSAPP_ICON} WhatsApp'ta Paylaş</button>
          <button type="button" class="share-popup-option" data-popup-via="instagram">${SHARE_INSTAGRAM_ICON} Instagram'da Paylaş</button>
        </div>
      </div>`;
    document.body.appendChild(overlay);

    let pending = null;
    function close() {
      overlay.classList.remove("is-open");
      window.setTimeout(() => {
        overlay.hidden = true;
      }, 150);
    }
    overlay.querySelector("[data-popup-close]").addEventListener("click", close);
    overlay.addEventListener("click", (e) => {
      if (e.target === overlay) close();
    });
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && !overlay.hidden) close();
    });
    overlay.querySelector("[data-popup-via=\"whatsapp\"]").addEventListener("click", () => {
      if (!pending) return;
      const text = pending.title ? `${pending.title} ${pending.url}` : pending.url;
      window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, "_blank", "noopener");
      close();
    });
    overlay.querySelector("[data-popup-via=\"instagram\"]").addEventListener("click", async () => {
      if (!pending) return;
      const text = pending.title ? `${pending.title} ${pending.url}` : pending.url;
      try {
        await navigator.clipboard.writeText(text);
        toast("Bağlantı kopyalandı — Instagram'da gönderiye yapıştırabilirsiniz.");
      } catch (_) {
        toast(text);
      }
      window.open("https://www.instagram.com/", "_blank", "noopener");
      close();
    });

    sharePopup = {overlay, setPending: (p) => { pending = p; }};
    return sharePopup;
  }

  function openSharePopup(title, url) {
    const {overlay, setPending} = buildSharePopup();
    setPending({title, url});
    overlay.hidden = false;
    requestAnimationFrame(() => overlay.classList.add("is-open"));
  }

  function wireShareButtons() {
    document.querySelectorAll("[data-share-product]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        // Favoriler sayfasındaki kartlarda sunucudan gelen tam/imzalı bir
        // URL yok (sadece uygulama-içi gezinme için göreli bir yol
        // saklanıyor) — data-share-id varsa cart/WhatsApp mesajlarında
        // kullanılan AYNI productShareUrl() ile isteğe bağlı hesaplıyoruz.
        const url = btn.dataset.shareUrl || (btn.dataset.shareId ? await productShareUrl(btn.dataset.shareId, btn.dataset.shareTitle || "") : "");
        openSharePopup(btn.dataset.shareTitle || "", url);
      });
    });
  }

  // Ana sayfadaki "#SağlamSpot ile Kurulumunuzu Paylaşın" mozaiği/CTA'sı —
  // ÖNCEDEN business.instagramUrl'e (bize AİT OLMAYAN bir hesaba) link
  // veriyordu (gerçek kullanıcı geri bildirimi: "bu hesap bize ait değil,
  // sadece facebook sayfamız var"). Artık bir profile yönlendirmek yerine
  // wireShareButtons'taki AYNI navigator.share yöntemiyle kullanıcının
  // KENDİ paylaşımını açıyor, önerilen metinde sadece #SağlamSpot etiketi
  // var (@mention yok — o hesap bizim değil, birini yanlış etiketlemeyelim).
  function wireInstagramShare() {
    document.querySelectorAll("[data-share-instagram]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const text = btn.dataset.shareText || "#SağlamSpot";
        if (navigator.share) {
          try {
            await navigator.share({text, url: SHARE_DOMAIN});
            return;
          } catch (_) {
            // kullanıcı paylaşım sayfasını iptal etti — sessizce yok say.
            return;
          }
        }
        try {
          await navigator.clipboard.writeText(text);
          toast("Paylaşım metni kopyalandı — Instagram'da gönderiye yapıştırabilirsiniz.");
        } catch (_) {
          toast(text);
        }
        window.open("https://www.instagram.com/", "_blank", "noopener");
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

  // Mobilya temalı "ipli gece lambası" esinli yukarı çık düğmesi — tıklanınca
  // ip gerçek bir anahtar gibi önce aşağı "çekiliyor" (CSS .is-pulled),
  // sonra sayfa yukarı kayıyor. 480px'den az kaydırıldıysa gizli kalır.
  function wireScrollTopCord() {
    const btn = document.querySelector("[data-scroll-top]");
    if (!btn) return;
    const update = () => btn.classList.toggle("is-visible", window.scrollY > 480);
    update();
    window.addEventListener("scroll", update, {passive: true});
    btn.addEventListener("click", () => {
      if (btn.classList.contains("is-pulled")) return;
      btn.classList.add("is-pulled");
      window.setTimeout(() => btn.classList.remove("is-pulled"), 360);
      const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
      window.scrollTo({top: 0, behavior: reduceMotion ? "auto" : "smooth"});
    });
  }

  // SSS sayfası kategori çipleri — tıklanınca sayfa yenilenmeden ilgili
  // kategorideki <details> öğeleri dışındakiler gizlenir. JS kapalıyken
  // çipler görünür ama işlevsiz kalır; o durumda zaten 22 sorunun hepsi
  // gösterilir, hiçbir içerik kaybolmaz (progressive enhancement).
  function wireFaqFilters() {
    const row = document.querySelector("[data-faq-chip-row]");
    const list = document.querySelector("[data-faq-list]");
    if (!row || !list) return;
    const chips = [...row.querySelectorAll("[data-faq-chip]")];
    const items = [...list.querySelectorAll(".faq-item")];

    row.addEventListener("click", (e) => {
      const chip = e.target.closest("[data-faq-chip]");
      if (!chip) return;
      const category = chip.dataset.faqChip;
      chips.forEach((c) => c.classList.toggle("is-active", c === chip));
      items.forEach((item) => {
        const show = category === "all" || item.dataset.faqCategory === category;
        item.classList.toggle("is-hidden", !show);
      });
    });
  }

  // /arama'daki ızgara/liste görünüm geçişi — saglamspotcu.web.app'teki
  // GERÇEK tasarımla aynı iki ikon. Tercih <body> sınıfı üzerinden CSS
  // ile uygulanır (bkz. base.css .product-list), localStorage'ta
  // kalıcıdır (yalnızca bu tarayıcıya özel bir kolaylık — sunucuya
  // gitmiyor).
  function wireViewToggle() {
    const toggle = document.querySelector("[data-view-toggle]");
    if (!toggle) return;
    const buttons = [...toggle.querySelectorAll("[data-view-btn]")];

    function apply(view) {
      document.body.classList.toggle("view-is-list", view === "list");
      buttons.forEach((btn) => btn.classList.toggle("is-active", btn.dataset.viewBtn === view));
    }

    let saved = "grid";
    try {
      saved = localStorage.getItem("saglamspot_arama_view") || "grid";
    } catch (_) {
      // localStorage engellenmiş olabilir — varsayılan ızgarada kal.
    }
    apply(saved);

    buttons.forEach((btn) => {
      btn.addEventListener("click", () => {
        const view = btn.dataset.viewBtn;
        apply(view);
        try {
          localStorage.setItem("saglamspot_arama_view", view);
        } catch (_) {
          // yok say.
        }
      });
    });
  }

  // /arama, /sifir, /spot — arama/filtre/sıralama/kategori artık sayfayı
  // YENİDEN YÜKLEMEDEN çalışır (kullanıcı geri bildirimi: "sayfa refresh
  // atıyor, en üste scroll gidiyor, bu kadar basit bir şeyin daha dinamik
  // olması gerekir"). search.js/listing.js aynı HTML'i sunucudan basıyor,
  // burada tek fark: form submit / kategori-sekmesi-tıklama / yazarken
  // (debounce'lu) tam sayfa navigasyonu YERİNE o URL'i fetch edip
  // [data-live-filter] kökünün İÇİNİ değiştiriyoruz. Navigasyon hiç
  // olmadığı için tarayıcı scroll konumunu KENDİLİĞİNDEN korur — "en üste
  // zıplama" sorunu burada ayrı bir kod YAZMADAN çözülüyor.
  // Dinleyiciler document üzerinde (delegation) — kök her değiştiğinde
  // yeniden bağlamaya gerek yok, sadece içindeki favori/sepet/paylaş/
  // karusel/görünüm-geçişi gibi doğrudan querySelectorAll ile bağlanan
  // şeyler swap sonrası yeniden çalıştırılır (bkz. reinitLiveFilterRoot).
  function wireLiveFilter() {
    const liveRoot = () => document.querySelector("[data-live-filter]");
    if (!liveRoot()) return;

    liveRoot().setAttribute("aria-live", "polite");

    let controller = null;
    let debounceTimer = null;

    function reinitLiveFilterRoot(root) {
      // wireRevealAnimations() sayfa ilk yüklendiğinde .section/.product-grid
      // gibi öğeleri IntersectionObserver'a kaydedip görünüme girince
      // ".is-visible" ekliyor (bkz. base.css ".reveal-ready" kapsamı — bu
      // sınıf olmadan içerik opacity:0 kalır). Burada innerHTML ile
      // TAMAMEN YENİ öğeler takılıyor, hiçbiri o gözlemciye hiç
      // kaydedilmedi — sonuç: "X ürün" yazıyor ama ızgara SONSUZA KADAR
      // görünmez kalıyordu (gerçek kullanıcı geri bildirimiyle
      // yakalandı). Canlı filtre sonrası zaten bakılan bir alanı
      // yeniden "beliriyormuş" gibi anime etmenin bir anlamı da yok —
      // doğrudan görünür yapıyoruz.
      if (document.documentElement.classList.contains("reveal-ready")) {
        root.querySelectorAll(".hero, .section, .product-grid, .bento-grid, .gateway-grid, .value-card, .faq-item, .about-panel, .category-rail")
            .forEach((el) => el.classList.add("is-visible"));
      }
      wireAddButtons();
      wireFavoriteButtons();
      wireShareButtons();
      wireCardCarousels();
      wireViewToggle();
    }

    async function go(url, {push, focusRestore} = {}) {
      const root = liveRoot();
      if (!root) {
        window.location.href = url;
        return;
      }
      // Canlıda çerez localeMiddleware.js'e İLETİLMİYOR (bkz. o dosyadaki
      // not) — bu yüzden aktif dil SADECE URL'deki ?lang= üzerinden
      // taşınabiliyor. fetch ile yapılan bu "canlı filtre" istekleri
      // tam sayfa navigasyonu OLMADIĞI için <head>'in başındaki
      // localStorage betiği hiç çalışmaz; o yüzden mevcut URL'de ?lang=
      // varsa hedef URL'e burada elle taşıyoruz, yoksa filtre/arama
      // sırasında sessizce Türkçe'ye düşerdi.
      const resolved = new URL(url, window.location.href);
      const activeLang = new URL(window.location.href).searchParams.get("lang");
      if (activeLang && !resolved.searchParams.has("lang")) resolved.searchParams.set("lang", activeLang);
      url = resolved.pathname + (resolved.search ? resolved.search : "");

      if (controller) controller.abort();
      controller = new AbortController();

      if (push === "push") window.history.pushState(null, "", url);
      else if (push === "replace") window.history.replaceState(null, "", url);

      root.classList.add("is-live-loading");
      try {
        const res = await fetch(url, {signal: controller.signal, headers: {"X-Live-Filter": "1"}});
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        const html = await res.text();
        const parsed = new DOMParser().parseFromString(html, "text/html");
        const parsedRoot = parsed.querySelector("[data-live-filter]");
        if (!parsedRoot) throw new Error("data-live-filter not found in response");

        root.innerHTML = parsedRoot.innerHTML;
        if (parsed.title) document.title = parsed.title;
        reinitLiveFilterRoot(root);

        if (focusRestore) {
          const next = root.querySelector(`[name="${focusRestore.name}"]`);
          if (next) {
            next.focus();
            if (typeof next.setSelectionRange === "function") {
              try {
                next.setSelectionRange(focusRestore.start, focusRestore.end);
              } catch (_) {
                // bazı input türlerinde (örn. type=search bazı tarayıcılarda) desteklenmiyor olabilir.
              }
            }
          }
        }
      } catch (err) {
        if (err.name === "AbortError") return;
        window.location.href = url;
        return;
      } finally {
        root.classList.remove("is-live-loading");
      }
    }

    function isSamePathname(href) {
      try {
        const resolved = new URL(href, window.location.href);
        return resolved.origin === window.location.origin && resolved.pathname === window.location.pathname;
      } catch (_) {
        return false;
      }
    }

    document.addEventListener("submit", (e) => {
      const form = e.target;
      if (!(form instanceof HTMLFormElement)) return;
      if (form.method && form.method.toLowerCase() !== "get") return;
      if (!form.closest("[data-live-filter]")) return;
      e.preventDefault();
      const params = new URLSearchParams(new FormData(form));
      const qs = params.toString();
      const url = form.getAttribute("action") + (qs ? `?${qs}` : "");
      go(url, {push: "push"});
    });

    document.addEventListener("input", (e) => {
      const input = e.target;
      if (!(input instanceof HTMLInputElement) || input.name !== "q") return;
      if (!input.closest("[data-live-filter]")) return;
      const form = input.closest("form");
      if (!form) return;
      const focusRestore = {name: "q", start: input.selectionStart, end: input.selectionEnd};
      window.clearTimeout(debounceTimer);
      debounceTimer = window.setTimeout(() => {
        const params = new URLSearchParams(new FormData(form));
        const qs = params.toString();
        const url = form.getAttribute("action") + (qs ? `?${qs}` : "");
        go(url, {push: "replace", focusRestore});
      }, 380);
    });

    document.addEventListener("click", (e) => {
      if (e.defaultPrevented || e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
      const anchor = e.target.closest("a[href]");
      if (!anchor || anchor.target === "_blank" || anchor.hasAttribute("download")) return;
      if (!liveRoot() || !isSamePathname(anchor.getAttribute("href"))) return;
      e.preventDefault();
      go(anchor.getAttribute("href"), {push: "push"});
    });

    window.addEventListener("popstate", () => {
      go(window.location.href, {push: null});
    });
  }

  function wireLanguageSwitcher() {
    const select = document.getElementById("lang-switcher");
    if (!select) return;
    select.addEventListener("change", () => {
      // Firebase Hosting çerezi fonksiyona iletmediği için seçim sunucu
      // tarafında kalıcı olamıyor — localStorage'a da yazıyoruz ki
      // <head>'in en üstündeki betik sonraki sayfa yüklemelerinde bu
      // seçimi ?lang= olarak geri uygulayabilsin (bkz. layout.js).
      try {
        localStorage.setItem("saglamspot_lang", select.value);
      } catch (_) {
        // yok say.
      }
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
    wireInstagramShare();
    wireCardCarousels();
    wireScrollTopCord();
    wireFaqFilters();
    wireViewToggle();
    wireLiveFilter();
  });
})();
