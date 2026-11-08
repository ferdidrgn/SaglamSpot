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
  <button type="button" class="admin-tab" data-admin-tab="notifications" role="tab" aria-selected="false">Bildirimler</button>
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

  <section class="section-header" style="margin-top:var(--space-xxxl)">
    <h2>Etkileşim İstatistikleri</h2>
    <p class="lede">Görüntülenme, WhatsApp tıklaması, favori ve satış — tarih aralığına göre.</p>
  </section>

  <div class="admin-filter-panel">
    <p class="eyebrow" style="margin-bottom:0">Tarih Aralığı</p>
    <div class="admin-filter-chips" id="engagement-range-chips">
      <button type="button" class="search-quick-chip admin-filter-chip is-active" data-range="today">Bugün</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-range="week">Bu Hafta</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-range="month">Bu Ay</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-range="year">Bu Yıl</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-range="custom">Özel</button>
    </div>
    <div class="admin-filter-range" id="engagement-custom-range" style="margin-top:var(--space-md)" hidden>
      <input type="date" id="engagement-date-from">
      <span>–</span>
      <input type="date" id="engagement-date-to">
    </div>
    <p class="eyebrow" style="margin:var(--space-lg) 0 0">Platform</p>
    <div class="admin-filter-chips" id="engagement-platform-chips" style="margin-top:var(--space-sm)">
      <button type="button" class="search-quick-chip admin-filter-chip is-active" data-platform="all">Tümü</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-platform="web">Web</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-platform="mobile">Mobil</button>
    </div>
  </div>

  <div class="admin-stats-grid" id="engagement-kpis"></div>
  <p class="status" id="engagement-web-favorite-note" hidden>
    Not: Web'deki favoriler sadece tarayıcıda saklanır, bu yüzden favori sayısına dahil değildir.
  </p>

  <div class="admin-chart-card admin-chart-wide" style="margin-top:var(--space-xl)">
    <h3>Zaman İçindeki Trend</h3>
    <div class="admin-filter-chips" id="engagement-metric-chips">
      <button type="button" class="search-quick-chip admin-filter-chip is-active" data-metric="view">Görüntülenme</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-metric="contact_click">WhatsApp Tıklaması</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-metric="favorite">Favori</button>
      <button type="button" class="search-quick-chip admin-filter-chip" data-metric="sale">Satış</button>
    </div>
    <div id="chart-engagement-trend" style="margin-top:var(--space-lg)"></div>
  </div>

  <div class="admin-charts-grid" style="margin-top:var(--space-lg)">
    <div class="admin-chart-card admin-chart-wide">
      <h3>Kategoriye Göre Dağılım</h3>
      <div id="chart-engagement-category"></div>
    </div>
    <div class="admin-chart-card admin-chart-wide">
      <h3>En Çok Etkileşim Alan Ürünler</h3>
      <div id="chart-engagement-top"></div>
    </div>
  </div>
</div>

<div id="admin-panel-notifications" class="admin-panel" data-admin-panel="notifications" hidden>
  <section class="section-header">
    <h2>Yeni Bildirim Gönder</h2>
    <p class="lede">Tüm kullanıcılara ya da bir segmente gerçek bir push bildirimi/kampanya mesajı gönderin.</p>
  </section>

  <form id="campaign-form" class="admin-form" style="max-width:560px">
    <label>Başlık
      <input type="text" id="campaign-title" name="title" required maxlength="80">
    </label>
    <label>Mesaj
      <textarea id="campaign-body" name="body" rows="3" required maxlength="200" placeholder="Örn: Bu hafta sonu tüm oturma gruplarında %20 indirim!"></textarea>
    </label>

    <label>Bağlantı (opsiyonel)
      <select id="campaign-link-type">
        <option value="none">Yok</option>
        <option value="product">Bir ürüne git</option>
        <option value="page">Bir sayfaya git</option>
      </select>
    </label>
    <div data-field="campaign-product" hidden>
      <label>Ürün
        <select id="campaign-product-select"></select>
      </label>
    </div>
    <div data-field="campaign-page" hidden>
      <label>Sayfa
        <select id="campaign-page-select">
          <option value="/discover">Keşfet</option>
          <option value="/new">Sıfır Ürünler</option>
          <option value="/spot">Spot Ürünler</option>
        </select>
      </label>
    </div>

    <label>Kime gönderilsin?
      <select id="campaign-segment">
        <option value="all">Tüm Kullanıcılar</option>
        <option value="favorited">Favorisi Olanlar</option>
        <option value="category">Kategori Takipçileri</option>
      </select>
    </label>
    <div data-field="campaign-category" hidden>
      <label>Kategori
        <select id="campaign-category-select">${Object.entries(CATEGORY_LABELS).map(([value, label]) => `<option value="${value}">${label}</option>`).join("")}</select>
      </label>
    </div>

    <p id="campaign-error" class="status status-error" hidden></p>
    <div class="admin-form-actions">
      <button type="submit"><span class="btn-label">Bildirimi Gönder</span></button>
    </div>
  </form>
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
