const {escapeHtml} = require("./layout");

function renderProductCard(product) {
  const conditionBadge = product.isSpotProduct
    ? "<span class=\"badge badge-spot\">İkinci El</span>"
    : "<span class=\"badge badge-new\">Sıfır</span>";
  const reservedBadge = product.isReserved
    ? "<span class=\"badge badge-reserved\">Rezerve</span>"
    : "";
  const previousPriceHtml = product.previousPriceLabel
    ? `<span class="price-previous">${escapeHtml(product.previousPriceLabel)}</span>`
    : "";
  const imageHtml = product.image
    ? `<img src="${escapeHtml(product.image)}" alt="${escapeHtml(product.name)}" loading="lazy" width="320" height="240">`
    : "<div class=\"card-image-placeholder\" aria-hidden=\"true\">Görsel yok</div>";

  return `
<a class="product-card" href="${escapeHtml(product.path)}">
  <div class="card-image">
    ${imageHtml}
    <div class="card-badges">${conditionBadge}${reservedBadge}</div>
  </div>
  <div class="card-body">
    <p class="card-category">${escapeHtml(product.categoryLabel)}</p>
    <h3 class="card-name">${escapeHtml(product.name)}</h3>
    <p class="card-price">${previousPriceHtml}<span class="price-current">${escapeHtml(product.priceLabel)}</span></p>
  </div>
</a>`;
}

function renderProductGrid(products, emptyMessage = "Şu anda bu kategoride ürün bulunmuyor.") {
  if (!products.length) {
    return `<p class="empty-state">${escapeHtml(emptyMessage)}</p>`;
  }
  return `<div class="product-grid">${products.map(renderProductCard).join("\n")}</div>`;
}

module.exports = {renderProductCard, renderProductGrid};
