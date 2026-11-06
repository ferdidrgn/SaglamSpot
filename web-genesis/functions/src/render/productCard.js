const {escapeHtml} = require("./layout");
const {t, DEFAULT_LOCALE} = require("../i18n");
const {localizedCategoryLabel} = require("../categories");

// Metin yok (yeniden çeviri gerektirmez) — sadece hover'da beliren bir
// "incele" ok ikonu, ürün kartının tamamı zaten tıklanabilir bağlantı.
const VIEW_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><path d=\"M5 12h14M13 6l6 6-6 6\"/></svg>";

function renderProductCard(product, locale = DEFAULT_LOCALE) {
  const conditionBadge = product.isSpotProduct
    ? `<span class="badge badge-spot">${escapeHtml(t(locale, "conditionUsed"))}</span>`
    : `<span class="badge badge-new">${escapeHtml(t(locale, "conditionNew"))}</span>`;
  // "Rezerve" için ARB'de kaynak yok (brief: yeniden çeviri yok) — bilerek
  // Türkçe kalıyor, tek kelimelik az görünen bir rozet.
  const reservedBadge = product.isReserved
    ? "<span class=\"badge badge-reserved\">Rezerve</span>"
    : "";
  const previousPriceHtml = product.previousPriceLabel
    ? `<span class="price-previous" dir="ltr">${escapeHtml(product.previousPriceLabel)}</span>`
    : "";
  const imageHtml = product.image
    ? `<img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.name)}" loading="lazy" width="320" height="240">`
    : "<div class=\"card-image-placeholder\" aria-hidden=\"true\"></div>";

  return `
<div class="product-card">
  <a class="card-link" href="${escapeHtml(product.path)}">
    <div class="card-image">
      ${imageHtml}
      <div class="card-badges">${conditionBadge}${reservedBadge}</div>
      <div class="card-view-affordance" aria-hidden="true"><span>${VIEW_ICON}</span></div>
    </div>
    <div class="card-body">
      <p class="card-category">${escapeHtml(localizedCategoryLabel(locale, product.category))}</p>
      <h3 class="card-name">${escapeHtml(product.name)}</h3>
      <p class="card-price">${previousPriceHtml}<span class="price-current" dir="ltr">${escapeHtml(product.priceLabel)}</span></p>
    </div>
  </a>
  <button type="button" class="cart-add-btn cart-add-btn-card" data-cart-add
    data-id="${escapeHtml(product.id)}"
    data-name="${escapeHtml(product.name)}"
    data-price="${product.price}">${escapeHtml(t(locale, "addToCartCta"))}</button>
</div>`;
}

function renderProductGrid(products, locale = DEFAULT_LOCALE, emptyMessage = null) {
  if (!products.length) {
    return `<p class="empty-state">${escapeHtml(emptyMessage || t(locale, "searchEmptyTitle"))}</p>`;
  }
  return `<div class="product-grid">${products.map((p) => renderProductCard(p, locale)).join("\n")}</div>`;
}

module.exports = {renderProductCard, renderProductGrid};
