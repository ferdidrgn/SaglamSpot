const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts} = require("../productRepo");
const {CATEGORY_LABELS} = require("../categories");

const CONDITION_OPTIONS = [
  ["all", "Tümü"],
  ["new", "Sıfır"],
  ["used", "İkinci El"],
];

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
  const q = (req.query.q || "").toString();
  const category = (req.query.category || "").toString();
  const condition = (req.query.condition || "all").toString();
  const minPrice = req.query.minPrice ? Number(req.query.minPrice) : null;
  const maxPrice = req.query.maxPrice ? Number(req.query.maxPrice) : null;

  let products = [];
  let firestoreError = null;

  try {
    const all = await listActiveProducts({limit: 500});
    const needle = normalizeText(q);

    products = all.filter((p) => {
      if (needle && !normalizeText(p.name).includes(needle) && !normalizeText(p.desc).includes(needle)) return false;
      if (category && p.category !== category) return false;
      if (condition === "new" && p.isSpotProduct) return false;
      if (condition === "used" && !p.isSpotProduct) return false;
      if (minPrice != null && !Number.isNaN(minPrice) && p.price < minPrice) return false;
      if (maxPrice != null && !Number.isNaN(maxPrice) && p.price > maxPrice) return false;
      return true;
    });
  } catch (err) {
    firestoreError = err.message;
  }

  const categoryOptionsHtml = [["", "Tüm Kategoriler"], ...Object.entries(CATEGORY_LABELS)]
      .map(([value, label]) => `<option value="${escapeHtml(value)}"${value === category ? " selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");

  const conditionOptionsHtml = CONDITION_OPTIONS
      .map(([value, label]) => `<option value="${escapeHtml(value)}"${value === condition ? " selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");

  const resultsHtml = firestoreError
    ? `<p class="status status-error">Arama yapılamadı: ${escapeHtml(firestoreError)}</p>`
    : renderProductGrid(products, "Bu kriterlere uyan ürün bulunamadı.");

  const hasQuery = q || category || condition !== "all" || minPrice != null || maxPrice != null;

  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">Ürün Ara</p>
  <h1>Ne arıyorsunuz?</h1>
</section>
<form class="search-form" method="get" action="/arama">
  <input type="search" name="q" placeholder="Ürün adı..." value="${escapeHtml(q)}" aria-label="Ürün adı ara">
  <select name="category" aria-label="Kategori">${categoryOptionsHtml}</select>
  <select name="condition" aria-label="Durum">${conditionOptionsHtml}</select>
  <input type="number" name="minPrice" placeholder="Min ₺" min="0" value="${minPrice != null ? escapeHtml(String(minPrice)) : ""}" aria-label="Minimum fiyat">
  <input type="number" name="maxPrice" placeholder="Max ₺" min="0" value="${maxPrice != null ? escapeHtml(String(maxPrice)) : ""}" aria-label="Maksimum fiyat">
  <button type="submit">Ara</button>
</form>
<section class="section">
  ${hasQuery ? resultsHtml : "<p class=\"empty-state\">Aramak için yukarıdaki alanları kullanın.</p>"}
</section>`;

  res.set("Cache-Control", "no-cache, no-store, must-revalidate");
  res.status(200).send(renderLayout({title: "Ara", path: "/arama", bodyHtml}));
};
