const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts, countSoldProducts} = require("../productRepo");
const {CATEGORY_LABELS, categoryPhoto} = require("../categories");
const {ICONS} = require("../render/icons");
const business = require("../businessInfo");
const {t} = require("../i18n");

// lib/core/theme/catalog_theme.dart'taki NewCollectionPalette/SpotPalette
// ile AYNI hex'ler — iki kapı kartının kendi (marka ana paletinden ayrı,
// bilerek zıt hissettirilen) renk dili. Yeni renk İCAT EDİLMEDİ.
const NEW_ACCENT = "#2C241E";
const NEW_BADGE_GREEN = "#2E7D32";
const SPOT_ACCENT = "#E65100";

// home_page_web.dart'taki _heroImages ile AYNI 3 fotoğraf.
const HERO_IMAGES = [
  "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1600",
  "https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1600",
  "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1600",
];

function renderHero(locale, products) {
  const slidesHtml = HERO_IMAGES.map((url, i) => `
    <div class="hero-slide${i === 0 ? " is-active" : ""}"><img src="${escapeHtml(url)}" alt="" loading="${i === 0 ? "eager" : "lazy"}"></div>`).join("");
  const dotsHtml = HERO_IMAGES.map((_, i) => `<button type="button" class="hero-dot${i === 0 ? " is-active" : ""}" aria-label="${i + 1}"></button>`).join("");

  const featured = products.slice(0, 2);
  const featuredHtml = featured.length ? `<div class="hero-featured-stack">${featured.map((p, i) => `
    <a class="hero-featured-card" href="${escapeHtml(p.path)}">
      <span class="hero-featured-thumb">${p.image ? `<img src="${escapeHtml(p.image)}" alt="" loading="lazy">` : ""}</span>
      <span class="hero-featured-info">
        <p class="hero-featured-num">${i + 1}.</p>
        <p class="hero-featured-name">${escapeHtml(p.name)}</p>
        <p class="hero-featured-meta" dir="ltr">${escapeHtml(p.priceLabel)}</p>
      </span>
    </a>`).join("")}</div>` : "";

  return `
<section class="hero-banner" data-hero-carousel>
  ${slidesHtml}
  <div class="hero-banner-scrim" aria-hidden="true"></div>
  <div class="hero-content">
    <span class="hero-eyebrow-pill">${escapeHtml(t(locale, "newSeason"))}</span>
    <h1>${escapeHtml(t(locale, "heroTitle")).replace(/\n/g, "<br>")}</h1>
    <p>${escapeHtml(t(locale, "featureArtisan"))}</p>
    <div class="hero-pill-row">
      <a class="hero-pill hero-pill-light" href="/sifir">${ICONS.newReleases} ${escapeHtml(t(locale, "conditionNew"))}</a>
      <a class="hero-pill hero-pill-accent" href="/spot">${ICONS.history} ${escapeHtml(t(locale, "conditionUsed"))}</a>
      <a class="hero-pill hero-pill-outline" href="/arama">${ICONS.explore} ${escapeHtml(t(locale, "exploreButton"))}</a>
    </div>
  </div>
  <button type="button" class="hero-arrow hero-arrow-prev" aria-label="${escapeHtml(t(locale, "exploreButton"))}">${ICONS.chevronLeft}</button>
  <button type="button" class="hero-arrow hero-arrow-next" aria-label="${escapeHtml(t(locale, "exploreButton"))}">${ICONS.chevronRight}</button>
  <div class="hero-dots">${dotsHtml}</div>
  ${featuredHtml}
</section>`;
}

function renderCategoryRail(locale) {
  const allChip = `<a class="category-chip" href="/arama">
    <span class="category-chip-avatar is-all">${ICONS.grid}</span>
    <span class="category-chip-label">${escapeHtml(t(locale, "conditionAll"))}</span>
  </a>`;
  const chips = Object.keys(CATEGORY_LABELS).map((key) => {
    const label = t(locale, "category" + key.charAt(0).toUpperCase() + key.slice(1));
    return `<a class="category-chip" href="/arama?category=${encodeURIComponent(key)}">
      <span class="category-chip-avatar"><img src="${escapeHtml(categoryPhoto(key))}" alt="" loading="lazy"></span>
      <span class="category-chip-label">${escapeHtml(label)}</span>
    </a>`;
  }).join("");
  return `<nav class="category-rail" aria-label="${escapeHtml(t(locale, "category"))}">${allChip}${chips}</nav>`;
}

function renderGatewayCards(locale, newProducts, spotProducts) {
  function card({eyebrow, title, subtitle, count, accent, glowVar, icon, button, href}) {
    return `
<a class="gateway-card gateway-card-${glowVar}" href="${href}" style="--glow-color:${accent}">
  <div class="gateway-glow" aria-hidden="true"></div>
  <div class="gateway-icon" aria-hidden="true">${icon}</div>
  <p class="gateway-eyebrow" style="--eyebrow-color:${accent}">${escapeHtml(eyebrow)}</p>
  <h3 class="gateway-title">${escapeHtml(title)}</h3>
  <p class="gateway-sub">${escapeHtml(subtitle)}</p>
  <div class="gateway-row">
    <span class="gateway-count">${escapeHtml(t(locale, "gatewayProductCount", {count}))}</span>
    <span class="gateway-cta">${escapeHtml(button)} ${ICONS.chevronRight}</span>
  </div>
</a>`;
  }

  return `<div class="gateway-grid">
    ${card({
    eyebrow: t(locale, "gatewayNewEyebrow"),
    title: t(locale, "gatewayNewTitle"),
    subtitle: t(locale, "gatewayNewSubtitle"),
    count: newProducts.length,
    accent: NEW_BADGE_GREEN,
    glowVar: "new",
    icon: ICONS.chair,
    button: t(locale, "gatewayNewButton"),
    href: "/sifir",
  })}
    ${card({
    eyebrow: t(locale, "gatewaySpotEyebrow"),
    title: t(locale, "gatewaySpotTitle"),
    subtitle: t(locale, "gatewaySpotSubtitle"),
    count: spotProducts.length,
    accent: SPOT_ACCENT,
    glowVar: "spot",
    icon: ICONS.tag,
    button: t(locale, "gatewaySpotButton"),
    href: "/spot",
  })}
  </div>`;
}

function renderBentoGrid(locale) {
  const items = [
    {icon: ICONS.handshake, label: t(locale, "featureArtisan"), color: "var(--color-accent)", cls: "bento-tile-1"},
    {icon: ICONS.shieldCheck, label: t(locale, "featureDelivery"), color: "var(--color-success)", cls: "bento-tile-2"},
    {icon: ICONS.smile, label: t(locale, "featureService"), color: "var(--color-warning)", cls: "bento-tile-3"},
    {icon: ICONS.truck, label: t(locale, "featureShipping"), color: "var(--color-info)", cls: "bento-tile-4"},
  ];
  return `<div class="bento-grid">${items.map((it) => `
    <div class="bento-tile ${it.cls}" style="--tile-color:${it.color}">
      <span class="bento-tile-icon">${it.icon}</span>
      <span class="bento-tile-label">${escapeHtml(it.label)}</span>
    </div>`).join("")}</div>`;
}

function renderRoomsPanel(locale) {
  const cards = Object.keys(CATEGORY_LABELS).filter((k) => k !== "other").map((key) => {
    const label = t(locale, "category" + key.charAt(0).toUpperCase() + key.slice(1));
    return `
    <a class="room-card" href="/arama?category=${encodeURIComponent(key)}">
      <img src="${escapeHtml(categoryPhoto(key))}" alt="" loading="lazy">
      <div class="room-card-overlay">
        <span class="room-card-eyebrow">${escapeHtml(t(locale, "byRoomSub"))}</span>
        <span class="room-card-title">${escapeHtml(label)}</span>
      </div>
    </a>`;
  }).join("");

  return `
<div class="rooms-panel">
  <div class="rooms-text">
    <h2>${escapeHtml(t(locale, "byRoom"))}</h2>
    <p>${escapeHtml(t(locale, "byRoomSub"))}</p>
    <a class="hero-pill hero-pill-accent" style="align-self:flex-start" href="/arama">${ICONS.explore} ${escapeHtml(t(locale, "exploreButton"))}</a>
  </div>
  <div class="rooms-collage">${cards}</div>
</div>`;
}

function renderStatsBand(locale, productCount, categoryCount, soldCount) {
  const stats = [
    {icon: ICONS.inventory, value: productCount, label: t(locale, "statProducts")},
    {icon: ICONS.grid, value: categoryCount, label: t(locale, "sectionCategories")},
    {icon: ICONS.award, value: `20${t(locale, "statYearsSuffix")}`, label: t(locale, "statExperience")},
    {icon: ICONS.truck, value: soldCount, label: t(locale, "statDelivery")},
  ];
  return `<section class="stats-band"><div class="stats-grid">${stats.map((s) => `
    <div class="stat-card">${s.icon}<strong>${escapeHtml(String(s.value))}</strong><span>${escapeHtml(s.label)}</span></div>`).join("")}</div></section>`;
}

module.exports = async function homeRoute(req, res) {
  const locale = req.locale;
  let products = [];
  let soldCount = 0;
  let firestoreError = null;

  try {
    [products, soldCount] = await Promise.all([
      listActiveProducts({limit: 200}),
      countSoldProducts(),
    ]);
  } catch (err) {
    firestoreError = err.message;
  }

  const newProducts = products.filter((p) => !p.isSpotProduct);
  const spotProducts = products.filter((p) => p.isSpotProduct);
  const categoryCount = new Set(products.map((p) => p.category)).size;
  const gridProducts = products.slice(0, 8);

  const gridHtml = firestoreError
    ? `<p class="status status-error">${escapeHtml(firestoreError)}</p>`
    : renderProductGrid(gridProducts, locale);

  const bodyHtml = firestoreError ? `
<section class="section"><p class="status status-error">${escapeHtml(firestoreError)}</p></section>` : `
${renderHero(locale, products)}

<section class="section">
  ${renderCategoryRail(locale)}
</section>

<section class="section">
  ${renderGatewayCards(locale, newProducts, spotProducts)}
</section>

<section class="section">
  ${renderBentoGrid(locale)}
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "newCollectionSub"))}</h2>
  ${gridHtml}
</section>

<section class="section">
  ${renderRoomsPanel(locale)}
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "aboutValuesHeading"))}</h2>
  <p class="lede">${escapeHtml(t(locale, "aboutValuesSubheading"))}</p>
  <div class="value-grid">${[1, 2, 3, 4].map((i) => `
    <div class="value-card">
      <h3>${escapeHtml(t(locale, `aboutValue${i}Title`))}</h3>
      <p>${escapeHtml(t(locale, `aboutValue${i}Desc`))}</p>
    </div>`).join("")}</div>
</section>

${renderStatsBand(locale, products.length, categoryCount, soldCount)}`;

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
