const {renderLayout} = require("../render/layout");
const firebaseWebConfig = require("../firebaseWebConfig");
const {CATEGORY_LABELS, WEAR_TIER_LABELS} = require("../categories");

/**
 * Admin panelinde kimlik doğrulama ve TÜM Firestore/Storage yazma işlemleri
 * İSTEMCİ TARAFINDA, doğrudan Firebase SDK ile yapılır — Flutter admin
 * panelinin yaptığı ile AYNI desen. Bunu güvenli kılan, bu sunucuda
 * yazdığımız bir şey değil; zaten DEPLOY EDİLMİŞ olan firestore.rules/
 * storage.rules'taki isAdmin() kontrolleridir (bkz. o dosyalardaki notlar).
 * Bu sayfalar bu yüzden sadece birer İSKELET (shell) — gerçek iş
 * public/static/js/admin-*.js'te.
 */

function loginRoute(req, res) {
  const bodyHtml = `
<section class="section-header admin-narrow">
  <p class="eyebrow">Yönetici</p>
  <h1>Giriş Yap</h1>
</section>
<form id="admin-login-form" class="admin-form admin-narrow">
  <label>E-posta<input type="email" name="email" required autocomplete="username"></label>
  <label>Şifre<input type="password" name="password" required autocomplete="current-password"></label>
  <p id="admin-login-error" class="status status-error" hidden></p>
  <button type="submit">Giriş Yap</button>
</form>`;

  res.set("Cache-Control", "no-store");
  res.status(200).send(renderLayout({
    title: "Yönetici Girişi",
    path: "/admin/login",
    bodyHtml,
    robots: "noindex, nofollow",
    extraScripts: ["static/js/firebase-client.js", "static/js/admin-login.js"],
    inlineData: {firebaseConfig: firebaseWebConfig},
  }));
}

function dashboardRoute(req, res) {
  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">Yönetici</p>
  <h1>Ürün Yönetimi</h1>
  <div class="admin-toolbar">
    <button type="button" id="admin-new-product-btn">+ Yeni Ürün</button>
    <button type="button" id="admin-logout-btn" class="admin-secondary-btn">Çıkış Yap</button>
  </div>
</section>
<div id="admin-app" data-admin-app>
  <p class="status">Yükleniyor...</p>
</div>
<div id="admin-form-modal" class="admin-modal" hidden>
  <div class="admin-modal-content">
    <button type="button" id="admin-form-close" class="admin-modal-close" aria-label="Kapat">&times;</button>
    <form id="admin-product-form" class="admin-form"></form>
  </div>
</div>`;

  res.set("Cache-Control", "no-store");
  res.status(200).send(renderLayout({
    title: "Yönetici Paneli",
    path: "/admin",
    bodyHtml,
    robots: "noindex, nofollow",
    extraScripts: ["static/js/firebase-client.js", "static/js/admin-dashboard.js"],
    inlineData: {
      firebaseConfig: firebaseWebConfig,
      categoryLabels: CATEGORY_LABELS,
      wearTierLabels: WEAR_TIER_LABELS,
    },
  }));
}

module.exports = {loginRoute, dashboardRoute};
