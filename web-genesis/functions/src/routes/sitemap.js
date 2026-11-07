const {listActiveProducts} = require("../productRepo");
const {getBaseUrl} = require("../requestUrl");

/**
 * functions/index.js'teki sitemap() ile AYNI amaç, ama bu sitenin KENDİ
 * domain'i için (istek üzerinden okunuyor — SHARE_DOMAIN/saglamspotcu.web.app
 * DEĞİL, çünkü bu, web-genesis'in kendi SEO'su içindir). Statik sayfalar +
 * satılmamış tüm ürünler.
 */
function escapeXml(value) {
  return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&apos;");
}

module.exports = async function sitemapRoute(req, res) {
  const baseUrl = getBaseUrl(req);
  const today = new Date().toISOString().slice(0, 10);

  const staticEntries = ["/", "/sifir", "/spot", "/arama", "/sepet", "/hakkimizda", "/sss", "/gizlilik"]
      .map((path) => ({loc: `${baseUrl}${path}`, lastmod: today, changefreq: "daily", priority: path === "/" ? "1.0" : "0.7"}));

  let productEntries = [];
  try {
    const products = await listActiveProducts({limit: 500});
    productEntries = products.map((p) => ({
      loc: `${baseUrl}${p.path}`,
      lastmod: today,
      changefreq: "weekly",
      priority: "0.6",
    }));
  } catch (_) {
    // Firestore erişilemezse bile statik sayfalarla geçerli bir sitemap dön.
  }

  const entries = [...staticEntries, ...productEntries];
  const body = entries.map((e) => `  <url>
    <loc>${escapeXml(e.loc)}</loc>
    <lastmod>${e.lastmod}</lastmod>
    <changefreq>${e.changefreq}</changefreq>
    <priority>${e.priority}</priority>
  </url>`).join("\n");

  const xml = `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${body}\n</urlset>\n`;

  res.set("Content-Type", "application/xml; charset=utf-8");
  res.set("Cache-Control", "public, max-age=3600");
  res.status(200).send(xml);
};
