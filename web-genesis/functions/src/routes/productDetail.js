const {renderLayout, escapeHtml} = require("../render/layout");
const {getProductById, incrementWebViewCount, listActiveProducts} = require("../productRepo");
const {productShareUrl} = require("../linkSigning");
const {localizedCategoryLabel} = require("../categories");
const {renderProductGrid} = require("../render/productCard");
const {t} = require("../i18n");
const business = require("../businessInfo");

const ARROW_LEFT = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M15 5l-7 7 7 7\"/></svg>";
const ARROW_RIGHT = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M9 5l7 7-7 7\"/></svg>";
const EXPAND_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><path d=\"M4 9V4h5M15 4h5v5M20 15v5h-5M9 20H4v-5\"/></svg>";
const CLOSE_ICON = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M6 6l12 12M18 6L6 18\"/></svg>";
const FAV_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12 21s-7.5-4.6-10-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 10 6c-2.5 4.4-10 9-10 9z\"/></svg>";
const SHARE_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><circle cx=\"18\" cy=\"5\" r=\"2.5\"/><circle cx=\"6\" cy=\"12\" r=\"2.5\"/><circle cx=\"18\" cy=\"19\" r=\"2.5\"/><path d=\"M8.2 10.8l7.6-4.6M8.2 13.2l7.6 4.6\"/></svg>";

/**
 * İmza (sig) doğrulaması burada BİLEREK ziyareti engellemek için
 * kullanılmıyor — lib/core/config/app_router.dart'taki aynı rota,
 * `!isSecure && !kIsWeb` koşuluyla bunu sadece NATİF mobilde zorunlu
 * kılıyor; web'de imzasız/doğrudan linkler (SEO, paylaşılan linkler,
 * doğrudan yazılan adresler) her zaman içeriği gösterebilmeli. Signature
 * sadece kendi ürettiğimiz linklerin mobil uygulamayla uyumlu olması için
 * var.
 */
module.exports = async function productDetailRoute(req, res) {
  const locale = req.locale;
  const rawParam = req.params.slugWithId || "";
  const fullParam = decodeURIComponent(rawParam);
  const lastDash = fullParam.lastIndexOf("-");

  if (lastDash === -1) {
    res.status(404).send(renderLayout({
    req,
      title: "Geçersiz bağlantı",
      path: req.path,
      locale,
      bodyHtml: "<section class=\"not-found\"><h1>Geçersiz bağlantı</h1><p>Ürün bağlantısı hatalı görünüyor.</p></section>",
    }));
    return;
  }

  const productId = fullParam.slice(lastDash + 1);

  let product = null;
  try {
    product = await getProductById(productId);
  } catch (err) {
    res.status(500).send(renderLayout({
    req,
      title: "Hata",
      path: req.path,
      locale,
      bodyHtml: `<section class="not-found"><h1>Bir şeyler ters gitti</h1><p>${escapeHtml(err.message)}</p></section>`,
    }));
    return;
  }

  if (!product) {
    res.status(404).send(renderLayout({
    req,
      title: "Ürün bulunamadı",
      path: req.path,
      locale,
      bodyHtml: "<section class=\"not-found\"><h1>Ürün bulunamadı</h1><p>Bu ürün satılmış veya kaldırılmış olabilir.</p></section>",
    }));
    return;
  }

  await incrementWebViewCount(product.id);

  // Birden fazla görsel varsa tam ekran, kaydırılabilir/oklu bir galeri
  // (lightbox) — bkz. public/static/js/product-gallery.js. Tek görsel/hiç
  // görsel yoksa basitçe statik kalır, JS'e hiç ihtiyaç duymaz.
  const images = product.images;
  const hasMultiple = images.length > 1;
  const imagesJsonAttr = escapeHtml(JSON.stringify(images));

  const arrowsHtml = hasMultiple ? `
      <button type="button" class="pgallery-arrow pgallery-prev" data-gallery-prev aria-label="Önceki görsel">${ARROW_LEFT}</button>
      <button type="button" class="pgallery-arrow pgallery-next" data-gallery-next aria-label="Sonraki görsel">${ARROW_RIGHT}</button>` : "";

  const thumbsHtml = hasMultiple ? `
    <div class="pgallery-thumbs">${images.map((url, i) => `
      <button type="button" class="pgallery-thumb${i === 0 ? " is-active" : ""}" data-gallery-thumb data-index="${i}">
        <img src="${escapeHtml(url)}" alt="${escapeHtml(product.name)} - ${i + 1}" loading="lazy">
      </button>`).join("")}</div>` : "";

  const galleryHtml = images.length ? `
<div class="pgallery" data-gallery data-images="${imagesJsonAttr}">
  <div class="pgallery-main">
    <img class="pgallery-main-img" data-gallery-main src="${escapeHtml(images[0])}" alt="${escapeHtml(product.name)}" loading="eager">
    ${arrowsHtml}
    <button type="button" class="pgallery-expand" data-gallery-expand aria-label="Tam ekran görüntüle">${EXPAND_ICON}</button>
    ${hasMultiple ? `<span class="pgallery-counter" data-gallery-counter>1 / ${images.length}</span>` : ""}
  </div>
  ${thumbsHtml}
</div>
<div class="pgallery-lightbox" data-gallery-lightbox hidden>
  <button type="button" class="pgallery-lightbox-close" data-gallery-close aria-label="Kapat">${CLOSE_ICON}</button>
  <img class="pgallery-lightbox-img" data-gallery-lightbox-img src="" alt="${escapeHtml(product.name)}">
  ${arrowsHtml}
  ${hasMultiple ? `<span class="pgallery-counter pgallery-lightbox-counter" data-gallery-counter>1 / ${images.length}</span>` : ""}
</div>` : "<div class=\"pgallery\"><div class=\"pgallery-main\"><div class=\"card-image-placeholder\"></div></div></div>";

  const previousPriceHtml = product.previousPriceLabel
    ? `<span class="price-previous" dir="ltr">${escapeHtml(product.previousPriceLabel)}</span>`
    : "";

  // "Ölçüler"/"Malzeme"/"Rezerve" için ARB'de kaynak yok (ne Flutter'ın
  // kendisi de bu alan etiketlerini l10n üzerinden çekmiyor) — bilerek
  // Türkçe kalıyor, brief'in "yeniden çevirme" uyarısına uyarak.
  const specRows = [];
  if (product.dimensions) specRows.push(["Ölçüler", product.dimensions]);
  if (product.material) specRows.push(["Malzeme", product.material]);
  if (product.wearTierLabel) specRows.push(["Durum", product.wearTierLabel]);
  const specHtml = specRows.length
    ? `<dl class="spec-list">${specRows.map(([k, v]) => `<dt>${escapeHtml(k)}</dt><dd>${escapeHtml(v)}</dd>`).join("\n")}</dl>`
    : "";

  const reservedNote = product.isReserved && !product.isSold
    ? "<p class=\"status status-error\">Rezerve</p>"
    : "";
  // Satılmış ürün — hâlâ görüntülenebilir (paylaşılan linkler/arşiv) ama
  // artık mevcut değil: WhatsApp CTA'sı "ilgileniyorum" yerine benzerlerine
  // yönlendirir, sepete ekleme tamamen kaldırılır.
  const soldNote = product.isSold
    ? "<p class=\"status status-error\">Bu ürün satıldı — artık mevcut değil.</p>"
    : "";

  // lib/core/services/deeplink/deeplink_service.dart'taki
  // contactAboutProduct() ile AYNI mesaj biçimi — esnafın WhatsApp'ta
  // gördüğü metin, kaynağı web ya da mobil fark etmeksizin tutarlı olsun.
  const shareUrl = productShareUrl(product.id, product.name);
  const whatsappMessage = product.isSold
    ? `Merhaba, "${product.name}" ürününe benzer bir şey arıyorum, elinizde var mı?`
    : `Merhaba, "${product.name}" (₺${Math.round(product.price)}) ürünü ile ilgileniyorum.\n${shareUrl}`;
  const whatsappHref = business.whatsappUrl(whatsappMessage);
  const categoryLabel = localizedCategoryLabel(locale, product.category);
  const conditionLabel = t(locale, product.isSpotProduct ? "conditionUsed" : "conditionNew");
  const cartButtonHtml = product.isSold ? "" : `
      <button type="button" class="cart-add-btn" data-cart-add
        data-id="${escapeHtml(product.id)}"
        data-name="${escapeHtml(product.name)}"
        data-price="${product.price}">${escapeHtml(t(locale, "addToCartCta"))}</button>`;

  const favButtonHtml = `
      <button type="button" class="cart-add-btn detail-icon-btn" data-favorite-toggle
        aria-label="Favorilere ekle"
        data-id="${escapeHtml(product.id)}"
        data-name="${escapeHtml(product.name)}"
        data-price="${product.price}"
        data-image="${escapeHtml(product.image || "")}"
        data-path="${escapeHtml(req.path)}">${FAV_ICON}</button>`;

  // Web Share API varsa (çoğu mobil tarayıcı) native paylaşım sayfası
  // açılır; yoksa main.js linki panoya kopyalayıp küçük bir toast gösterir.
  const shareButtonHtml = `
      <button type="button" class="cart-add-btn detail-icon-btn" data-share-product
        data-share-url="${escapeHtml(shareUrl)}"
        data-share-title="${escapeHtml(product.name)}"
        aria-label="Paylaş">${SHARE_ICON}</button>`;

  // Benzer ürünler — aynı kategoriden, kendisi hariç, en fazla 4 tane.
  // home.js'teki gibi listActiveProducts zaten isSold==false döndürüyor.
  let similarHtml = "";
  if (!product.isSold) {
    try {
      const sameCategory = (await listActiveProducts({limit: 200}))
          .filter((p) => p.category === product.category && p.id !== product.id)
          .slice(0, 4);
      if (sameCategory.length) {
        similarHtml = `
<section class="section">
  <h2>Benzer Ürünler</h2>
  ${renderProductGrid(sameCategory, locale)}
</section>`;
      }
    } catch (_) {
      // Vitrin çekilemedi — ana ürün zaten gösterildi, bu bölüm bilerek
      // sessizce atlanır (sayfanın tamamını bozmaz).
    }
  }

  const bodyHtml = `
<section class="product-detail${product.isSold ? " product-detail-sold" : ""}">
  ${galleryHtml}
  <div class="detail-info">
    <p class="card-category">${escapeHtml(categoryLabel)} · ${escapeHtml(conditionLabel)}</p>
    <h1>${escapeHtml(product.name)}</h1>
    <p class="card-price">${previousPriceHtml}<span class="price-current" dir="ltr">${escapeHtml(product.priceLabel)}</span></p>
    ${soldNote}
    ${reservedNote}
    ${product.desc ? `<p class="detail-desc">${escapeHtml(product.desc)}</p>` : ""}
    ${specHtml}
    <div class="detail-actions">
      <a class="whatsapp-link" href="${escapeHtml(whatsappHref)}" rel="noopener">${escapeHtml(product.isSold ? "Benzerini Sor" : t(locale, "whatsappCta"))}</a>${cartButtonHtml}${favButtonHtml}${shareButtonHtml}
    </div>
  </div>
</section>
${similarHtml}`;

  res.set("Cache-Control", "no-cache, no-store, must-revalidate");
  const titleSuffix = t(locale, "seoProductDetailSuffix").split(" | ")[0];
  res.status(200).send(renderLayout({
    req,
    title: `${product.name} ${titleSuffix}`,
    description: product.desc || undefined,
    path: req.path,
    image: product.image || undefined,
    bodyHtml,
    locale,
    extraScripts: images.length >= 1 ? ["static/js/product-gallery.js"] : [],
    jsonLd: {
      "@context": "https://schema.org",
      "@type": "Product",
      "name": product.name,
      "description": product.desc || undefined,
      "image": product.images,
      "category": categoryLabel,
      "offers": {
        "@type": "Offer",
        "priceCurrency": "TRY",
        "price": product.price,
        "availability": product.isReserved
          ? "https://schema.org/LimitedAvailability"
          : "https://schema.org/InStock",
      },
    },
  }));
};
