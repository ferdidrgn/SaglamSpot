const {escapeHtml} = require("./layout");
const {ICONS} = require("./icons");
const {t} = require("../i18n");

/**
 * Güven şeridi (kayan rozet satırı) — home.js'teki ana sayfa hero'sunun
 * altında zaten vardı, şimdi /sifir ve /spot sayfalarının da kendi
 * hero'sunun altında aynısını kullanabilmesi için buraya taşındı (DRY).
 */
function renderTicker(locale) {
  const items = [
    [ICONS.verified, t(locale, "productTrustBadgeVerified")],
    [ICONS.handshake, t(locale, "productTrustBadgeNegotiate")],
    [ICONS.truck, t(locale, "productTrustBadgeDelivery")],
    [ICONS.storefront, t(locale, "sellerTrustLine")],
    [ICONS.award, t(locale, "usp1Title")],
    [ICONS.sparkle, t(locale, "qualityFurniture")],
  ];
  const itemsHtml = items.map(([icon, label]) => `<span class="ticker-item">${icon}${escapeHtml(label)}</span>`).join("");
  return `<div class="ticker" aria-hidden="true"><div class="ticker-track">${itemsHtml}${itemsHtml}</div></div>`;
}

module.exports = {renderTicker};
