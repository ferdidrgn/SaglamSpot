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
const FAV_ICON = "<svg width=\"15\" height=\"15\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12 21s-7.5-4.6-10-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 10 6c-2.5 4.4-10 9-10 9z\"/></svg>";
const CHEVRON_LEFT = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.4\" aria-hidden=\"true\"><path d=\"M15 5l-7 7 7 7\"/></svg>";
const CHEVRON_RIGHT = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.4\" aria-hidden=\"true\"><path d=\"M9 5l7 7-7 7\"/></svg>";
// home_page_web.dart'taki newArrivalsProducts ile AYNI eşik (son 10 gün).
const NEW_ARRIVAL_MS = 10 * 24 * 60 * 60 * 1000;

function renderProductCard(product, locale = DEFAULT_LOCALE) {
  const isSpot = product.isSpotProduct;
  // "Satıldı" arşivi (/arama?condition=sold) — ürün artık mevcut değil,
  // kart bilerek soluk/gri gösterilir ve sepete eklenemez (cart-btn yok).
  // ARB'de "satıldı" tek kelimelik kaynak yok, bilerek Türkçe literal.
  const tagLabel = product.isSold ? "SATILDI" : (isSpot ? t(locale, "usedProductBadge") : t(locale, "productCardNewBadge"));
  const tagClass = product.isSold ? "pcard-tag-sold" : (isSpot ? "pcard-tag-used" : "pcard-tag-new");
  const reservedBadge = product.isReserved && !product.isSold
    ? "<span class=\"pcard-reserved\">Rezerve</span>"
    : "";
  const previousPriceHtml = product.previousPriceLabel
    ? `<span class="pcard-price-prev" dir="ltr">${escapeHtml(product.previousPriceLabel)}</span>`
    : "";
  const catColor = categoryColor(product.category);

  // Flutter'daki CustomProductCard'ın ProductImageSwitcher'ı gibi: birden
  // fazla görsel varsa kartın KENDİ üzerinde (detaya gitmeden) ok + üstte
  // nokta göstergeli mini bir karusel. Tek görselde sade kalır.
  const images = (product.images && product.images.length ? product.images : [product.image]).filter(Boolean);
  const hasMultiple = images.length > 1;
  const imageHtml = images.length
    ? `<img class="pcard-img" data-card-img src="${escapeHtml(images[0])}" alt="${escapeHtml(product.name)}" loading="lazy" width="320" height="320">`
    : "<div class=\"pcard-placeholder\" aria-hidden=\"true\"></div>";
  const carouselHtml = hasMultiple ? `
      <div class="pcard-dots" data-card-dots aria-hidden="true">${images.map((_, i) => `<span class="pcard-dot${i === 0 ? " is-active" : ""}"></span>`).join("")}</div>
      <button type="button" class="pcard-nav pcard-nav-prev" data-card-prev aria-label="Önceki görsel">${CHEVRON_LEFT}</button>
      <button type="button" class="pcard-nav pcard-nav-next" data-card-next aria-label="Sonraki görsel">${CHEVRON_RIGHT}</button>` : "";
  const imagesJsonAttr = hasMultiple ? ` data-card-images="${escapeHtml(JSON.stringify(images))}"` : "";

  const isNewArrival = !product.isSold && product.createdAtSort &&
    (Date.now() - product.createdAtSort) <= NEW_ARRIVAL_MS;
  // ARB'de bağımsız bir "Yeni" anahtarı yok (brief: yeniden çeviri yok) —
  // mevcut kategori etiketinin yanına bilerek Türkçe literal ekleniyor,
  // "Rezerve" emsaliyle aynı gerekçe.
  const categoryLabelHtml = `${escapeHtml(localizedCategoryLabel(locale, product.category))}${isNewArrival ? " · <span class=\"pcard-new-flag\">YENİ</span>" : ""}`;

  const cartBtnHtml = product.isSold ? "" : `
  <button type="button" class="pcard-cart-btn" data-cart-add
    aria-label="${escapeHtml(t(locale, "addToCartCta"))}"
    data-id="${escapeHtml(product.id)}"
    data-name="${escapeHtml(product.name)}"
    data-price="${product.price}">${CART_ICON}</button>`;

  const favBtnHtml = `
  <button type="button" class="pcard-cart-btn pcard-fav-btn" data-favorite-toggle
    aria-label="Favorilere ekle"
    data-id="${escapeHtml(product.id)}"
    data-name="${escapeHtml(product.name)}"
    data-price="${product.price}"
    data-image="${escapeHtml(product.image || "")}"
    data-path="${escapeHtml(product.path)}">${FAV_ICON}</button>`;

  return `
<div class="pcard${product.isSold ? " pcard-sold" : ""}" style="--cat-glow:${catColor}"${imagesJsonAttr}>
  <a class="pcard-link" href="${escapeHtml(product.path)}">
    <div class="pcard-media">
      ${imageHtml}
      <div class="pcard-scrim" aria-hidden="true"></div>
      ${carouselHtml}
      <span class="pcard-tag ${tagClass}">${escapeHtml(tagLabel)}</span>
      ${reservedBadge}
      <div class="pcard-info">
        <div class="pcard-info-text">
          <p class="pcard-name">${escapeHtml(product.name)}</p>
          <p class="pcard-cat" style="--cat-color:${catColor}">${categoryLabelHtml}</p>
        </div>
        <span class="pcard-price">${previousPriceHtml}<span dir="ltr">${escapeHtml(product.priceLabel)}</span></span>
      </div>
    </div>
  </a>${cartBtnHtml}${favBtnHtml}
</div>`;
}

function renderProductGrid(products, locale = DEFAULT_LOCALE, emptyMessage = null) {
  if (!products.length) {
    return `<p class="empty-state">${escapeHtml(emptyMessage || t(locale, "searchEmptyTitle"))}</p>`;
  }
  return `<div class="product-grid">${products.map((p) => renderProductCard(p, locale)).join("\n")}</div>`;
}

module.exports = {renderProductCard, renderProductGrid};
