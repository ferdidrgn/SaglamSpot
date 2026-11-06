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
const {renderLayout} = require("./render/layout");

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
  res.status(404).send(renderLayout({
    req,
    title: "Sayfa bulunamadı",
    path: req.path,
    locale: req.locale,
    robots: "noindex, nofollow",
    bodyHtml: "<section class=\"not-found\"><h1>Sayfa bulunamadı</h1><p>Aradığınız sayfa mevcut değil.</p></section>",
  }));
});

module.exports = app;
