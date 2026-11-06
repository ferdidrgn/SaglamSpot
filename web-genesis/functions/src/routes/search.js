const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid, renderProductList} = require("../render/productCard");
const {listActiveProducts, listSoldProducts} = require("../productRepo");
const {CATEGORY_LABELS, localizedCategoryLabel} = require("../categories");
const {t} = require("../i18n");

function normalizeText(value) {
  return (value || "").toLocaleLowerCase("tr-TR").trim();
}

// Mevcut filtre durumunu KORUYARAK kategoriyi değiştiren link — kategori
// sekmesine tıklamak arama metnini/sıralamayı/fiyat aralığını sıfırlamaz.
function buildCategoryHref({q, condition, minPrice, maxPrice, sort}, category) {
  const params = new URLSearchParams();
  if (q) params.set("q", q);
  if (condition && condition !== "all") params.set("condition", condition);
  if (category) params.set("category", category);
  if (minPrice != null) params.set("minPrice", String(minPrice));
  if (maxPrice != null) params.set("maxPrice", String(maxPrice));
  if (sort && sort !== "featured") params.set("sort", sort);
  const qs = params.toString();
  return `/arama${qs ? `?${qs}` : ""}`;
}

// Kategori sekmeleri — saglamspotcu.web.app'teki /arama'daki GERÇEK
// tasarım: açılan bir kombobox değil, tek tıklamalı, aktifi alt çizgili
// yatay sekme şeridi (kullanıcı geri bildirimi: "kombobox açılmasın").
function renderCategoryTabs(state, categoryCounts, totalCount) {
  const tabs = [
    ["", `${t(state.locale, "conditionAll")} (${totalCount})`],
    ...Object.keys(CATEGORY_LABELS).map((key) => [key, `${localizedCategoryLabel(state.locale, key)} (${categoryCounts[key] || 0})`]),
  ];
  return `<nav class="category-tabs" aria-label="${escapeHtml(t(state.locale, "category"))}">${tabs.map(([key, label]) => `
    <a class="category-tab${key === state.category ? " is-active" : ""}" href="${buildCategoryHref(state, key)}">${escapeHtml(label)}</a>`).join("")}</nav>`;
}

// Hızlı filtre çipleri (durum/fiyat) — ARB'de bağımsız kaynakları yok
// (brief: yeniden çeviri yok), bilerek Türkçe literal (bkz. "Rezerve").
function renderQuickChips(condition, maxPrice) {
  const chips = [
    {label: "Sıfır", href: "/arama?condition=new", active: condition === "new"},
    {label: "İkinci El", href: "/arama?condition=used", active: condition === "used"},
    {label: "500₺ altı", href: "/arama?maxPrice=500", active: maxPrice === 500},
    {label: "1000₺ altı", href: "/arama?maxPrice=1000", active: maxPrice === 1000},
  ];
  return `<div class="search-quick-chips">${chips.map((c) => `
    <a class="search-quick-chip${c.active ? " is-active" : ""}" href="${c.href}">${c.label}</a>`).join("")}</div>`;
}

const SEARCH_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><circle cx=\"11\" cy=\"11\" r=\"7\"/><path d=\"M21 21l-4.3-4.3\"/></svg>";
const SORT_ICON = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><path d=\"M7 4v16M7 20l-3-3M7 20l3-3M17 20V4M17 4l-3 3M17 4l3 3\"/></svg>";
const GRID_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" aria-hidden=\"true\"><rect x=\"3\" y=\"3\" width=\"8\" height=\"8\" rx=\"1.5\"/><rect x=\"13\" y=\"3\" width=\"8\" height=\"8\" rx=\"1.5\"/><rect x=\"3\" y=\"13\" width=\"8\" height=\"8\" rx=\"1.5\"/><rect x=\"13\" y=\"13\" width=\"8\" height=\"8\" rx=\"1.5\"/></svg>";
const LIST_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" aria-hidden=\"true\"><path d=\"M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01\"/></svg>";
const BACK_ICON = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\" aria-hidden=\"true\"><path d=\"M15 5l-7 7 7 7\"/></svg>";

/**
 * GET-tabanlı, kaydedilebilir/paylaşılabilir bir arama URL'i — form JS
 * olmadan da tam çalışır (progressive enhancement). Firestore'da serbest
 * metin arama desteklenmediği için önce isSold==false ürünler çekilir,
 * filtreleme bellekte yapılır (envanter boyutu için yeterince hızlı).
 *
 * "Satıldı" ÖNCEDEN ayrı bir mod'du (condition=sold seçilince TÜM liste
 * satılanlarla değişiyordu) — kullanıcı geri bildirimi: mobil uygulamadaki
 * gibi satıştaki ürünler hep üstte, satılanlar hep altta AYRI bir bölümde
 * olmalı, aynı filtreler (kategori/fiyat/arama/sıralama) İKİSİNE de aynı
 * anda uygulanmalı. Bu yüzden artık HER ZAMAN iki havuz (aktif +
 * satılmış) PARALEL çekiliyor, aynı filtre/sıralama her ikisine ayrı
 * ayrı uygulanıyor, ikisi de kendi bölümünde render ediliyor.
 *
 * Üst araç çubuğu + kategori sekmeleri + ızgara/liste geçişi
 * saglamspotcu.web.app'teki (bu projenin KENDİ Flutter web derlemesi)
 * GERÇEK /arama tasarımıyla AYNI — önceden burada sadece çıplak bir
 * <select> kombobox'ı vardı (kullanıcı: "kombobox açılmasın, tek
 * tıklamalı olsun").
 */
module.exports = async function searchRoute(req, res) {
  const locale = req.locale;
  const q = (req.query.q || "").toString();
  const category = (req.query.category || "").toString();
  const condition = (req.query.condition || "all").toString();
  const minPrice = req.query.minPrice ? Number(req.query.minPrice) : null;
  const maxPrice = req.query.maxPrice ? Number(req.query.maxPrice) : null;
  const sort = (req.query.sort || "featured").toString();
  const state = {locale, q, condition, category, minPrice, maxPrice, sort};

  let products = [];
  let soldProducts = [];
  let firestoreError = null;
  let categoryCounts = {};

  function applyFilters(list) {
    const needle = normalizeText(q);
    const matchesExceptCategory = (p) => {
      if (needle && !normalizeText(p.name).includes(needle) && !normalizeText(p.desc).includes(needle)) return false;
      if (condition === "new" && p.isSpotProduct) return false;
      if (condition === "used" && !p.isSpotProduct) return false;
      if (minPrice != null && !Number.isNaN(minPrice) && p.price < minPrice) return false;
      if (maxPrice != null && !Number.isNaN(maxPrice) && p.price > maxPrice) return false;
      return true;
    };
    const preCategory = list.filter(matchesExceptCategory);
    const filtered = preCategory.filter((p) => !category || p.category === category);
    if (sort === "priceAsc") filtered.sort((a, b) => a.price - b.price);
    else if (sort === "priceDesc") filtered.sort((a, b) => b.price - a.price);
    else if (sort === "newest") filtered.sort((a, b) => b.createdAtSort - a.createdAtSort);
    return {filtered, preCategory};
  }

  try {
    const [allActive, allSold] = await Promise.all([
      listActiveProducts({limit: 500}),
      listSoldProducts({limit: 500}),
    ]);

    const activeResult = applyFilters(allActive);
    products = activeResult.filtered;

    // Kategori sekmelerindeki "(N)" sayıları sadece AKTİF (satıştaki)
    // ürünlere göre — satılanlar ayrı/ikincil bir bölüm olduğu için
    // sayaca dahil edilmiyor.
    categoryCounts = activeResult.preCategory.reduce((acc, p) => {
      acc[p.category] = (acc[p.category] || 0) + 1;
      return acc;
    }, {});

    soldProducts = applyFilters(allSold).filtered;
  } catch (err) {
    firestoreError = err.message;
  }

  const totalCount = Object.values(categoryCounts).reduce((a, b) => a + b, 0);

  const resultsHtml = firestoreError
    ? `<p class="status status-error">${escapeHtml(firestoreError)}</p>`
    : `${renderProductGrid(products, locale, products.length ? null : t(locale, "searchEmptyMessage"))}
       ${renderProductList(products, locale)}`;

  // Satılan ürünler bölümü — sadece eşleşme varsa gösterilir (boşken
  // "satılan yok" diye ayrı bir bölüm açmanın anlamı yok, sayfa gereksiz
  // uzamasın). "Satılmış Ürünler" ARB'de yok, bilerek Türkçe literal.
  const soldSectionHtml = !firestoreError && soldProducts.length ? `
<section class="section search-sold-section" data-product-section>
  <div class="search-section-title">
    <h2>Satılmış Ürünler</h2>
    <p>${escapeHtml(t(locale, "categoryProductCount", {count: soldProducts.length}))} — artık mevcut değil, geçmiş vitrin olarak gösteriliyor.</p>
  </div>
  ${renderProductGrid(soldProducts, locale)}
  ${renderProductList(soldProducts, locale)}
</section>` : "";

  // Önceden filtre uygulanmadan sayfaya ilk girişte "Henüz sonuç yok"
  // yazan boş bir ipucu ekranı vardı — kullanıcı geri bildirimi: "hiçbir
  // ürün yok diyor oysa var". Artık varsayılan olarak TÜM aktif ürünler
  // (hiç filtre yokken) hemen gösteriliyor, tıpkı gerçek bir katalog gibi.
  const bodyHtml = `
<div class="search-toolbar">
  <a class="search-back-btn" href="/" aria-label="${escapeHtml(t(locale, "home"))}">${BACK_ICON}</a>
  <form class="search-pill" method="get" action="/arama" role="search">
    ${SEARCH_ICON}
    <input type="search" name="q" placeholder="${escapeHtml(t(locale, "productNameLabel"))}" value="${escapeHtml(q)}" aria-label="${escapeHtml(t(locale, "productNameLabel"))}">
    ${category ? `<input type="hidden" name="category" value="${escapeHtml(category)}">` : ""}
    ${condition !== "all" ? `<input type="hidden" name="condition" value="${escapeHtml(condition)}">` : ""}
  </form>
  <label class="search-sort-pill">
    ${SORT_ICON}
    <select name="sort" aria-label="Sırala" onchange="location.href=this.value">
      ${[["featured", t(locale, "sortFeatured")], ["priceAsc", t(locale, "sortPriceAsc")], ["priceDesc", t(locale, "sortPriceDesc")], ["newest", t(locale, "sortSpotProductsDefault")]].map(([value, label]) => `<option value="${escapeHtml(buildCategoryHref({...state, sort: value === "featured" ? null : value}, category))}"${value === sort ? " selected" : ""}>${escapeHtml(label)}</option>`).join("")}
    </select>
  </label>
  <div class="view-toggle" data-view-toggle role="group" aria-label="Görünüm">
    <button type="button" class="view-toggle-btn is-active" data-view-btn="grid" aria-label="Izgara görünümü">${GRID_ICON}</button>
    <button type="button" class="view-toggle-btn" data-view-btn="list" aria-label="Liste görünümü">${LIST_ICON}</button>
  </div>
</div>
${renderCategoryTabs(state, categoryCounts, totalCount)}
${renderQuickChips(condition, maxPrice)}
<section class="section" data-product-section>
  <div class="search-section-title">
    <h2>Mevcut Koleksiyon</h2>
    <p>${escapeHtml(t(locale, "categoryProductCount", {count: products.length}))}</p>
  </div>
  ${resultsHtml}
</section>
${soldSectionHtml}`;

  res.set("Cache-Control", "no-cache, no-store, must-revalidate");
  res.status(200).send(renderLayout({
    req,
    title: t(locale, "searchHint"),
    path: "/arama",
    bodyHtml,
    locale,
  }));
};
