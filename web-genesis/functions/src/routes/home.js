const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts} = require("../productRepo");
const business = require("../businessInfo");
const {t} = require("../i18n");

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
<section class="hero">
  <p class="eyebrow">${escapeHtml(t(locale, "newSeason"))}</p>
  <h1>${escapeHtml(t(locale, "heroTitle")).replace(/\n/g, "<br>")}</h1>
  <p class="lede">${escapeHtml(t(locale, "easyFind"))}</p>
  <p><a class="whatsapp-link" href="${business.whatsappUrl()}" rel="noopener">${escapeHtml(t(locale, "whatsappCta"))}: <bdi>${escapeHtml(business.displayPhone)}</bdi></a></p>
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "newCollectionSub"))}</h2>
  ${gridHtml}
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
