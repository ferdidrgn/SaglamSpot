const {escapeHtml} = require("./layout");
const {t, DEFAULT_LOCALE} = require("../i18n");
const {localizedCategoryLabel, categoryColor} = require("../categories");
const {productShareUrl} = require("../linkSigning");

/**
 * "Vitrin Kartı" — saglamspotcu.web.app'teki (bu projenin KENDİ Flutter
 * web derlemesi) GERÇEK kart tasarımının HTML/CSS karşılığı: fotoğraf
 * üstte (köşeleri kartla AYNI, tekdüze radius), altında düz akışta bir
 * bilgi paneli (isim + kategori + fiyat rozeti), sol üstte sivri uçlu
 * ŞERİT etiket (SIFIR/İKİNCİ EL), sağ üstte favorile+paylaş için İKİ
 * AYRI, tam opak beyaz daire buton.
 *
 * Önceki sürüm fotoğrafın TAMAMINI kaplayan bir kart + üstte karartma
 * (scrim) ile bindirilmiş metin + asimetrik ("D" biçimli) köşeler
 * kullanıyordu — kullanıcı geri bildirimi: "D şeklinde yapma, gerçek
 * karttaki gibi olsun" + favorile/paylaş butonları %22 opak beyaz
 * zeminde görünmüyordu. Flutter'daki kartta ayrıca bir "sepete ekle"
 * ikonu YOK — web-genesis'in kendi hızlı-sepet ikonu da bu yüzden
 * kaldırıldı (ürün detayında kendi "Sepete Ekle" butonu zaten duruyor).
 */
const FAV_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12 21s-7.5-4.6-10-9A5.5 5.5 0 0 1 12 6a5.5 5.5 0 0 1 10 6c-2.5 4.4-10 9-10 9z\"/></svg>";
const SHARE_ICON = "<svg width=\"15\" height=\"15\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><circle cx=\"18\" cy=\"5\" r=\"2.5\"/><circle cx=\"6\" cy=\"12\" r=\"2.5\"/><circle cx=\"18\" cy=\"19\" r=\"2.5\"/><path d=\"M8.2 10.8l7.6-4.6M8.2 13.2l7.6 4.6\"/></svg>";
const CATEGORY_ICON = "<svg width=\"13\" height=\"13\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M20 12.5L12.5 20 3 10.5V3h7.5L20 12.5z\"/><circle cx=\"7.5\" cy=\"7.5\" r=\"1.5\" fill=\"var(--color-surface)\"/></svg>";
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

  const favBtnHtml = `
  <button type="button" class="pcard-icon-btn pcard-fav-btn" data-favorite-toggle
    aria-label="Favorilere ekle"
    data-id="${escapeHtml(product.id)}"
    data-name="${escapeHtml(product.name)}"
    data-price="${product.price}"
    data-image="${escapeHtml(product.image || "")}"
    data-path="${escapeHtml(product.path)}">${FAV_ICON}</button>`;

  const shareBtnHtml = `
  <button type="button" class="pcard-icon-btn pcard-share-btn" data-share-product
    data-share-url="${escapeHtml(productShareUrl(product.id, product.name))}"
    data-share-title="${escapeHtml(product.name)}"
    aria-label="Paylaş">${SHARE_ICON}</button>`;

  return `
<div class="pcard${product.isSold ? " pcard-sold" : ""}" style="--cat-glow:${catColor}"${imagesJsonAttr}>
  <a class="pcard-link" href="${escapeHtml(product.path)}">
    <div class="pcard-media">
      ${imageHtml}
      ${carouselHtml}
      <span class="pcard-tag ${tagClass}">${escapeHtml(tagLabel)}</span>
      ${reservedBadge}
    </div>
    <div class="pcard-body">
      <p class="pcard-name">${escapeHtml(product.name)}</p>
      <p class="pcard-cat" style="--cat-color:${catColor}">${CATEGORY_ICON}${categoryLabelHtml}</p>
      <span class="pcard-price">${previousPriceHtml}<span dir="ltr">${escapeHtml(product.priceLabel)}</span></span>
    </div>
  </a>
  <div class="pcard-actions">${favBtnHtml}${shareBtnHtml}</div>
</div>`;
}

// Liste görünümü — saglamspotcu.web.app'teki /arama sayfasının "ızgara/
// liste" anahtarıyla AYNI: küçük kare küçük resim + kategori + isim +
// fiyat + durum rozeti, sağda yön oku. Aynı veriden, grid kartının daha
// sıkışık bir alternatifi (kullanıcı tercihine göre main.js'te geçiş
// yapılır, bkz. wireViewToggle()).
function renderProductListRow(product, locale = DEFAULT_LOCALE) {
  const isSpot = product.isSpotProduct;
  const tagLabel = product.isSold ? "SATILDI" : (isSpot ? t(locale, "usedProductBadge") : t(locale, "productCardNewBadge"));
  const tagClass = product.isSold ? "plist-badge-sold" : (isSpot ? "plist-badge-used" : "plist-badge-new");
  const catColor = categoryColor(product.category);
  const images = (product.images && product.images.length ? product.images : [product.image]).filter(Boolean);
  const thumbHtml = images.length
    ? `<img src="${escapeHtml(images[0])}" alt="${escapeHtml(product.name)}" loading="lazy">`
    : "<div class=\"pcard-placeholder\" aria-hidden=\"true\"></div>";

  return `
<a class="plist-row${product.isSold ? " plist-row-sold" : ""}" href="${escapeHtml(product.path)}">
  <span class="plist-thumb">${thumbHtml}</span>
  <span class="plist-info">
    <span class="plist-cat" style="--cat-color:${catColor}">${CATEGORY_ICON}${escapeHtml(localizedCategoryLabel(locale, product.category))}</span>
    <span class="plist-name">${escapeHtml(product.name)}</span>
    <span class="plist-meta">
      <span class="plist-price" dir="ltr">${escapeHtml(product.priceLabel)}</span>
      <span class="plist-badge ${tagClass}">${escapeHtml(tagLabel)}</span>
    </span>
  </span>
  <span class="plist-chevron" aria-hidden="true">${CHEVRON_RIGHT}</span>
</a>`;
}

function renderProductGrid(products, locale = DEFAULT_LOCALE, emptyMessage = null) {
  if (!products.length) {
    return `<p class="empty-state">${escapeHtml(emptyMessage || t(locale, "searchEmptyTitle"))}</p>`;
  }
  return `<div class="product-grid">${products.map((p) => renderProductCard(p, locale)).join("\n")}</div>`;
}

// Yalnızca /arama'nın grid/liste geçiş özelliği için — diğer tüm
// bölümler (ana sayfa, /sifir, /spot, benzer ürünler) hâlâ sadece
// renderProductGrid() kullanıyor, her yerde çift render ETMİYOR.
function renderProductList(products, locale = DEFAULT_LOCALE, emptyMessage = null) {
  if (!products.length) {
    return `<p class="empty-state">${escapeHtml(emptyMessage || t(locale, "searchEmptyTitle"))}</p>`;
  }
  return `<div class="product-list">${products.map((p) => renderProductListRow(p, locale)).join("\n")}</div>`;
}

module.exports = {renderProductCard, renderProductListRow, renderProductGrid, renderProductList};
