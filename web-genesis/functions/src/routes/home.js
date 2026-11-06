const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts} = require("../productRepo");
const {CATEGORY_LABELS, categoryColor} = require("../categories");
const business = require("../businessInfo");
const {t} = require("../i18n");

// Kuruluş yılı about.js/aboutStoryPara2 ile aynı ("Her şey 2012'de...
// başladı") — tek kaynağı tekrar yazmamak için burada sabit, deneyim yılı
// bugünün yılından türetilir (uydurma bir sayı DEĞİL).
const FOUNDING_YEAR = 2012;

function renderStatStrip(locale) {
  const years = new Date().getFullYear() - FOUNDING_YEAR;
  const stats = [
    [String(FOUNDING_YEAR), t(locale, "aboutStoryStartLabel")],
    [`${years}+`, t(locale, "aboutStoryExperienceLabel")],
    // "binlerce komşu" (aboutStoryPara3) rakamsal karşılığı — uydurma değil.
    ["1000+", t(locale, "aboutStorySmilesLabel")],
  ];
  return `<div class="hero-stats">${stats.map(([value, label]) => `
    <div class="hero-stat"><strong>${escapeHtml(value)}</strong><span>${escapeHtml(label)}</span></div>`).join("")}</div>`;
}

function renderCategoryRail(locale) {
  const chips = Object.keys(CATEGORY_LABELS).filter((key) => key !== "other").map((key) => {
    const label = t(locale, "category" + key.charAt(0).toUpperCase() + key.slice(1));
    return `<a class="category-chip" style="--chip-color:${categoryColor(key)}" href="/arama?category=${encodeURIComponent(key)}">${escapeHtml(label)}</a>`;
  }).join("");
  return `<nav class="category-rail" aria-label="${escapeHtml(t(locale, "category"))}">${chips}</nav>`;
}

function renderValueTeaser(locale) {
  const values = [1, 2, 3, 4].map((i) => ({
    title: t(locale, `aboutValue${i}Title`),
    desc: t(locale, `aboutValue${i}Desc`),
  }));
  return `<div class="value-grid">${values.map((v) => `
    <div class="value-card">
      <h3>${escapeHtml(v.title)}</h3>
      <p>${escapeHtml(v.desc)}</p>
    </div>`).join("")}</div>`;
}

module.exports = async function homeRoute(req, res) {
  const locale = req.locale;
  let products = [];
  let firestoreError = null;

  try {
    products = (await listActiveProducts({limit: 200})).slice(0, 12);
  } catch (err) {
    firestoreError = err.message;
  }

  const gridHtml = firestoreError
    ? `<p class="status status-error">${escapeHtml(firestoreError)}</p>`
    : renderProductGrid(products, locale);

  const bodyHtml = `
<section class="hero hero-home">
  <div class="hero-main">
    <p class="eyebrow">${escapeHtml(t(locale, "newSeason"))}</p>
    <h1>${escapeHtml(t(locale, "heroTitle")).replace(/\n/g, "<br>")}</h1>
    <p class="lede">${escapeHtml(t(locale, "easyFind"))}</p>
    <div class="hero-actions">
      <a class="whatsapp-link" href="${business.whatsappUrl()}" rel="noopener">${escapeHtml(t(locale, "whatsappCta"))}: <bdi>${escapeHtml(business.displayPhone)}</bdi></a>
      <a class="cart-add-btn hero-secondary-btn" href="${escapeHtml(business.googleMapsUrl)}" target="_blank" rel="noopener">${escapeHtml(t(locale, "aboutViewMapButton"))}</a>
    </div>
  </div>
  ${renderStatStrip(locale)}
</section>

<section class="section">
  ${renderCategoryRail(locale)}
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "newCollectionSub"))}</h2>
  ${gridHtml}
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "aboutValuesHeading"))}</h2>
  <p class="lede">${escapeHtml(t(locale, "aboutValuesSubheading"))}</p>
  ${renderValueTeaser(locale)}
</section>`;

  res.set("Cache-Control", "public, max-age=60");
  res.status(200).send(renderLayout({
    req,
    title: null,
    description: t(locale, "seoHomeDesc"),
    path: "/",
    bodyHtml,
    locale,
    jsonLd: {
      "@context": "https://schema.org",
      "@type": "FurnitureStore",
      "name": business.brandName,
      "telephone": `+${business.phoneNumberIntl}`,
      "email": business.email,
      "address": {
        "@type": "PostalAddress",
        "streetAddress": business.address.line,
        "addressLocality": business.address.district,
        "addressRegion": business.address.city,
        "addressCountry": business.address.country,
      },
      "geo": {
        "@type": "GeoCoordinates",
        "latitude": business.geo.latitude,
        "longitude": business.geo.longitude,
      },
      "openingHoursSpecification": business.openingHoursSpecification.map((spec) => ({
        "@type": "OpeningHoursSpecification",
        ...spec,
      })),
    },
  }));
};
