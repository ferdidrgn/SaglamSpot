const express = require("express");
const homeRoute = require("./routes/home");
const {newProductsRoute, spotProductsRoute} = require("./routes/listing");
const productDetailRoute = require("./routes/productDetail");
const searchRoute = require("./routes/search");
const {renderLayout} = require("./render/layout");

const app = express();
app.disable("x-powered-by");

app.get("/", homeRoute);
app.get("/sifir", newProductsRoute);
app.get("/spot", spotProductsRoute);
app.get("/arama", searchRoute);
app.get("/product/:slugWithId", productDetailRoute);

app.use((req, res) => {
  res.status(404).send(renderLayout({
    title: "Sayfa bulunamadı",
    path: req.path,
    bodyHtml: "<section class=\"not-found\"><h1>Sayfa bulunamadı</h1><p>Aradığınız sayfa mevcut değil.</p></section>",
  }));
});

module.exports = app;
