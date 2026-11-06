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
        ".hero, .section, .product-card, .value-card, .faq-item, .about-panel, .category-rail",
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
    wireLanguageSwitcher();
    wireHeaderScroll();
    wireRevealAnimations();
  });
})();
