const {renderLayout, escapeHtml} = require("../render/layout");
const {t} = require("../i18n");

/**
 * Sepet tamamen İSTEMCİ TARAFINDA (localStorage) tutulur — gerçek bir
 * ödeme/checkout akışı yok, sadece "mağazaya toplu soru listesi" (bkz.
 * lib/features/cart/presentation/pages/cart_page.dart'taki aynı kavram).
 * Bu yüzden içerik sunucuda render edilmiyor; public/static/js/main.js
 * sayfa yüklendiğinde #cart-app içini dolduruyor — bu yüzden gerekli
 * çeviriler main.js'in kullanabilmesi için inlineData ile gönderiliyor
 * (client-side ayrı bir i18n motoru kurmamak için).
 */
module.exports = function cartRoute(req, res) {
  const locale = req.locale;

  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">${escapeHtml(t(locale, "cartTitle"))}</p>
  <h1>${escapeHtml(t(locale, "cartTitle"))}</h1>
  <p class="lede">${escapeHtml(t(locale, "cartEmptyDesc"))}</p>
</section>
<section class="section">
  <div id="cart-app" data-cart-app>
    <noscript><p class="status status-error">JS required</p></noscript>
  </div>
</section>`;

  res.set("Cache-Control", "no-store");
  res.status(200).send(renderLayout({
    req,
    title: t(locale, "cartTitle"),
    path: "/sepet",
    bodyHtml,
    locale,
    robots: "noindex, nofollow",
    inlineData: {
      cartStrings: {
        empty: t(locale, "cartEmptyDesc"),
        total: t(locale, "cartTotalLabel"),
        sendButton: t(locale, "cartWhatsappCta"),
        sending: "…",
        remove: "Kaldır",
        // ARB'de kaynağı yok (brief: yeniden çeviri yok) — bilerek Türkçe.
        note: "Online ödeme yok — mesajı gönderdikten sonra mağazadan dönüş bekleyin.",
        greeting: t(locale, "cartWhatsappGreeting"),
        allProductsLine: t(locale, "cartWhatsappAllProductsLine"),
      },
    },
  }));
};
