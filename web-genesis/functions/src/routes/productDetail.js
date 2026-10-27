const {renderLayout, escapeHtml} = require("../render/layout");
const {getProductById, incrementWebViewCount} = require("../productRepo");
const {productShareUrl} = require("../linkSigning");
const {localizedCategoryLabel} = require("../categories");
const {t} = require("../i18n");
const business = require("../businessInfo");

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
      title: "Hata",
      path: req.path,
      locale,
      bodyHtml: `<section class="not-found"><h1>Bir şeyler ters gitti</h1><p>${escapeHtml(err.message)}</p></section>`,
    }));
    return;
  }

  if (!product) {
    res.status(404).send(renderLayout({
      title: "Ürün bulunamadı",
      path: req.path,
      locale,
      bodyHtml: "<section class=\"not-found\"><h1>Ürün bulunamadı</h1><p>Bu ürün satılmış veya kaldırılmış olabilir.</p></section>",
    }));
    return;
  }

  await incrementWebViewCount(product.id);

  const galleryHtml = product.images.length
    ? `<div class="detail-gallery">${product.images.map((url, i) => `<img src="${escapeHtml(url)}" alt="${escapeHtml(product.name)} - ${i + 1}" loading="${i === 0 ? "eager" : "lazy"}">`).join("\n")}</div>`
    : "<div class=\"detail-gallery\"><div class=\"card-image-placeholder\"></div></div>";

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

  const reservedNote = product.isReserved
    ? "<p class=\"status status-error\">Rezerve</p>"
    : "";

  // lib/core/services/deeplink/deeplink_service.dart'taki
  // contactAboutProduct() ile AYNI mesaj biçimi — esnafın WhatsApp'ta
  // gördüğü metin, kaynağı web ya da mobil fark etmeksizin tutarlı olsun.
  const shareUrl = productShareUrl(product.id, product.name);
  const whatsappMessage = `Merhaba, "${product.name}" (₺${Math.round(product.price)}) ürünü ile ilgileniyorum.\n${shareUrl}`;
  const whatsappHref = business.whatsappUrl(whatsappMessage);
  const categoryLabel = localizedCategoryLabel(locale, product.category);
  const conditionLabel = t(locale, product.isSpotProduct ? "conditionUsed" : "conditionNew");

  const bodyHtml = `
<section class="product-detail">
  ${galleryHtml}
  <div class="detail-info">
    <p class="card-category">${escapeHtml(categoryLabel)} · ${escapeHtml(conditionLabel)}</p>
    <h1>${escapeHtml(product.name)}</h1>
    <p class="card-price">${previousPriceHtml}<span class="price-current" dir="ltr">${escapeHtml(product.priceLabel)}</span></p>
    ${reservedNote}
    ${product.desc ? `<p class="detail-desc">${escapeHtml(product.desc)}</p>` : ""}
    ${specHtml}
    <div class="detail-actions">
      <a class="whatsapp-link" href="${escapeHtml(whatsappHref)}" rel="noopener">${escapeHtml(t(locale, "whatsappCta"))}</a>
      <button type="button" class="cart-add-btn" data-cart-add
        data-id="${escapeHtml(product.id)}"
        data-name="${escapeHtml(product.name)}"
        data-price="${product.price}">${escapeHtml(t(locale, "addToCartCta"))}</button>
    </div>
  </div>
</section>`;

  res.set("Cache-Control", "no-cache, no-store, must-revalidate");
  const titleSuffix = t(locale, "seoProductDetailSuffix").split(" | ")[0];
  res.status(200).send(renderLayout({
    title: `${product.name} ${titleSuffix}`,
    description: product.desc || undefined,
    path: req.path,
    bodyHtml,
    locale,
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
