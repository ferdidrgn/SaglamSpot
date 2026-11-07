const {renderLayout, escapeHtml} = require("../render/layout");
const {getProductById, incrementWebViewCount, listActiveProducts} = require("../productRepo");
const {productShareUrl} = require("../linkSigning");
const {localizedCategoryLabel, categoryColor} = require("../categories");
const {renderProductGrid} = require("../render/productCard");
const {ICONS} = require("../render/icons");
const {t} = require("../i18n");
const business = require("../businessInfo");

const ARROW_LEFT = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M15 5l-7 7 7 7\"/></svg>";
const ARROW_RIGHT = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M9 5l7 7-7 7\"/></svg>";
const EXPAND_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><path d=\"M4 9V4h5M15 4h5v5M20 15v5h-5M9 20H4v-5\"/></svg>";
const CLOSE_ICON = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M6 6l12 12M18 6L6 18\"/></svg>";
const FAV_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12 21s-7.5-4.6-10-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 10 6c-2.5 4.4-10 9-10 9z\"/></svg>";
const SHARE_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><circle cx=\"18\" cy=\"5\" r=\"2.5\"/><circle cx=\"6\" cy=\"12\" r=\"2.5\"/><circle cx=\"18\" cy=\"19\" r=\"2.5\"/><path d=\"M8.2 10.8l7.6-4.6M8.2 13.2l7.6 4.6\"/></svg>";
const BACK_ICON = "<svg width=\"20\" height=\"20\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M15 5l-7 7 7 7\"/></svg>";
const EYE_ICON = "<svg width=\"15\" height=\"15\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><path d=\"M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7z\"/><circle cx=\"12\" cy=\"12\" r=\"3\"/></svg>";
const CHEVRON_RIGHT = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M9 5l7 7-7 7\"/></svg>";
const CATEGORY_ICON = "<svg width=\"14\" height=\"14\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M20 12.5L12.5 20 3 10.5V3h7.5L20 12.5z\"/><circle cx=\"7.5\" cy=\"7.5\" r=\"1.5\" fill=\"var(--color-surface)\"/></svg>";
const CHAT_ICON = "<svg width=\"20\" height=\"20\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" aria-hidden=\"true\"><path d=\"M4 4h16v12H8l-4 4V4z\"/></svg>";
const PHONE_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" aria-hidden=\"true\"><path d=\"M6.5 4h3l1.5 4-2 1.5a12 12 0 0 0 5.5 5.5l1.5-2 4 1.5v3a2 2 0 0 1-2.2 2A17 17 0 0 1 4.5 6.2 2 2 0 0 1 6.5 4z\"/></svg>";
const BAG_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><path d=\"M6 8h12l1 12H5L6 8z\"/><path d=\"M9 8V6a3 3 0 0 1 6 0v2\"/></svg>";

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

  // Galerideki sivri uçlu şerit etiket — ürün kartındaki (.pcard-tag)
  // AYNI görsel dil, "SIFIR ÜRÜN"/"İKİNCİ EL" uzun biçimleriyle (Flutter
  // detay sayfasındaki gibi kısa "SIFIR" değil).
  const detailTagLabel = product.isSold ? "SATILDI" : (product.isSpotProduct ? t(locale, "usedProductBadge") : t(locale, "newProductBadge"));
  const detailTagClass = product.isSold ? "pcard-tag-sold" : (product.isSpotProduct ? "pcard-tag-used" : "pcard-tag-new");
  const galleryTagHtml = `<span class="pcard-tag pgallery-tag ${detailTagClass}">${escapeHtml(detailTagLabel)}</span>`;

  const galleryHtml = images.length ? `
<div class="pgallery" data-gallery data-images="${imagesJsonAttr}">
  <div class="pgallery-main">
    <img class="pgallery-main-img" data-gallery-main src="${escapeHtml(images[0])}" alt="${escapeHtml(product.name)}" loading="eager">
    ${galleryTagHtml}
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
</div>` : `<div class="pgallery"><div class="pgallery-main">${galleryTagHtml}<div class="card-image-placeholder"></div></div></div>`;

  const previousPriceHtml = product.previousPriceLabel
    ? `<span class="price-previous" dir="ltr">${escapeHtml(product.previousPriceLabel)}</span>`
    : "";

  // "Ölçüler"/"Malzeme" için ARB'de kaynak yok (ne Flutter'ın kendisi de
  // bu alan etiketlerini l10n üzerinden çekmiyor) — bilerek Türkçe
  // kalıyor, brief'in "yeniden çevirme" uyarısına uyarak. Durum/Teslimat/
  // Konum zaten ARB'de var (specDelivery/specDeliveryValue/specLocation).
  const extraSpecRows = [];
  if (product.dimensions) extraSpecRows.push(["Ölçüler", product.dimensions]);
  if (product.material) extraSpecRows.push(["Malzeme", product.material]);
  const extraSpecHtml = extraSpecRows.length
    ? `<dl class="spec-list">${extraSpecRows.map(([k, v]) => `<dt>${escapeHtml(k)}</dt><dd>${escapeHtml(v)}</dd>`).join("\n")}</dl>`
    : "";

  // saglamspotcu.web.app'teki (bu projenin KENDİ Flutter web derlemesi)
  // GERÇEK ürün detay sayfasıyla AYNI 2x2 bilgi ızgarası.
  const categoryLabel = localizedCategoryLabel(locale, product.category);
  const conditionShortLabel = product.isSold ? "SATILDI" : (product.isSpotProduct ? t(locale, "usedProductBadge") : t(locale, "newProductBadge"));
  const infoTiles = [
    [ICONS.tag, t(locale, "category"), categoryLabel],
    [ICONS.verified, t(locale, "condition"), conditionShortLabel],
    [ICONS.truck, t(locale, "specDelivery"), product.wearTierLabel || t(locale, "specDeliveryValue")],
    [ICONS.map, t(locale, "specLocation"), `İçerenköy, ${business.address.city}`],
  ];
  const infoGridHtml = `<div class="pdetail-info-grid">${infoTiles.map(([icon, label, value]) => `
    <div class="pdetail-info-tile">
      <span class="pdetail-info-icon">${icon}</span>
      <span class="pdetail-info-text"><span>${escapeHtml(label)}</span><strong>${escapeHtml(value)}</strong></span>
    </div>`).join("")}</div>`;

  // Güven rozeti şeridi — home.js'teki ticker ile AYNI 3 metin.
  const trustRowHtml = `<div class="pdetail-trust-row">
    <span class="pdetail-trust-pill">${ICONS.verified}${escapeHtml(t(locale, "productTrustBadgeVerified"))}</span>
    <span class="pdetail-trust-pill">${ICONS.handshake}${escapeHtml(t(locale, "productTrustBadgeNegotiate"))}</span>
    <span class="pdetail-trust-pill">${ICONS.truck}${escapeHtml(t(locale, "productTrustBadgeDelivery"))}</span>
  </div>`;

  const sellerCardHtml = `
  <a class="pdetail-seller-card" href="/hakkimizda">
    <span class="pdetail-seller-avatar">${ICONS.storefront}</span>
    <span class="pdetail-seller-text">
      <strong>${escapeHtml(business.brandName)} ${ICONS.verified}</strong>
      <span>${escapeHtml(t(locale, "sellerTrustLine"))}</span>
    </span>
    <span class="pdetail-seller-chevron">${CHEVRON_RIGHT}</span>
  </a>`;

  const howToStepIcons = [CHAT_ICON, ICONS.tag, ICONS.truck];
  const howToHtml = `
  <div class="pdetail-howto">
    <h2>${escapeHtml(t(locale, "howToBuyTitle"))}</h2>
    ${[1, 2, 3].map((n) => `
    <div class="pdetail-howto-step">
      <span class="pdetail-howto-num">${howToStepIcons[n - 1]}</span>
      <span class="pdetail-howto-text"><strong>${n}. ${escapeHtml(t(locale, `howToBuyStep${n}Title`))}</strong><span>${escapeHtml(t(locale, `howToBuyStep${n}Desc`))}</span></span>
    </div>`).join("")}
  </div>`;

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
  const whatsappHref = business.whatsappUrl(whatsappMessage, locale);
  const cartButtonHtml = product.isSold ? "" : `
      <button type="button" class="pdetail-cta-primary" data-cart-add
        data-id="${escapeHtml(product.id)}"
        data-name="${escapeHtml(product.name)}"
        data-price="${product.price}"
        data-image="${escapeHtml(product.images[0] || "")}"
        data-path="${escapeHtml(req.path)}">${BAG_ICON}${escapeHtml(t(locale, "addToCartCta"))}</button>`;

  const favButtonHtml = `
      <button type="button" class="pcard-icon-btn pcard-fav-btn" data-favorite-toggle
        aria-label="Favorilere ekle"
        data-id="${escapeHtml(product.id)}"
        data-name="${escapeHtml(product.name)}"
        data-price="${product.price}"
        data-image="${escapeHtml(product.image || "")}"
        data-path="${escapeHtml(req.path)}">${FAV_ICON}</button>`;

  // Web Share API varsa (çoğu mobil tarayıcı) native paylaşım sayfası
  // açılır; yoksa main.js linki panoya kopyalayıp küçük bir toast gösterir.
  const shareButtonHtml = `
      <button type="button" class="pcard-icon-btn" data-share-product
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
  <h2>${escapeHtml(t(locale, "similarProducts"))}</h2>
  ${renderProductGrid(sameCategory, locale)}
</section>`;
      }
    } catch (_) {
      // Vitrin çekilemedi — ana ürün zaten gösterildi, bu bölüm bilerek
      // sessizce atlanır (sayfanın tamamını bozmaz).
    }
  }

  const viewCountHtml = !product.isSold && product.viewCount > 0 ? `
    <p class="pdetail-views">${EYE_ICON}${escapeHtml(t(locale, "productViewCountLabel", {count: product.viewCount}))}</p>` : "";

  const bodyHtml = `
<section class="product-detail${product.isSold ? " product-detail-sold" : ""}">
  <div class="pdetail-media">
    <div class="pdetail-toolbar">
      <a class="pcard-icon-btn pdetail-back-btn" href="/arama" aria-label="Geri">${BACK_ICON}</a>
      <span class="pdetail-toolbar-right">${shareButtonHtml}${favButtonHtml}</span>
    </div>
    ${galleryHtml}
  </div>
  <div class="detail-info">
    <p class="card-category" style="--cat-color:${categoryColor(product.category)}">${CATEGORY_ICON}${escapeHtml(categoryLabel)}</p>
    <h1>${escapeHtml(product.name)}</h1>
    <p class="card-price">${previousPriceHtml}<span class="price-current" dir="ltr">${escapeHtml(product.priceLabel)}</span></p>
    ${viewCountHtml}
    ${soldNote}
    ${reservedNote}
    ${trustRowHtml}
    ${product.desc ? `
    <div class="pdetail-card">
      <h2>${escapeHtml(t(locale, "productDescriptionTitle"))}</h2>
      <p class="detail-desc">${escapeHtml(product.desc)}</p>
    </div>` : ""}
    ${extraSpecHtml}
    ${infoGridHtml}
    ${sellerCardHtml}
    ${howToHtml}
    <div class="detail-actions">
      <a class="pdetail-phone-btn" href="tel:+${business.phoneNumberIntl}" aria-label="${escapeHtml(t(locale, "callCta"))}">${PHONE_ICON}</a>
      ${product.isSold
        ? `<a class="pdetail-cta-primary" href="${escapeHtml(whatsappHref)}" rel="noopener">${CHAT_ICON}Benzerini Sor</a>`
        : `${cartButtonHtml}<a class="pdetail-cta-outline" href="${escapeHtml(whatsappHref)}" rel="noopener">${CHAT_ICON}${escapeHtml(t(locale, "whatsappCta"))}</a>`}
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
