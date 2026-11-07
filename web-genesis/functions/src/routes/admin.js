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
<div class="admin-login-stage">
  <div class="admin-login-card">
    <span class="admin-login-mark">S</span>
    <p class="eyebrow" style="justify-content:center">Yönetici</p>
    <h1>Giriş Yap</h1>
    <form id="admin-login-form" class="admin-form">
      <label>E-posta<input type="email" name="email" required autocomplete="username"></label>
      <label>Şifre<input type="password" name="password" required autocomplete="current-password"></label>
      <p id="admin-login-error" class="status status-error" hidden></p>
      <button type="submit"><span class="btn-label">Giriş Yap</span></button>
    </form>
  </div>
</div>`;

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
  const categoryChipsHtml = Object.entries(CATEGORY_LABELS).map(([value, label]) => `
    <label class="search-quick-chip admin-filter-chip">
      <input type="checkbox" name="statsCategory" value="${value}" hidden> ${label}
    </label>`).join("");

  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">Yönetici</p>
  <h1>Yönetim Paneli</h1>
  <div class="admin-toolbar">
    <button type="button" id="admin-new-product-btn">+ Yeni Ürün</button>
    <button type="button" id="admin-logout-btn" class="admin-secondary-btn">Çıkış Yap</button>
  </div>
</section>

<div class="admin-tabs" role="tablist">
  <button type="button" class="admin-tab is-active" data-admin-tab="products" role="tab" aria-selected="true">Ürünler</button>
  <button type="button" class="admin-tab" data-admin-tab="stats" role="tab" aria-selected="false">İstatistikler</button>
</div>

<div id="admin-panel-products" class="admin-panel is-active" data-admin-panel="products">
  <div class="admin-search-bar">
    <input type="search" id="admin-search-input" placeholder="Ürün adı veya açıklamada ara...">
    <select id="admin-filter-select">
      <option value="all">Tümü</option>
      <option value="new">Sıfır</option>
      <option value="used">İkinci El</option>
      <option value="sold">Satıldı</option>
      <option value="reserved">Rezerve</option>
    </select>
  </div>
  <div id="admin-bulk-bar" class="admin-bulk-bar" hidden>
    <span id="admin-bulk-count"></span>
    <div class="admin-bulk-actions">
      <button type="button" id="admin-bulk-sold">Satıldı İşaretle</button>
      <button type="button" id="admin-bulk-unsold" class="admin-secondary-btn">Satıldı Kaldır</button>
      <button type="button" id="admin-bulk-delete" class="admin-danger-btn">Seçilenleri Sil</button>
    </div>
  </div>
  <div id="admin-app" data-admin-app>
    <p class="status">Yükleniyor...</p>
  </div>
</div>

<div id="admin-panel-stats" class="admin-panel" data-admin-panel="stats" hidden>
  <div class="admin-filter-panel">
    <p class="eyebrow" style="margin-bottom:0">Filtrele</p>
    <div class="admin-filter-grid">
      <div class="admin-filter-field">
        <label for="stats-condition">Durum</label>
        <select id="stats-condition">
          <option value="all">Tümü</option>
          <option value="new">Sıfır</option>
          <option value="used">İkinci El</option>
        </select>
      </div>
      <div class="admin-filter-field">
        <label for="stats-status">Satış Durumu</label>
        <select id="stats-status">
          <option value="all">Tümü</option>
          <option value="active">Aktif</option>
          <option value="sold">Satıldı</option>
          <option value="reserved">Rezerve</option>
        </select>
      </div>
      <div class="admin-filter-field">
        <label>Fiyat Aralığı (₺)</label>
        <div class="admin-filter-range">
          <input type="number" id="stats-min-price" min="0" placeholder="Min">
          <span>–</span>
          <input type="number" id="stats-max-price" min="0" placeholder="Max">
        </div>
      </div>
      <div class="admin-filter-field">
        <label>Eklenme Tarihi</label>
        <div class="admin-filter-range">
          <input type="date" id="stats-date-from">
          <span>–</span>
          <input type="date" id="stats-date-to">
        </div>
      </div>
    </div>
    <div class="admin-filter-field" style="margin-top:var(--space-lg)">
      <label>Kategori (birden fazla seçilebilir)</label>
      <div class="admin-filter-chips" id="stats-category-chips">${categoryChipsHtml}</div>
    </div>
    <button type="button" class="admin-filter-reset" id="stats-filter-reset">Filtreleri Temizle</button>
  </div>

  <div class="admin-stats-grid" id="admin-stats-kpis"></div>

  <div class="admin-charts-grid">
    <div class="admin-chart-card">
      <h3>Kategori Dağılımı</h3>
      <div id="chart-category"></div>
    </div>
    <div class="admin-chart-card">
      <h3>Sıfır / İkinci El</h3>
      <div id="chart-condition"></div>
    </div>
    <div class="admin-chart-card">
      <h3>Satış Durumu</h3>
      <div id="chart-status"></div>
    </div>
    <div class="admin-chart-card">
      <h3>Fiyat Aralığı Dağılımı</h3>
      <div id="chart-price"></div>
    </div>
    <div class="admin-chart-card admin-chart-wide">
      <h3>Zaman İçinde Eklenen Ürünler (son 6 ay)</h3>
      <div id="chart-timeline"></div>
    </div>
    <div class="admin-chart-card admin-chart-wide">
      <h3>En Çok Görüntülenen 8 Ürün</h3>
      <div id="chart-top-viewed"></div>
    </div>
    <div class="admin-chart-card admin-chart-wide">
      <h3>Kategoriye Göre Toplam Stok Değeri (₺)</h3>
      <div id="chart-stock-value"></div>
    </div>
  </div>
</div>

<div id="admin-form-modal" class="admin-modal" hidden>
  <div class="admin-modal-content">
    <button type="button" id="admin-form-close" class="admin-modal-close" aria-label="Kapat">&times;</button>
    <form id="admin-product-form" class="admin-form"></form>
  </div>
</div>
<button type="button" class="admin-fab" id="admin-fab-btn" aria-label="Yeni Ürün Ekle">+</button>`;

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
