const {logAnalyticsEvent} = require("../analyticsEvents");

/**
 * Ürün detay sayfasındaki WhatsApp CTA'sına tıklanınca (bkz.
 * public/static/js/product-gallery.js'teki `data-contact-cta` dinleyicisi)
 * `fetch(..., {keepalive:true})` ile ÇAĞRILIR — anchor varsayılan şekilde
 * wa.me'ye gittiği (sayfa ayrıldığı) için normal bir Firestore istemci
 * yazımı sayfa kapanmadan tamamlanmayabilirdi; `keepalive` bayraklı bir
 * fetch, tarayıcının sayfa ayrılsa bile isteği TAMAMLAMASINI garanti eder
 * (tam bu senaryo için tasarlanmış bir web platformu özelliği).
 *
 * Admin > İstatistikler ekranındaki tarih filtreli "tıklama" metriği
 * BURADAN gelir (bkz. analyticsEvents.js).
 */
module.exports = async function trackClickRoute(req, res) {
  const productId = typeof req.body?.productId === "string" ? req.body.productId : "";
  const category = typeof req.body?.category === "string" ? req.body.category : "other";

  if (productId) {
    await logAnalyticsEvent({type: "contact_click", productId, category, platform: "web"});
  }

  // İçerik umursanmıyor (fetch "gönder ve unut" olarak çağrılıyor) — sadece
  // 204 ile hızlıca kapatılıyor.
  res.status(204).end();
};
