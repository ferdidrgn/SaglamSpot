const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts, listSoldProducts} = require("../productRepo");
const {CATEGORY_LABELS} = require("../categories");
const {t} = require("../i18n");

function normalizeText(value) {
  return (value || "").toLocaleLowerCase("tr-TR").trim();
}

/**
 * GET-tabanlı, kaydedilebilir/paylaşılabilir bir arama URL'i — form JS
 * olmadan da tam çalışır (progressive enhancement). Firestore'da serbest
 * metin arama desteklenmediği için önce isSold==false ürünler çekilir,
 * filtreleme bellekte yapılır (envanter boyutu için yeterince hızlı).
 */
module.exports = async function searchRoute(req, res) {
  const locale = req.locale;
  const q = (req.query.q || "").toString();
  const category = (req.query.category || "").toString();
  const condition = (req.query.condition || "all").toString();
  const minPrice = req.query.minPrice ? Number(req.query.minPrice) : null;
  const maxPrice = req.query.maxPrice ? Number(req.query.maxPrice) : null;

  let products = [];
  let firestoreError = null;

  // "Satıldı" filtresi: normal vitrinden tamamen ayrı bir havuz (isSold
  // true) - "eskiden ne satmışız" arşivi. ARB'de karşılığı yok (brief:
  // yeniden çeviri yok), bilerek Türkçe literal (bkz. "Rezerve" emsali).
  const isSoldFilter = condition === "sold";

  try {
    const all = isSoldFilter
      ? await listSoldProducts({limit: 500})
      : await listActiveProducts({limit: 500});
    const needle = normalizeText(q);

    products = all.filter((p) => {
      if (needle && !normalizeText(p.name).includes(needle) && !normalizeText(p.desc).includes(needle)) return false;
      if (category && p.category !== category) return false;
      if (!isSoldFilter && condition === "new" && p.isSpotProduct) return false;
      if (!isSoldFilter && condition === "used" && !p.isSpotProduct) return false;
      if (minPrice != null && !Number.isNaN(minPrice) && p.price < minPrice) return false;
      if (maxPrice != null && !Number.isNaN(maxPrice) && p.price > maxPrice) return false;
      return true;
    });
  } catch (err) {
    firestoreError = err.message;
  }

  const categoryOptionsHtml = [["", t(locale, "conditionAll")], ...Object.keys(CATEGORY_LABELS).map((key) => [key, t(locale, "category" + key.charAt(0).toUpperCase() + key.slice(1))])]
      .map(([value, label]) => `<option value="${escapeHtml(value)}"${value === category ? " selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");

  const conditionOptionsHtml = [["all", t(locale, "conditionAll")], ["new", t(locale, "conditionNew")], ["used", t(locale, "conditionUsed")], ["sold", "Satıldı"]]
      .map(([value, label]) => `<option value="${escapeHtml(value)}"${value === condition ? " selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");

  const emptyMessage = isSoldFilter ? "Henüz satılmış ürün yok." : t(locale, "searchEmptyMessage");
  const resultsHtml = firestoreError
    ? `<p class="status status-error">${escapeHtml(firestoreError)}</p>`
    : renderProductGrid(products, locale, products.length ? null : emptyMessage);

  // Önceden filtre uygulanmadan sayfaya ilk girişte "Henüz sonuç yok"
  // yazan boş bir ipucu ekranı vardı — kullanıcı geri bildirimi: "hiçbir
  // ürün yok diyor oysa var". Artık varsayılan olarak TÜM aktif ürünler
  // (hiç filtre yokken) hemen gösteriliyor, tıpkı gerçek bir katalog gibi.
  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">${escapeHtml(t(locale, "category"))}</p>
  <h1>${escapeHtml(t(locale, "searchHint"))}</h1>
</section>
<form class="search-form" method="get" action="/arama">
  <input type="search" name="q" placeholder="${escapeHtml(t(locale, "productNameLabel"))}" value="${escapeHtml(q)}" aria-label="${escapeHtml(t(locale, "productNameLabel"))}">
  <select name="category" aria-label="${escapeHtml(t(locale, "category"))}">${categoryOptionsHtml}</select>
  <select name="condition" aria-label="${escapeHtml(t(locale, "condition"))}">${conditionOptionsHtml}</select>
  <input type="number" name="minPrice" placeholder="Min ₺" min="0" value="${minPrice != null ? escapeHtml(String(minPrice)) : ""}" aria-label="${escapeHtml(t(locale, "priceRange"))}">
  <input type="number" name="maxPrice" placeholder="Max ₺" min="0" value="${maxPrice != null ? escapeHtml(String(maxPrice)) : ""}" aria-label="${escapeHtml(t(locale, "priceRange"))}">
  <button type="submit">${escapeHtml(t(locale, "apply"))}</button>
</form>
<section class="section">
  ${resultsHtml}
</section>`;

  res.set("Cache-Control", "no-cache, no-store, must-revalidate");
  res.status(200).send(renderLayout({
    req,
    title: t(locale, "searchHint"),
    path: "/arama",
    bodyHtml,
    locale,
  }));
};
