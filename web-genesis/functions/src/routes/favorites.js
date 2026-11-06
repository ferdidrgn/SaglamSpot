const {renderLayout, escapeHtml} = require("../render/layout");
const {t} = require("../i18n");

/**
 * Favoriler — SEPETTEN bağımsız, sadece kalp ikonuyla işaretlenen ürünler
 * (bkz. lib/features/products/presentation/pages/favorites_page.dart'taki
 * aynı kavram). Sepet gibi tamamen İSTEMCİ TARAFINDA (localStorage) tutulur
 * — sunucu hiçbir favori durumu bilmez, bu yüzden içerik main.js'teki
 * renderFavoritesApp() tarafından dolduruluyor.
 */
module.exports = function favoritesRoute(req, res) {
  const locale = req.locale;

  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">${escapeHtml(t(locale, "favoritesTitle"))}</p>
  <h1>${escapeHtml(t(locale, "favoritesTitle"))}</h1>
  <p class="lede">${escapeHtml(t(locale, "favoritesEmptyDesc"))}</p>
</section>
<section class="section">
  <div id="fav-app" data-fav-app>
    <noscript><p class="status status-error">JS required</p></noscript>
  </div>
</section>`;

  res.set("Cache-Control", "no-store");
  res.status(200).send(renderLayout({
    req,
    title: t(locale, "favoritesTitle"),
    path: "/favoriler",
    bodyHtml,
    locale,
    robots: "noindex, nofollow",
    inlineData: {
      favStrings: {
        emptyTitle: t(locale, "favoritesEmptyTitle"),
        emptyDesc: t(locale, "favoritesEmptyDesc"),
        exploreLabel: t(locale, "exploreButton"),
      },
    },
  }));
};
