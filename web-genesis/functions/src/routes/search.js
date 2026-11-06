const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts, listSoldProducts} = require("../productRepo");
const {CATEGORY_LABELS} = require("../categories");
const {t} = require("../i18n");

function normalizeText(value) {
  return (value || "").toLocaleLowerCase("tr-TR").trim();
}

// Hızlı filtre çipleri — her biri formu tek tıkla, en sık istenen bir
// kombinasyona ayarlayıp otomatik gönderir. ARB'de bağımsız kaynakları
// yok (brief: yeniden çeviri yok), bilerek Türkçe literal (bkz. "Rezerve"
// emsali) — sadece hızlı kısayollar, ana filtre formunun yerini tutmaz.
function renderQuickChips(condition, maxPrice) {
  const chips = [
    {label: "Sıfır", href: "/arama?condition=new", active: condition === "new"},
    {label: "İkinci El", href: "/arama?condition=used", active: condition === "used"},
    {label: "500₺ altı", href: "/arama?maxPrice=500", active: maxPrice === 500},
    {label: "1000₺ altı", href: "/arama?maxPrice=1000", active: maxPrice === 1000},
    {label: "Satıldı Arşivi", href: "/arama?condition=sold", active: condition === "sold"},
  ];
  return `<div class="search-quick-chips">${chips.map((c) => `
    <a class="search-quick-chip${c.active ? " is-active" : ""}" href="${c.href}">${c.label}</a>`).join("")}</div>`;
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
  // lib/features/search/presentation/providers/search_providers.dart'taki
  // SortOption ile aynı 4 seçenek (web'de hiç yoktu).
  const sort = (req.query.sort || "featured").toString();

  let products = [];
  let firestoreError = null;

  // "Satıldı" filtresi: normal vitrinden tamamen ayrı bir havuz (isSold
  // true) - "eskiden ne satmışız" arşivi. ARB'de karşılığı yok (brief:
  // yeniden çeviri yok), bilerek Türkçe literal (bkz. "Rezerve" emsali).
  const isSoldFilter = condition === "sold";

  let categoryCounts = {};
  try {
    const all = isSoldFilter
      ? await listSoldProducts({limit: 500})
      : await listActiveProducts({limit: 500});
    const needle = normalizeText(q);

    // Kategori HARİÇ diğer tüm filtreler — dropdown'daki "(N)" sayıları
    // "şu an seçili diğer filtrelerle bu kategoriyi seçersem kaç ürün
    // çıkar" anlamına gelsin diye (kategorinin kendisi hariç tutulur).
    const matchesExceptCategory = (p) => {
      if (needle && !normalizeText(p.name).includes(needle) && !normalizeText(p.desc).includes(needle)) return false;
      if (!isSoldFilter && condition === "new" && p.isSpotProduct) return false;
      if (!isSoldFilter && condition === "used" && !p.isSpotProduct) return false;
      if (minPrice != null && !Number.isNaN(minPrice) && p.price < minPrice) return false;
      if (maxPrice != null && !Number.isNaN(maxPrice) && p.price > maxPrice) return false;
      return true;
    };

    const preCategory = all.filter(matchesExceptCategory);
    categoryCounts = preCategory.reduce((acc, p) => {
      acc[p.category] = (acc[p.category] || 0) + 1;
      return acc;
    }, {});

    products = preCategory.filter((p) => !category || p.category === category);

    if (sort === "priceAsc") products.sort((a, b) => a.price - b.price);
    else if (sort === "priceDesc") products.sort((a, b) => b.price - a.price);
    else if (sort === "newest") products.sort((a, b) => b.createdAtSort - a.createdAtSort);
    // "featured": listActiveProducts/listSoldProducts zaten en yeni->eski
    // sırayla geliyor, ek bir sıralama gerekmiyor.
  } catch (err) {
    firestoreError = err.message;
  }

  const totalCount = Object.values(categoryCounts).reduce((a, b) => a + b, 0);
  const categoryOptionsHtml = [["", `${t(locale, "conditionAll")} (${totalCount})`], ...Object.keys(CATEGORY_LABELS).map((key) => [key, `${t(locale, "category" + key.charAt(0).toUpperCase() + key.slice(1))} (${categoryCounts[key] || 0})`])]
      .map(([value, label]) => `<option value="${escapeHtml(value)}"${value === category ? " selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");

  const conditionOptionsHtml = [["all", t(locale, "conditionAll")], ["new", t(locale, "conditionNew")], ["used", t(locale, "conditionUsed")], ["sold", "Satıldı"]]
      .map(([value, label]) => `<option value="${escapeHtml(value)}"${value === condition ? " selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");

  const sortOptionsHtml = [["featured", t(locale, "sortFeatured")], ["priceAsc", t(locale, "sortPriceAsc")], ["priceDesc", t(locale, "sortPriceDesc")], ["newest", t(locale, "sortSpotProductsDefault")]]
      .map(([value, label]) => `<option value="${escapeHtml(value)}"${value === sort ? " selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");

  const emptyMessage = isSoldFilter ? "Henüz satılmış ürün yok." : t(locale, "searchEmptyMessage");
  const countLabel = !firestoreError && products.length
    ? `<p class="search-result-count">${escapeHtml(t(locale, "categoryProductCount", {count: products.length}))}</p>`
    : "";
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
  <select name="sort" aria-label="Sırala">${sortOptionsHtml}</select>
  <button type="submit">${escapeHtml(t(locale, "apply"))}</button>
</form>
${renderQuickChips(condition, maxPrice)}
<section class="section">
  ${countLabel}
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
