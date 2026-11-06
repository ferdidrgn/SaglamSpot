const {escapeHtml} = require("./layout");
const {t, DEFAULT_LOCALE} = require("../i18n");
const {localizedCategoryLabel, categoryColor} = require("../categories");

/**
 * "Asimetrik Vitrin Kartı" — lib/core/widgets/custom_product_card.dart'taki
 * GERÇEK Flutter kart tasarımının HTML/CSS karşılığı: fotoğraf kartın
 * TAMAMINI kaplar, alt kenarda karartma (scrim) + isim/kategori/fiyat
 * şeridi, sağ üst köşede keskin/flush durum etiketi (SIFIR/İKİNCİ EL),
 * köşeler simetrik değil (sağ üst keskin, sol alt belirgin yuvarlak).
 *
 * Flutter'daki kartta "sepete ekle" YOK (sadece ürün detayına gider) —
 * ama web-genesis'in kendi sepet->toplu WhatsApp özelliği (Faz 1) bu
 * ızgaradan besleniyor, bu yüzden sol üstte Flutter'ın galeri ikonunun
 * durduğu noktada küçük, camsı bir sepet ikon butonu bırakıldı (metin
 * yok — görsel dili bozmadan işlevi korur).
 */
const CART_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><circle cx=\"9\" cy=\"20\" r=\"1.4\" fill=\"currentColor\" stroke=\"none\"/><circle cx=\"18\" cy=\"20\" r=\"1.4\" fill=\"currentColor\" stroke=\"none\"/><path d=\"M2.5 3h2l2.2 11.2a2 2 0 0 0 2 1.6h7.8a2 2 0 0 0 2-1.6L20.5 7H6\"/></svg>";

function renderProductCard(product, locale = DEFAULT_LOCALE) {
  const isSpot = product.isSpotProduct;
  const tagLabel = isSpot ? t(locale, "usedProductBadge") : t(locale, "productCardNewBadge");
  const tagClass = isSpot ? "pcard-tag-used" : "pcard-tag-new";
  const reservedBadge = product.isReserved
    ? "<span class=\"pcard-reserved\">Rezerve</span>"
    : "";
  const previousPriceHtml = product.previousPriceLabel
    ? `<span class="pcard-price-prev" dir="ltr">${escapeHtml(product.previousPriceLabel)}</span>`
    : "";
  const catColor = categoryColor(product.category);
  const imageHtml = product.image
    ? `<img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.name)}" loading="lazy" width="320" height="320">`
    : "<div class=\"pcard-placeholder\" aria-hidden=\"true\"></div>";

  return `
<div class="pcard">
  <a class="pcard-link" href="${escapeHtml(product.path)}">
    <div class="pcard-media">
      ${imageHtml}
      <div class="pcard-scrim" aria-hidden="true"></div>
      <span class="pcard-tag ${tagClass}">${escapeHtml(tagLabel)}</span>
      ${reservedBadge}
      <div class="pcard-info">
        <div class="pcard-info-text">
          <p class="pcard-name">${escapeHtml(product.name)}</p>
          <p class="pcard-cat" style="--cat-color:${catColor}">${escapeHtml(localizedCategoryLabel(locale, product.category))}</p>
        </div>
        <span class="pcard-price">${previousPriceHtml}<span dir="ltr">${escapeHtml(product.priceLabel)}</span></span>
      </div>
    </div>
  </a>
  <button type="button" class="pcard-cart-btn" data-cart-add
    aria-label="${escapeHtml(t(locale, "addToCartCta"))}"
    data-id="${escapeHtml(product.id)}"
    data-name="${escapeHtml(product.name)}"
    data-price="${product.price}">${CART_ICON}</button>
</div>`;
}

function renderProductGrid(products, locale = DEFAULT_LOCALE, emptyMessage = null) {
  if (!products.length) {
    return `<p class="empty-state">${escapeHtml(emptyMessage || t(locale, "searchEmptyTitle"))}</p>`;
  }
  return `<div class="product-grid">${products.map((p) => renderProductCard(p, locale)).join("\n")}</div>`;
}

module.exports = {renderProductCard, renderProductGrid};
