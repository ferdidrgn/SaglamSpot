const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts} = require("../productRepo");
const business = require("../businessInfo");

module.exports = async function homeRoute(req, res) {
  let products = [];
  let firestoreError = null;

  try {
    products = (await listActiveProducts({limit: 200})).slice(0, 12);
  } catch (err) {
    firestoreError = err.message;
  }

  const gridHtml = firestoreError
    ? `<p class="status status-error">Ürünler yüklenemedi: ${escapeHtml(firestoreError)}</p>`
    : renderProductGrid(products, "Şu anda vitrinde ürün yok.");

  const bodyHtml = `
<section class="hero">
  <p class="eyebrow">İçerenköy'de 20+ yıllık esnaf güvencesi</p>
  <h1>Sıfır ve spot mobilyada en uygun fiyatlar</h1>
  <p class="lede">Beğendiğiniz ürünü WhatsApp'tan sorun, mağazada görüp pazarlık edin. Online ödeme yok — vitrin + WhatsApp + yol tarifi.</p>
  <p><a class="whatsapp-link" href="${business.whatsappUrl()}" rel="noopener">WhatsApp'tan yazın: ${escapeHtml(business.displayPhone)}</a></p>
</section>

<section class="section">
  <h2>Yeni Eklenenler</h2>
  ${gridHtml}
</section>`;

  res.set("Cache-Control", "public, max-age=60");
  res.status(200).send(renderLayout({
    title: "Ana Sayfa",
    path: "/",
    bodyHtml,
    jsonLd: {
      "@context": "https://schema.org",
      "@type": "FurnitureStore",
      "name": "Sağlam Spot",
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
