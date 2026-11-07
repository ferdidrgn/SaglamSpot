const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {renderTicker} = require("../render/trustTicker");
const {ICONS} = require("../render/icons");
const {listActiveProducts} = require("../productRepo");
const {CATEGORY_LABELS, categoryPhoto, localizedCategoryLabel} = require("../categories");
const {NEW_BADGE_GREEN, SPOT_ACCENT} = require("../catalogTheme");
const {t} = require("../i18n");

/**
 * saglamspotcu.web.app'teki (bu projenin KENDİ Flutter web derlemesi)
 * /new ve /spot sayfalarının web-genesis karşılığı: hero + istatistik/
 * rozet satırı + güven şeridi + kategori foto rayı + yan menü/arama/
 * sıralama ile tam bir koleksiyon sayfası — önceden burada sadece başlık
 * + çıplak ızgara vardı. Footer KASTEN dahil değil (brief'in isteği):
 * footer zaten renderLayout()'tan geliyor, burada değiştirilmiyor.
 */
function normalizeText(value) {
  return (value || "").toLocaleLowerCase("tr-TR").trim();
}

function renderListingHero({eyebrow, title, subtitle, accent, heroImage, statsHtml, badgeLabel}) {
  return `
<section class="listing-hero" style="--listing-accent:${accent}">
  <div class="listing-hero-text">
    <span class="listing-hero-eyebrow">${escapeHtml(eyebrow)}</span>
    <h1>${escapeHtml(title)}</h1>
    <p class="lede">${escapeHtml(subtitle)}</p>
    ${statsHtml}
  </div>
  <div class="listing-hero-media">
    <img src="${escapeHtml(heroImage)}" alt="" loading="eager">
    <span class="listing-hero-badge">${ICONS.verified} ${escapeHtml(badgeLabel)}</span>
  </div>
</section>`;
}

// Satıcı/testimonial panel sadece /spot'ta — saglamspotcu.web.app'teki
// "Eskimiş değil, emek görmüş..." alıntısıyla AYNI marka sözü. ARB'de
// bağımsız bir anahtarı yok (brief: yeniden çeviri yok, tek seferlik
// pazarlama alıntısı) — "Rezerve"/"Satılan Ürünler" emsaliyle aynı
// gerekçeyle bilerek Türkçe literal.
function renderSpotQuote(accent) {
  return `
<div class="listing-quote-panel" style="--listing-accent:${accent}">
  <span class="listing-quote-glow" aria-hidden="true"></span>
  <span class="listing-quote-badge">${ICONS.sparkle} İkinci Bahar</span>
  <span class="listing-quote-mark" aria-hidden="true">&ldquo;</span>
  <p class="listing-quote-text">Eskimiş değil, emek görmüş.<br>İyi mobilya asla eskimez, sadece ev değiştirir.</p>
  <p class="listing-quote-sub">Biz de tam bu yüzden buradayız: hâlâ hayatı olan parçaları, onlara değer verecek yeni bir eve ulaştırmak için.</p>
</div>`;
}

function renderPhotoRail(locale, products, basePath) {
  const counts = products.reduce((acc, p) => {
    acc[p.category] = (acc[p.category] || 0) + 1;
    return acc;
  }, {});
  const keys = Object.keys(CATEGORY_LABELS).filter((k) => k !== "other" && counts[k]);
  if (!keys.length) return "";
  return `<div class="listing-photo-rail">${keys.map((key) => `
    <a class="listing-photo-card" href="${basePath}?category=${encodeURIComponent(key)}">
      <img src="${escapeHtml(categoryPhoto(key))}" alt="" loading="lazy">
      <span class="listing-photo-overlay">
        <span class="listing-photo-title">${escapeHtml(localizedCategoryLabel(locale, key))}</span>
        <span class="listing-photo-count">${counts[key]} ürün</span>
      </span>
    </a>`).join("")}</div>`;
}

function renderSidebar(locale, products, basePath, activeCategory) {
  const counts = products.reduce((acc, p) => {
    acc[p.category] = (acc[p.category] || 0) + 1;
    return acc;
  }, {});
  const items = [{key: "", label: t(locale, "conditionAll"), count: products.length},
    ...Object.keys(CATEGORY_LABELS).filter((k) => k !== "other").map((key) => ({
      key, label: localizedCategoryLabel(locale, key), count: counts[key] || 0,
    }))];
  return `<nav class="listing-sidebar" aria-label="${escapeHtml(t(locale, "category"))}">${items.map((it) => `
    <a class="listing-sidebar-link${it.key === activeCategory ? " is-active" : ""}" href="${basePath}${it.key ? `?category=${encodeURIComponent(it.key)}` : ""}">
      <span>${escapeHtml(it.label)}</span><span class="listing-sidebar-count">${it.count}</span>
    </a>`).join("")}</nav>`;
}

function renderToolbar(locale, {basePath, q, sort, category}) {
  const sortOptionsHtml = [["featured", t(locale, "sortFeatured")], ["priceAsc", t(locale, "sortPriceAsc")], ["priceDesc", t(locale, "sortPriceDesc")], ["newest", t(locale, "sortSpotProductsDefault")]]
      .map(([value, label]) => `<option value="${escapeHtml(value)}"${value === sort ? " selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");
  return `
<form class="search-form listing-toolbar" method="get" action="${basePath}">
  <input type="search" name="q" placeholder="${escapeHtml(t(locale, "productNameLabel"))}" value="${escapeHtml(q)}" aria-label="${escapeHtml(t(locale, "productNameLabel"))}">
  ${category ? `<input type="hidden" name="category" value="${escapeHtml(category)}">` : ""}
  <select name="sort" aria-label="Sırala">${sortOptionsHtml}</select>
  <button type="submit">${escapeHtml(t(locale, "apply"))}</button>
</form>`;
}

function makeListingRoute({isSpotProduct, path, theme}) {
  return async function listingRoute(req, res) {
    const locale = req.locale;
    const category = (req.query.category || "").toString();
    const q = (req.query.q || "").toString();
    const sort = (req.query.sort || "featured").toString();

    let allProducts = [];
    let firestoreError = null;
    try {
      allProducts = await listActiveProducts({isSpotProduct});
    } catch (err) {
      firestoreError = err.message;
    }

    const needle = normalizeText(q);
    let products = allProducts.filter((p) => {
      if (category && p.category !== category) return false;
      if (needle && !normalizeText(p.name).includes(needle) && !normalizeText(p.desc).includes(needle)) return false;
      return true;
    });
    if (sort === "priceAsc") products.sort((a, b) => a.price - b.price);
    else if (sort === "priceDesc") products.sort((a, b) => b.price - a.price);
    else if (sort === "newest") products.sort((a, b) => b.createdAtSort - a.createdAtSort);

    const categoryCount = new Set(allProducts.map((p) => p.category)).size;
    const heroImage = (allProducts[0] && allProducts[0].image) || categoryPhoto("sofa");

    const gridHtml = firestoreError
      ? `<p class="status status-error">${escapeHtml(firestoreError)}</p>`
      : renderProductGrid(products, locale, t(locale, "searchEmptyMessage"));

    const bodyHtml = firestoreError ? `
<section class="section"><p class="status status-error">${escapeHtml(firestoreError)}</p></section>` : `
${renderListingHero(theme.hero(locale, allProducts, categoryCount, heroImage))}

<section class="section">
  ${renderTicker(locale)}
</section>

${theme.quoteHtml ? `<section class="section">${theme.quoteHtml(theme.accent)}</section>` : ""}

<section class="section">
  ${renderPhotoRail(locale, allProducts, path)}
</section>

<section class="section listing-layout" data-live-filter data-live-url="${path}">
  ${renderSidebar(locale, allProducts, path, category)}
  <div class="listing-main">
    ${renderToolbar(locale, {basePath: path, q, sort, category})}
    <p class="search-result-count">${escapeHtml(t(locale, "categoryProductCount", {count: products.length}))}</p>
    ${gridHtml}
  </div>
</section>`;

    res.set("Cache-Control", "no-cache, no-store, must-revalidate");
    res.status(200).send(renderLayout({
      req,
      title: t(locale, theme.seoTitleKey).split(" | ")[0],
      description: t(locale, theme.seoDescKey),
      path,
      bodyHtml,
      locale,
    }));
  };
}

const newTheme = {
  seoTitleKey: "seoNewTitle",
  seoDescKey: "seoNewDesc",
  hero: (locale, products, categoryCount, heroImage) => ({
    eyebrow: t(locale, "gatewayNewEyebrow"),
    title: t(locale, "gatewayNewTitle"),
    subtitle: `${t(locale, "gatewayNewSubtitle")} ${t(locale, "seoNewDesc")}`,
    accent: NEW_BADGE_GREEN,
    heroImage,
    badgeLabel: t(locale, "productTrustBadgeVerified"),
    statsHtml: `<div class="listing-hero-stats">
      <span><strong>${products.length}+</strong>${escapeHtml(t(locale, "statProducts"))}</span>
      <span><strong>${categoryCount}</strong>${escapeHtml(t(locale, "sectionCategories"))}</span>
      <span><strong>%100</strong>${escapeHtml(t(locale, "productTrustBadgeVerified"))}</span>
    </div>`,
  }),
};

const spotTheme = {
  seoTitleKey: "seoSpotTitle",
  seoDescKey: "seoSpotDesc",
  accent: SPOT_ACCENT,
  quoteHtml: renderSpotQuote,
  hero: (locale, products, categoryCount, heroImage) => ({
    eyebrow: t(locale, "gatewaySpotEyebrow"),
    title: t(locale, "gatewaySpotTitle"),
    subtitle: `${t(locale, "gatewaySpotSubtitle")} ${t(locale, "spotProductsDesc")}`,
    accent: SPOT_ACCENT,
    heroImage,
    badgeLabel: t(locale, "productTrustBadgeVerified"),
    statsHtml: `<div class="listing-hero-tags">
      <span>${escapeHtml(t(locale, "spotProductsSub"))}</span>
      <span aria-hidden="true">&middot;</span>
      <span>${escapeHtml(t(locale, "productTrustBadgeNegotiate"))}</span>
      <span aria-hidden="true">&middot;</span>
      <span>${escapeHtml(t(locale, "usedProductBadge"))}</span>
    </div>`,
  }),
};

const newProductsRoute = makeListingRoute({isSpotProduct: false, path: "/sifir", theme: newTheme});
const spotProductsRoute = makeListingRoute({isSpotProduct: true, path: "/spot", theme: spotTheme});

module.exports = {newProductsRoute, spotProductsRoute};
