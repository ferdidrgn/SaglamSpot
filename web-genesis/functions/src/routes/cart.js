const {renderLayout} = require("../render/layout");

/**
 * Sepet tamamen İSTEMCİ TARAFINDA (localStorage) tutulur — gerçek bir
 * ödeme/checkout akışı yok, sadece "mağazaya toplu soru listesi" (bkz.
 * lib/features/cart/presentation/pages/cart_page.dart'taki aynı kavram).
 * Bu yüzden içerik sunucuda render edilmiyor; public/static/js/main.js
 * sayfa yüklendiğinde #cart-app içini dolduruyor. Kişiye özel/geçici bir
 * sayfa olduğu için noindex.
 */
module.exports = function cartRoute(req, res) {
  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">Sepet</p>
  <h1>Sorma Listeniz</h1>
  <p class="lede">Beğendiğiniz ürünleri ekleyin, hepsini tek bir WhatsApp mesajıyla sorun. Online ödeme yok.</p>
</section>
<section class="section">
  <div id="cart-app" data-cart-app>
    <noscript><p class="status status-error">Sepeti görmek için JavaScript gerekli. Ürünleri doğrudan WhatsApp'tan da sorabilirsiniz.</p></noscript>
  </div>
</section>`;

  res.set("Cache-Control", "no-store");
  res.status(200).send(renderLayout({
    title: "Sepet",
    path: "/sepet",
    bodyHtml,
    robots: "noindex, nofollow",
  }));
};
