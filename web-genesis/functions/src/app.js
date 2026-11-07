const express = require("express");
const homeRoute = require("./routes/home");
const {newProductsRoute, spotProductsRoute} = require("./routes/listing");
const productDetailRoute = require("./routes/productDetail");
const searchRoute = require("./routes/search");
const cartRoute = require("./routes/cart");
const favoritesRoute = require("./routes/favorites");
const aboutRoute = require("./routes/about");
const faqRoute = require("./routes/faq");
const sitemapRoute = require("./routes/sitemap");
const {loginRoute, dashboardRoute} = require("./routes/admin");
const {localeMiddleware} = require("./localeMiddleware");
const {renderLayout, escapeHtml} = require("./render/layout");
const {ICONS} = require("./render/icons");
const business = require("./businessInfo");
const {t} = require("./i18n");

const app = express();
app.disable("x-powered-by");
app.use(localeMiddleware);

app.get("/", homeRoute);
app.get("/sifir", newProductsRoute);
app.get("/spot", spotProductsRoute);
app.get("/arama", searchRoute);
app.get("/sepet", cartRoute);
app.get("/favoriler", favoritesRoute);
app.get("/hakkimizda", aboutRoute);
app.get("/sss", faqRoute);
app.get("/sitemap.xml", sitemapRoute);
app.get("/admin/login", loginRoute);
app.get("/admin", dashboardRoute);
app.get("/product/:slugWithId", productDetailRoute);

app.use((req, res) => {
  const locale = req.locale;
  // "Sayfa bulunamadı" tek kelimelik bağımsız bir ARB anahtarı yok (brief:
  // yeniden çeviri yok) — ama altındaki eylemler (Ana Sayfa/Keşfet/WhatsApp)
  // zaten çevrilen anahtarlardan geliyor, sadece başlık/açıklama Türkçe.
  const bodyHtml = `
<section class="not-found">
  <p class="not-found-code">404</p>
  <h1>Sayfa bulunamadı</h1>
  <p class="lede">Aradığınız sayfa taşınmış, satılmış ya da hiç var olmamış olabilir.</p>
  <div class="not-found-actions">
    <a class="hero-pill hero-pill-accent" href="/">${ICONS.explore} ${escapeHtml(t(locale, "home"))}</a>
    <a class="hero-pill hero-pill-outline" style="color:var(--color-text-primary);border-color:var(--color-border)" href="/arama">🔍 ${escapeHtml(t(locale, "searchHint"))}</a>
    <a class="whatsapp-link" href="${business.whatsappUrl(undefined, locale)}" rel="noopener">${escapeHtml(t(locale, "whatsappCta"))}</a>
  </div>
</section>`;

  res.status(404).send(renderLayout({
    req,
    title: "Sayfa bulunamadı",
    path: req.path,
    locale,
    robots: "noindex, nofollow",
    bodyHtml,
  }));
});

module.exports = app;
