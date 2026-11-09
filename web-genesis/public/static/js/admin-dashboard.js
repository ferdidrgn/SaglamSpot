import {
  auth, db, storage, functions,
  onAuthStateChanged, firebaseSignOut, isCurrentUserAdmin,
  collection, doc, getDocs, setDoc, updateDoc, deleteDoc, addDoc,
  query, where, orderBy, limit, Timestamp, serverTimestamp,
  storageRef, uploadBytes, getDownloadURL, deleteObject,
  httpsCallable,
} from "./firebase-client.js";
import {renderDonutChart, renderBarChart} from "./admin-charts.js";

const categoryLabels = (window.__DATA__ && window.__DATA__.categoryLabels) || {};
const wearTierLabels = (window.__DATA__ && window.__DATA__.wearTierLabels) || {};

const EDIT_ICON = "<svg width=\"15\" height=\"15\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M12 20h9\"/><path d=\"M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4z\"/></svg>";
const TRASH_ICON = "<svg width=\"15\" height=\"15\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M4 7h16M9 7V4h6v3M6 7l1 13h10l1-13\"/></svg>";

// --- İstatistikler sekmesi ikonları ---
const ICON_BOX = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><path d=\"M3 8l9-5 9 5-9 5-9-5z\"/><path d=\"M3 8v8l9 5 9-5V8\"/><path d=\"M12 13v8\"/></svg>";
const ICON_SPARKLE = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M12 2l1.8 5.6L19 9l-5.2 1.8L12 16l-1.8-5.2L5 9l5.2-1.4z\"/></svg>";
const ICON_TAG = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M20 12.5L12.5 20 3 10.5V3h7.5L20 12.5z\"/><circle cx=\"7.5\" cy=\"7.5\" r=\"1.5\" fill=\"var(--color-surface)\"/></svg>";
const ICON_CLOCK = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><circle cx=\"12\" cy=\"12\" r=\"9\"/><path d=\"M12 7v5l3.5 2\"/></svg>";
const ICON_WALLET = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><path d=\"M3 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7z\"/><path d=\"M16 12h3\"/></svg>";
const ICON_CHART = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><path d=\"M4 20V10M12 20V4M20 20v-7\"/></svg>";
const ICON_EYE = "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><path d=\"M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7-10-7-10-7z\"/><circle cx=\"12\" cy=\"12\" r=\"3\"/></svg>";

// Kategori renkleri lib/features/products/data/models/category_meta.dart
// (defaultCategoryMeta) ile AYNI hex'ler — categories.js'teki CATEGORY_COLORS
// ile birebir aynı liste, sadece burada admin tarafında tekrarlanıyor
// (admin paneli ayrı bir client-side modül, ortak import yok).
const CATEGORY_COLOR_MAP = {
  sofa: "#2E7D6B", chair: "#C5A358", table: "#B2673E", bed: "#6B5CA5",
  wardrobe: "#3E6B8A", white: "#5A8A6B", lighting: "#E0A458", homeTextile: "#C97B84",
  decor: "#8A5A7A", officeFurniture: "#43536B", outdoorGarden: "#4FA8D8",
  kidsFurniture: "#E0724A", other: "#7A7F87",
};
function categoryColorFor(key) {
  return CATEGORY_COLOR_MAP[key] || CATEGORY_COLOR_MAP.other;
}

// Sıfır ürün renk seçenekleri — Flutter'daki ColorVariantPicker
// (lib/features/products/presentation/widgets/color_variant_picker.dart)
// ile AYNI palet: admin hex kodu yazmak yerine dokunarak seçer, mobil ile
// tutarlı aynı renkler çıkar.
const PRODUCT_COLOR_PALETTE = [
  "#0F302A", "#C5A358", "#8B5E3C", "#5A6E6A", "#3E6B8A",
  "#B2673E", "#6B5CA5", "#1A1A1A", "#E5E0D8", "#D32F2F",
];

function colorSwatchesHtml(selectedColors) {
  const extra = selectedColors.filter((c) => !PRODUCT_COLOR_PALETTE.includes(c));
  return [...PRODUCT_COLOR_PALETTE, ...extra].map((hex) => {
    const selected = selectedColors.includes(hex);
    return `<button type="button" class="admin-color-swatch${selected ? " is-selected" : ""}" data-hex="${escapeHtml(hex)}" style="--swatch-color:${escapeHtml(hex)}" aria-pressed="${selected}" aria-label="${escapeHtml(hex)}" title="${escapeHtml(hex)}"></button>`;
  }).join("");
}

// "dd.MM.yyyy, HH:mm" → Date (bkz. productRepo.js parseTrDateTime — admin
// paneli ayrı bir client modül olduğu için burada küçük bir kopyası var).
function parseTrDate(value) {
  if (!value) return null;
  const m = /^(\d{2})\.(\d{2})\.(\d{4})/.exec(value);
  if (!m) return null;
  return new Date(Number(m[3]), Number(m[2]) - 1, Number(m[1]));
}

const appRoot = document.querySelector("[data-admin-app]");
const modal = document.getElementById("admin-form-modal");
const formEl = document.getElementById("admin-product-form");
const newBtn = document.getElementById("admin-new-product-btn");
const logoutBtn = document.getElementById("admin-logout-btn");
const closeBtn = document.getElementById("admin-form-close");
const searchInput = document.getElementById("admin-search-input");
const filterSelect = document.getElementById("admin-filter-select");
const bulkBar = document.getElementById("admin-bulk-bar");
const bulkCountEl = document.getElementById("admin-bulk-count");
const fabBtn = document.getElementById("admin-fab-btn");

let productsCache = [];
const selectedIds = new Set();

// --- Sekmeler (Ürünler / İstatistikler) ---
document.querySelectorAll("[data-admin-tab]").forEach((tabBtn) => {
  tabBtn.addEventListener("click", () => {
    const target = tabBtn.dataset.adminTab;
    document.querySelectorAll("[data-admin-tab]").forEach((b) => {
      b.classList.toggle("is-active", b === tabBtn);
      b.setAttribute("aria-selected", String(b === tabBtn));
    });
    document.querySelectorAll("[data-admin-panel]").forEach((panel) => {
      const active = panel.dataset.adminPanel === target;
      panel.classList.toggle("is-active", active);
      panel.hidden = !active;
    });
    if (target === "stats") {
      renderStats();
      renderEngagementStats();
      renderLikedCategories();
    }
    if (target === "notifications") {
      populateCampaignProductSelect();
      renderCampaignHistory();
    }
  });
});

fabBtn?.addEventListener("click", () => openForm(null));

// window.alert() yerine - admin paneli tek bir sekmede kullanıldığı için
// native tarayıcı diyalogları (akışı tamamen durduran, markasız) yerine
// kısa ömürlü, kendi kendine kapanan bir bildirim yeterli ve daha "modern".
function toast(message, {error = false} = {}) {
  let stack = document.querySelector(".toast-stack");
  if (!stack) {
    stack = document.createElement("div");
    stack.className = "toast-stack";
    document.body.appendChild(stack);
  }
  const el = document.createElement("div");
  el.className = "toast" + (error ? " toast-error" : "");
  el.textContent = message;
  stack.appendChild(el);
  window.setTimeout(() => {
    el.classList.add("is-leaving");
    el.addEventListener("animationend", () => el.remove(), {once: true});
  }, 3200);
}

function escapeHtml(value) {
  return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
}

function formatPrice(value) {
  return `${Math.round(Number(value) || 0).toLocaleString("tr-TR")} ₺`;
}

// lib/core/util/date_formatter.dart'taki nowFormatDateTime() ile aynı biçim.
function formattedNow() {
  const d = new Date();
  const pad = (n) => String(n).padStart(2, "0");
  return `${pad(d.getDate())}.${pad(d.getMonth() + 1)}.${d.getFullYear()}, ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function fileToBase64(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(String(reader.result).split(",")[1] || "");
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}

// --- Auth guard ---
// Bu callback'teki HERHANGİ bir beklenmeyen hata (ör. Firestore
// isteği reddedilirse) önceden hiç yakalanmıyordu - async fonksiyon
// sessizce reddoluyor, ne loadProducts() çağrılıyor ne de girişe
// yönlendiriliyordu; sonuç: admin paneli "Yükleniyor..."da SONSUZA
// KADAR takılı kalıyordu (gerçek kullanıcı geri bildirimiyle
// yakalandı - bkz. firestore.rules/firebase-client.js'teki ilgili
// notlar). Artık ne olursa olsun ya panel yükleniyor ya da kullanıcı
// girişe dönüyor, asla sonsuz "Yükleniyor..." kalmıyor.
onAuthStateChanged(auth, async (user) => {
  if (!user) {
    window.location.href = "/admin/login";
    return;
  }
  try {
    const admin = await isCurrentUserAdmin();
    if (!admin) {
      await firebaseSignOut(auth);
      window.location.href = "/admin/login";
      return;
    }
    await loadProducts();
  } catch (err) {
    console.error("Admin oturum kontrolü başarısız:", err);
    appRoot.innerHTML = `<p class="status status-error">Yönetici kontrolü başarısız oldu: ${escapeHtml(err.message)}. Sayfayı yenileyin ya da tekrar giriş yapın.</p>`;
  }
});

logoutBtn.addEventListener("click", async () => {
  await firebaseSignOut(auth);
  window.location.href = "/admin/login";
});

// --- Liste ---
async function loadProducts() {
  appRoot.innerHTML = "<p class=\"status\">Yükleniyor...</p>";
  try {
    const snap = await getDocs(collection(db, "Product"));
    productsCache = snap.docs.map((d) => ({...d.data(), _docId: d.id}));
    renderList();
    renderStats();
  } catch (err) {
    appRoot.innerHTML = `<p class="status status-error">Ürünler yüklenemedi: ${escapeHtml(err.message)}</p>`;
  }
}

function findByDocId(docId) {
  return productsCache.find((p) => p._docId === docId);
}

// Arama/filtre tamamen istemci tarafında — envanter boyutu (onlarca/
// yüzlerce ürün) için ayrı bir Firestore sorgusu gerektirmeyecek kadar
// küçük, zaten tüm liste belleğe çekilmiş durumda (loadProducts).
function filteredProducts() {
  const needle = (searchInput?.value || "").toLocaleLowerCase("tr-TR").trim();
  const filter = filterSelect?.value || "all";
  return productsCache.filter((p) => {
    if (needle) {
      const haystack = `${p.name || ""} ${p.desc || ""}`.toLocaleLowerCase("tr-TR");
      if (!haystack.includes(needle)) return false;
    }
    if (filter === "new" && p.isSpotProduct) return false;
    if (filter === "used" && !p.isSpotProduct) return false;
    if (filter === "sold" && !p.isSold) return false;
    if (filter === "reserved" && !p.isReserved) return false;
    return true;
  });
}

function renderList() {
  if (!productsCache.length) {
    appRoot.innerHTML = "<p class=\"status\">Henüz ürün yok. \"+ Yeni Ürün\" ile ekleyin.</p>";
    updateBulkBar();
    return;
  }

  const visible = filteredProducts().sort((a, b) => (b._createdAt || "").localeCompare(a._createdAt || ""));
  if (!visible.length) {
    appRoot.innerHTML = "<p class=\"status\">Bu arama/filtreyle eşleşen ürün yok.</p>";
    updateBulkBar();
    return;
  }

  // Artık görünmeyen satırların seçimi sessizce düşer (şaşırtıcı "görünmez
  // seçim" durumunu önler).
  const visibleIds = new Set(visible.map((p) => p._docId));
  [...selectedIds].forEach((id) => { if (!visibleIds.has(id)) selectedIds.delete(id); });

  const rowsHtml = visible.map(renderRow).join("");
  appRoot.innerHTML = `<div class="admin-table">${rowsHtml}</div>`;

  appRoot.querySelectorAll("[data-row-id]").forEach((row) => {
    const docId = row.dataset.rowId;
    row.querySelector("[data-select]").addEventListener("change", (e) => {
      if (e.target.checked) selectedIds.add(docId);
      else selectedIds.delete(docId);
      row.classList.toggle("is-selected", e.target.checked);
      updateBulkBar();
    });
    row.querySelector("[data-action=edit]").addEventListener("click", () => openForm(findByDocId(docId)));
    row.querySelector("[data-action=toggle-sold]").addEventListener("click", () => toggleField(docId, "isSold"));
    row.querySelector("[data-action=toggle-reserved]").addEventListener("click", () => toggleField(docId, "isReserved"));
    row.querySelector("[data-action=delete]").addEventListener("click", () => handleDelete(docId));
  });

  updateBulkBar();
}

function updateBulkBar() {
  if (!bulkBar) return;
  const count = selectedIds.size;
  bulkBar.hidden = count === 0;
  if (count > 0) bulkCountEl.textContent = `${count} ürün seçili`;
}

function renderRow(p) {
  const img = (p.imagesUrl || []).find((u) => u) || "";
  const flags = [];
  if (p.isSold) flags.push("<span class=\"badge badge-sold\">Satıldı</span>");
  if (p.isReserved) flags.push("<span class=\"badge badge-reserved\">Rezerve</span>");

  return `
<div class="admin-row${selectedIds.has(p._docId) ? " is-selected" : ""}" data-row-id="${escapeHtml(p._docId)}">
  <input type="checkbox" class="admin-row-select" data-select ${selectedIds.has(p._docId) ? "checked" : ""} aria-label="Seç">
  <div class="admin-row-thumb">${img ? `<img src="${escapeHtml(img)}" alt="" loading="lazy">` : "<div class=\"card-image-placeholder\">Görsel yok</div>"}</div>
  <div class="admin-row-info">
    <p class="admin-row-name">${escapeHtml(p.name || "(isimsiz)")}</p>
    <p class="admin-row-meta">${escapeHtml(categoryLabels[p.category] || p.category || "")} · ${p.isSpotProduct ? "İkinci El" : "Sıfır"} · ${formatPrice(p.price)}</p>
    <p class="admin-row-flags">${flags.join(" ")}</p>
  </div>
  <div class="admin-row-switches">
    <button type="button" class="admin-switch${p.isSold ? " is-on" : ""}" data-action="toggle-sold" role="switch" aria-checked="${p.isSold ? "true" : "false"}">
      <span class="admin-switch-track"></span>Satıldı
    </button>
    <button type="button" class="admin-switch is-danger${p.isReserved ? " is-on" : ""}" data-action="toggle-reserved" role="switch" aria-checked="${p.isReserved ? "true" : "false"}">
      <span class="admin-switch-track"></span>Rezerve
    </button>
  </div>
  <div class="admin-row-actions">
    <button type="button" class="admin-row-icon-btn" data-action="edit" aria-label="Düzenle" title="Düzenle">${EDIT_ICON}</button>
    <button type="button" class="admin-row-icon-btn admin-danger-btn" data-action="delete" aria-label="Sil" title="Sil">${TRASH_ICON}</button>
  </div>
</div>`;
}

// --- İstatistikler sekmesi: filtreler tamamen Ürünler sekmesindeki
// aynı productsCache üzerinden hesaplanır (ayrı bir Firestore sorgusu
// yok) — "her şeyle filtre yapılabilsin" isteği üzerine durum/satış
// durumu/fiyat aralığı/tarih aralığı/kategori (çoklu seçim) hepsi
// birlikte uygulanıyor, tüm grafikler + KPI kartları aynı anda güncelleniyor.
function statsFilterState() {
  const categories = [...document.querySelectorAll("#stats-category-chips input:checked")].map((c) => c.value);
  return {
    condition: document.getElementById("stats-condition")?.value || "all",
    status: document.getElementById("stats-status")?.value || "all",
    minPrice: Number(document.getElementById("stats-min-price")?.value) || null,
    maxPrice: Number(document.getElementById("stats-max-price")?.value) || null,
    dateFrom: document.getElementById("stats-date-from")?.value || "",
    dateTo: document.getElementById("stats-date-to")?.value || "",
    categories,
  };
}

function statsFilteredProducts() {
  const f = statsFilterState();
  return productsCache.filter((p) => {
    if (f.condition === "new" && p.isSpotProduct) return false;
    if (f.condition === "used" && !p.isSpotProduct) return false;
    if (f.status === "active" && p.isSold) return false;
    if (f.status === "sold" && !p.isSold) return false;
    if (f.status === "reserved" && !p.isReserved) return false;
    if (f.categories.length && !f.categories.includes(p.category)) return false;
    const price = Number(p.price) || 0;
    if (f.minPrice != null && price < f.minPrice) return false;
    if (f.maxPrice != null && price > f.maxPrice) return false;
    const created = parseTrDate(p._createdAt);
    if (f.dateFrom && created && created < new Date(f.dateFrom)) return false;
    if (f.dateTo && created && created > new Date(`${f.dateTo}T23:59:59`)) return false;
    return true;
  });
}

function renderStats() {
  const kpiEl = document.getElementById("admin-stats-kpis");
  if (!kpiEl) return;
  const list = statsFilteredProducts();

  const activeCount = list.filter((p) => !p.isSold).length;
  const soldCount = list.filter((p) => p.isSold).length;
  const reservedCount = list.filter((p) => p.isReserved && !p.isSold).length;
  const totalValue = list.filter((p) => !p.isSold).reduce((s, p) => s + (Number(p.price) || 0), 0);
  const avgPrice = activeCount ? Math.round(totalValue / activeCount) : 0;
  const totalViews = list.reduce((s, p) => s + (Number(p.viewCountWeb) || 0) + (Number(p.viewCountMobile) || 0), 0);

  const kpis = [
    [ICON_BOX, "var(--color-primary)", list.length.toLocaleString("tr-TR"), "Toplam Ürün"],
    [ICON_SPARKLE, "var(--color-success)", activeCount.toLocaleString("tr-TR"), "Aktif Ürün"],
    [ICON_TAG, "var(--color-error)", soldCount.toLocaleString("tr-TR"), "Satıldı"],
    [ICON_CLOCK, "var(--color-warning)", reservedCount.toLocaleString("tr-TR"), "Rezerve"],
    [ICON_WALLET, "var(--color-accent)", `${totalValue.toLocaleString("tr-TR")} ₺`, "Aktif Stok Değeri"],
    [ICON_CHART, "var(--color-info)", `${avgPrice.toLocaleString("tr-TR")} ₺`, "Ortalama Fiyat"],
    [ICON_EYE, "var(--color-accent-dark)", totalViews.toLocaleString("tr-TR"), "Toplam Görüntülenme"],
  ];
  kpiEl.innerHTML = kpis.map(([icon, color, value, label], i) => `
    <div class="admin-stat-card" style="--stat-color:${color};animation-delay:${i * 40}ms">
      <span class="admin-stat-icon">${icon}</span>
      <span class="admin-stat-text"><strong>${value}</strong><span>${label}</span></span>
    </div>`).join("");

  const catCounts = {};
  list.forEach((p) => { catCounts[p.category] = (catCounts[p.category] || 0) + 1; });
  const catSegments = Object.entries(catCounts)
      .map(([key, value]) => ({label: categoryLabels[key] || key, value, color: categoryColorFor(key)}))
      .sort((a, b) => b.value - a.value);
  renderDonutChart(document.getElementById("chart-category"), catSegments, {centerLabel: "ürün"});

  renderDonutChart(document.getElementById("chart-condition"), [
    {label: "Sıfır", value: list.filter((p) => !p.isSpotProduct).length, color: "#2E7D32"},
    {label: "İkinci El", value: list.filter((p) => p.isSpotProduct).length, color: "var(--color-accent)"},
  ], {centerLabel: "ürün"});

  renderDonutChart(document.getElementById("chart-status"), [
    {label: "Aktif", value: activeCount - reservedCount, color: "var(--color-success)"},
    {label: "Rezerve", value: reservedCount, color: "var(--color-warning)"},
    {label: "Satıldı", value: soldCount, color: "var(--color-error)"},
  ], {centerLabel: "ürün"});

  const priceBuckets = [[0, 500], [500, 1000], [1000, 2500], [2500, 5000], [5000, Infinity]];
  renderBarChart(document.getElementById("chart-price"), priceBuckets.map(([min, max]) => ({
    label: max === Infinity ? `${min}+` : `${min}-${max}`,
    value: list.filter((p) => { const price = Number(p.price) || 0; return price >= min && price < max; }).length,
    color: "var(--color-accent)",
  })));

  const months = [];
  const now = new Date();
  for (let i = 5; i >= 0; i--) {
    const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
    months.push({key: `${d.getFullYear()}-${d.getMonth()}`, label: d.toLocaleDateString("tr-TR", {month: "short"}), count: 0});
  }
  list.forEach((p) => {
    const created = parseTrDate(p._createdAt);
    if (!created) return;
    const bucket = months.find((m) => m.key === `${created.getFullYear()}-${created.getMonth()}`);
    if (bucket) bucket.count += 1;
  });
  renderBarChart(document.getElementById("chart-timeline"), months.map((m) => ({label: m.label, value: m.count, color: "var(--color-primary)"})));

  const topViewed = list
      .map((p) => ({...p, _views: (Number(p.viewCountWeb) || 0) + (Number(p.viewCountMobile) || 0)}))
      .filter((p) => p._views > 0)
      .sort((a, b) => b._views - a._views)
      .slice(0, 8);
  renderBarChart(document.getElementById("chart-top-viewed"), topViewed.map((p) => ({
    label: p.name && p.name.length > 9 ? `${p.name.slice(0, 9)}…` : (p.name || "?"),
    value: p._views,
    color: "var(--color-info)",
  })));

  const stockByCategory = {};
  list.filter((p) => !p.isSold).forEach((p) => {
    stockByCategory[p.category] = (stockByCategory[p.category] || 0) + (Number(p.price) || 0);
  });
  renderBarChart(
      document.getElementById("chart-stock-value"),
      Object.entries(stockByCategory)
          .sort((a, b) => b[1] - a[1])
          .map(([key, value]) => ({label: categoryLabels[key] || key, value, color: categoryColorFor(key)})),
      {valueFormatter: (v) => `${v.toLocaleString("tr-TR")}₺`},
  );
}

["stats-condition", "stats-status", "stats-min-price", "stats-max-price", "stats-date-from", "stats-date-to"].forEach((id) => {
  const el = document.getElementById(id);
  el?.addEventListener("input", renderStats);
  el?.addEventListener("change", renderStats);
});

document.getElementById("stats-category-chips")?.addEventListener("change", renderStats);

document.getElementById("stats-filter-reset")?.addEventListener("click", () => {
  ["stats-min-price", "stats-max-price", "stats-date-from", "stats-date-to"].forEach((id) => {
    const el = document.getElementById(id);
    if (el) el.value = "";
  });
  const conditionEl = document.getElementById("stats-condition");
  const statusEl = document.getElementById("stats-status");
  if (conditionEl) conditionEl.value = "all";
  if (statusEl) statusEl.value = "all";
  document.querySelectorAll("#stats-category-chips input").forEach((c) => { c.checked = false; });
  renderStats();
});

searchInput?.addEventListener("input", renderList);
filterSelect?.addEventListener("change", renderList);

document.getElementById("admin-bulk-sold")?.addEventListener("click", () => bulkSetSold(true));
document.getElementById("admin-bulk-unsold")?.addEventListener("click", () => bulkSetSold(false));
document.getElementById("admin-bulk-delete")?.addEventListener("click", handleBulkDelete);

// Admin > İstatistikler ekranındaki tarih filtreli "satış" metriği ve
// gelir trendi BURADAN gelir (bkz. firestore.rules > analytics_events,
// isAdmin() dalı) — sadece satılmamış → satıldı GEÇİŞİNDE yazılır,
// "Satıldı Kaldır" ya da zaten satılmış bir ürünü tekrar işaretlemede
// tekrar sayılmaz.
async function logSaleEvent(product) {
  try {
    await addDoc(collection(db, "analytics_events"), {
      type: "sale",
      productId: product._docId,
      category: product.category || "other",
      platform: "web",
      price: Number(product.price) || 0,
      createdAt: serverTimestamp(),
    });
  } catch (err) {
    console.error("logSaleEvent başarısız:", err);
  }
}

async function bulkSetSold(sold) {
  const ids = [...selectedIds];
  if (!ids.length) return;
  try {
    const newlySold = sold ? ids.map((id) => findByDocId(id)).filter((p) => p && !p.isSold) : [];
    await Promise.all(ids.map((id) => updateDoc(doc(db, "Product", id), {
      isSold: sold,
      _soldAt: sold ? formattedNow() : "",
    })));
    await Promise.all(newlySold.map((p) => logSaleEvent(p)));
    selectedIds.clear();
    await loadProducts();
    toast(`${ids.length} ürün güncellendi.`);
  } catch (err) {
    toast("Toplu güncelleme başarısız: " + err.message, {error: true});
  }
}

async function handleBulkDelete() {
  const ids = [...selectedIds];
  if (!ids.length) return;
  if (!window.confirm(`${ids.length} ürün silinsin mi? Bu geri alınamaz.`)) return;
  try {
    await Promise.all(ids.map((id) => deleteDoc(doc(db, "Product", id))));
    selectedIds.clear();
    await loadProducts();
    toast(`${ids.length} ürün silindi.`);
  } catch (err) {
    toast("Toplu silme başarısız: " + err.message, {error: true});
  }
}

async function toggleField(docId, field) {
  const product = findByDocId(docId);
  if (!product) return;
  const next = !product[field];
  const update = {[field]: next};
  if (field === "isSold") update._soldAt = next ? formattedNow() : "";
  try {
    await updateDoc(doc(db, "Product", docId), update);
    if (field === "isSold" && next) await logSaleEvent(product);
    await loadProducts();
    toast("Güncellendi.");
  } catch (err) {
    toast("Güncellenemedi: " + err.message, {error: true});
  }
}

async function handleDelete(docId) {
  const product = findByDocId(docId);
  if (!product) return;
  if (!window.confirm(`"${product.name}" silinsin mi? Bu geri alınamaz.`)) return;
  try {
    await deleteDoc(doc(db, "Product", docId));
    await loadProducts();
    toast("Ürün silindi.");
  } catch (err) {
    toast("Silinemedi: " + err.message, {error: true});
  }
}

// --- Form (ekle/düzenle) ---
newBtn.addEventListener("click", () => openForm(null));
closeBtn.addEventListener("click", closeForm);
modal.addEventListener("click", (e) => {
  if (e.target === modal) closeForm();
});

function closeForm() {
  // Önce saydamlaş (CSS transition), sonra DOM'dan tamamen kaldır -
  // "hidden" anında atlanırsa geçiş hiç görünmezdi.
  modal.classList.remove("is-open");
  window.setTimeout(() => {
    modal.hidden = true;
    formEl.innerHTML = "";
    delete formEl.dataset.editId;
  }, 220);
}

function openForm(product) {
  formEl.dataset.editId = product ? product._docId : "";
  formEl.innerHTML = renderFormHtml(product);
  modal.hidden = false;
  // Bir sonraki frame'de class eklenir ki tarayıcı "hidden kalkışı"nı
  // transition'ın BAŞLANGICI olarak değil, başlangıç durumu olarak görsün.
  requestAnimationFrame(() => modal.classList.add("is-open"));
  wireFormDynamic(Boolean(product && product.isSpotProduct));
  formEl.addEventListener("submit", handleSubmit, {once: true});
}

function renderFormHtml(product) {
  const isEdit = Boolean(product);
  const isSpot = product ? Boolean(product.isSpotProduct) : false;

  const categoryOptions = Object.entries(categoryLabels)
      .map(([value, label]) => `<option value="${value}" ${product && product.category === value ? "selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");
  const wearTierOptions = Object.entries(wearTierLabels)
      .map(([value, label]) => `<option value="${value}" ${product && product.wearTier === value ? "selected" : ""}>${escapeHtml(label)}</option>`)
      .join("");

  return `
<h2>${isEdit ? "Ürünü Düzenle" : "Yeni Ürün"}</h2>
<label>Ürün Adı
  <input type="text" name="name" required value="${escapeHtml(product ? product.name || "" : "")}">
</label>
<label>Açıklama
  <textarea name="desc" rows="3">${escapeHtml(product ? product.desc || "" : "")}</textarea>
</label>
<label>Kategori
  <select name="category">${categoryOptions}</select>
</label>
<fieldset class="admin-radio-group">
  <legend>Durum</legend>
  <label><input type="radio" name="isSpotProduct" value="false" ${!isSpot ? "checked" : ""}> Sıfır</label>
  <label><input type="radio" name="isSpotProduct" value="true" ${isSpot ? "checked" : ""}> İkinci El</label>
</fieldset>
<label>Fiyat (₺)
  <input type="number" name="price" min="0" step="1" required value="${product && product.price != null ? product.price : ""}">
</label>
<label>Önceki Fiyat (opsiyonel — "İndirimde" rozeti için)
  <input type="number" name="previousPrice" min="0" step="1" value="${product && product.previousPrice != null ? product.previousPrice : ""}">
</label>
<label>Ölçüler (opsiyonel)
  <input type="text" name="dimensions" placeholder="örn. 220 x 90 x 85 cm" value="${escapeHtml(product ? product.dimensions || "" : "")}">
</label>
<label>Malzeme (opsiyonel)
  <input type="text" name="material" placeholder="örn. Masif Meşe" value="${escapeHtml(product ? product.material || "" : "")}">
</label>
<div data-field="wearTier" ${isSpot ? "" : "hidden"}>
  <label>Yıpranma Durumu
    <select name="wearTier"><option value="">Seçiniz</option>${wearTierOptions}</select>
  </label>
</div>
<div data-field="availableColors" ${isSpot ? "hidden" : ""}>
  <label>Renk Seçenekleri (opsiyonel — dokunarak seç, ya da "+" ile istediğin rengi seç)</label>
  <div class="admin-color-swatches" data-color-swatches>
    ${colorSwatchesHtml((product && product.availableColors) || [])}
    <label class="admin-color-swatch-custom" title="Özel renk seç">
      +
      <input type="color" data-color-custom-input value="#8B5E3C">
    </label>
  </div>
  <input type="hidden" name="availableColors" data-colors-input value="${escapeHtml((product && product.availableColors || []).join(","))}">
</div>
<label>Fotoğraflar ${isEdit ? "(boş bırakırsanız mevcut görseller korunur)" : ""}
  <input type="file" name="images" accept="image/*" multiple>
</label>
<label class="admin-checkbox-label">
  <input type="checkbox" name="generateStudio"> Stüdyo (arka plansız) versiyon da oluştur
</label>
<label class="admin-checkbox-label">
  <input type="checkbox" name="isReserved" ${product && product.isReserved ? "checked" : ""}> Rezerve (bir müşteri ilgileniyor)
</label>
<p id="admin-form-error" class="status status-error" hidden></p>
<p id="admin-form-progress" class="status" hidden></p>
<div class="admin-form-actions">
  <button type="submit"><span class="btn-label">${isEdit ? "Kaydet" : "Ürünü Ekle"}</span></button>
</div>`;
}

function wireFormDynamic(initialIsSpot) {
  const radios = formEl.querySelectorAll("input[name=isSpotProduct]");
  const wearTierField = formEl.querySelector("[data-field=wearTier]");
  const colorsField = formEl.querySelector("[data-field=availableColors]");
  const colorsInput = formEl.querySelector("[data-colors-input]");
  const swatchesEl = formEl.querySelector("[data-color-swatches]");

  function sync(isSpot) {
    wearTierField.hidden = !isSpot;
    colorsField.hidden = isSpot;
  }

  radios.forEach((radio) => radio.addEventListener("change", () => sync(radio.value === "true" && radio.checked)));
  sync(initialIsSpot);

  function syncColorsInput() {
    const selected = [...swatchesEl.querySelectorAll(".admin-color-swatch[aria-pressed=true]")].map((b) => b.dataset.hex);
    colorsInput.value = selected.join(",");
  }

  // Hex yazmak yerine dokunarak seç — seçili swatch'ları virgüllü hex
  // listesine çevirip gizli input'a yaz (handleSubmit hâlâ aynı
  // availableColors alanını okuyor).
  swatchesEl?.addEventListener("click", (event) => {
    const btn = event.target.closest(".admin-color-swatch");
    if (!btn) return;
    const nowSelected = btn.getAttribute("aria-pressed") !== "true";
    btn.setAttribute("aria-pressed", String(nowSelected));
    btn.classList.toggle("is-selected", nowSelected);
    syncColorsInput();
  });

  // "+" özel renk seçici — tarayıcının kendi RGB/renk tekerleği popup'ını
  // açar; seçilen rengi paletteki gibi yeni bir swatch olarak ekler (zaten
  // varsa onu seçili yapar, tekrar eklemez).
  const customInput = formEl.querySelector("[data-color-custom-input]");
  customInput?.addEventListener("change", () => {
    const hex = customInput.value.toUpperCase();
    let btn = swatchesEl.querySelector(`.admin-color-swatch[data-hex="${hex}"]`);
    if (!btn) {
      btn = document.createElement("button");
      btn.type = "button";
      btn.className = "admin-color-swatch";
      btn.dataset.hex = hex;
      btn.style.setProperty("--swatch-color", hex);
      btn.title = hex;
      btn.setAttribute("aria-label", hex);
      customInput.closest(".admin-color-swatch-custom").insertAdjacentElement("beforebegin", btn);
    }
    btn.setAttribute("aria-pressed", "true");
    btn.classList.add("is-selected");
    syncColorsInput();
  });
}

async function handleSubmit(event) {
  event.preventDefault();
  const errorEl = document.getElementById("admin-form-error");
  const progressEl = document.getElementById("admin-form-progress");
  const submitBtn = formEl.querySelector("button[type=submit]");
  errorEl.hidden = true;
  submitBtn.disabled = true;

  try {
    const fd = new FormData(formEl);
    const editId = formEl.dataset.editId || "";
    const existing = editId ? findByDocId(editId) : null;

    const isSpotProduct = fd.get("isSpotProduct") === "true";
    const name = String(fd.get("name") || "").trim();
    const desc = String(fd.get("desc") || "").trim();
    const category = String(fd.get("category") || "other");
    const price = Number(fd.get("price")) || 0;
    const previousPriceRaw = fd.get("previousPrice");
    const previousPrice = previousPriceRaw ? Number(previousPriceRaw) : null;
    const dimensions = String(fd.get("dimensions") || "").trim() || null;
    const material = String(fd.get("material") || "").trim() || null;
    const wearTier = isSpotProduct ? (String(fd.get("wearTier") || "") || null) : null;
    const colorsRaw = String(fd.get("availableColors") || "").trim();
    const availableColors = !isSpotProduct && colorsRaw ? colorsRaw.split(",").map((s) => s.trim()).filter(Boolean) : [];
    const isReserved = fd.get("isReserved") === "on";
    const generateStudio = fd.get("generateStudio") === "on";

    const docRef = editId ? doc(db, "Product", editId) : doc(collection(db, "Product"));
    const id = docRef.id;

    const files = formEl.querySelector("input[name=images]").files;
    let imagesUrl = existing ? (existing.imagesUrl || []) : [];

    if (files && files.length) {
      progressEl.hidden = false;
      progressEl.textContent = "Görseller yükleniyor...";

      // Yeni fotoğraf seçildiyse eskileri değiştiriyoruz — Storage'daki
      // eski orijinalleri best-effort sil (başarısız olursa önemli değil).
      if (existing) {
        for (const url of existing.imagesUrl || []) {
          if (!url) continue;
          try {
            const path = decodeURIComponent(new URL(url).pathname.split("/o/")[1] || "");
            if (path) await deleteObject(storageRef(storage, path));
          } catch (_) {
            // Storage URL'den yol çıkarılamadı ya da zaten yok — yok say.
          }
        }
      }

      const uploadedUrls = [];
      for (let i = 0; i < files.length; i++) {
        const ref = storageRef(storage, `product_images/${id}/${i}.jpg`);
        await uploadBytes(ref, files[i]);
        uploadedUrls.push(await getDownloadURL(ref));
      }

      const studioUrls = [];
      if (generateStudio) {
        const removeBg = httpsCallable(functions, "removeProductBackground");
        for (let i = 0; i < files.length; i++) {
          progressEl.textContent = `Stüdyo görsel oluşturuluyor (${i + 1}/${files.length})...`;
          try {
            const imageBase64 = await fileToBase64(files[i]);
            const result = await removeBg({imageBase64});
            if (result.data && result.data.success && result.data.studioImageUrl) {
              studioUrls.push(result.data.studioImageUrl);
            }
          } catch (_) {
            // Kota dolu/hata — orijinal görsel zaten yüklendi, stüdyo
            // versiyonu sessizce atlanır (Flutter ile aynı davranış).
          }
        }
      }

      imagesUrl = [...uploadedUrls, ...studioUrls];
      progressEl.hidden = true;
    }

    const now = formattedNow();
    const data = {
      _id: id,
      name,
      desc,
      category,
      price,
      isSold: existing ? Boolean(existing.isSold) : false,
      isSpotProduct,
      isReserved,
      dimensions,
      material,
      previousPrice,
      availableColors,
      studioImagesUrl: [],
      imagesUrl,
      wearTier,
      viewCountWeb: existing ? (existing.viewCountWeb || 0) : 0,
      viewCountMobile: existing ? (existing.viewCountMobile || 0) : 0,
      _updatedAt: now,
      _createdAt: existing ? (existing._createdAt || now) : now,
      _soldAt: existing ? (existing._soldAt || "") : "",
    };

    await setDoc(docRef, data);
    closeForm();
    await loadProducts();
    toast(editId ? "Ürün güncellendi." : "Ürün eklendi.");
  } catch (err) {
    errorEl.textContent = "Hata: " + err.message;
    errorEl.hidden = false;
    submitBtn.disabled = false;
    formEl.addEventListener("submit", handleSubmit, {once: true});
  }
}

// --- "Etkileşim İstatistikleri" (görüntülenme/tıklama/favori/satış,
// tarih aralığı + platform filtreli) — ESKİ istatistikler bölümünün
// (yukarıda, statsFilteredProducts tabanlı) AKSİNE, bu bölüm ürün
// dokümanlarından değil `analytics_events` koleksiyonundan (bkz.
// core/services/analytics_event_logger.dart'ın web karşılığı:
// web-genesis/functions/src/analyticsEvents.js) okur — gerçek, zaman
// damgalı olaylar. Envanter anlık görüntüsü (stok değeri, fiyat
// dağılımı vb.) hâlâ değerli olduğu için YUKARIDAKİ bölüm KALDIRILMADI,
// bu YENİ bölüm onun yanına eklendi.
const engagementState = {range: "today", customFrom: "", customTo: "", platform: "all", metric: "view"};
let engagementEventsCache = null; // {key, events}

function engagementRangeDates() {
  const now = new Date();
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  switch (engagementState.range) {
    case "week": {
      const start = new Date(today);
      start.setDate(start.getDate() - ((today.getDay() + 6) % 7)); // Pazartesi
      return {start, end: today};
    }
    case "month":
      return {start: new Date(now.getFullYear(), now.getMonth(), 1), end: today};
    case "year":
      return {start: new Date(now.getFullYear(), 0, 1), end: today};
    case "custom": {
      const from = engagementState.customFrom ? new Date(engagementState.customFrom) : today;
      const to = engagementState.customTo ? new Date(engagementState.customTo) : today;
      return {start: from, end: to};
    }
    default: // "today"
      return {start: today, end: today};
  }
}

async function fetchEngagementEvents() {
  const {start, end} = engagementRangeDates();
  const key = `${start.toISOString()}_${end.toISOString()}`;
  if (engagementEventsCache && engagementEventsCache.key === key) return engagementEventsCache.events;

  const endInclusive = new Date(end);
  endInclusive.setHours(23, 59, 59, 999);

  const eventsQuery = query(
      collection(db, "analytics_events"),
      where("createdAt", ">=", Timestamp.fromDate(start)),
      where("createdAt", "<=", Timestamp.fromDate(endInclusive)),
      orderBy("createdAt"),
  );
  const snap = await getDocs(eventsQuery);
  const events = snap.docs.map((d) => {
    const data = d.data();
    return {
      type: data.type,
      productId: data.productId,
      category: data.category || "other",
      platform: data.platform || "mobile",
      price: typeof data.price === "number" ? data.price : null,
      createdAt: data.createdAt && data.createdAt.toDate ? data.createdAt.toDate() : new Date(),
    };
  });
  engagementEventsCache = {key, events};
  return events;
}

function engagementTrendBars(events) {
  const {start, end} = engagementRangeDates();
  const days = Math.round((end - start) / 86400000) + 1;
  const bucketByMonth = days > 120;
  const bucketByWeek = !bucketByMonth && days > 31;

  function weekStartOf(d) {
    const ws = new Date(d);
    ws.setDate(ws.getDate() - ((ws.getDay() + 6) % 7));
    return ws;
  }
  function keyFor(d) {
    if (bucketByMonth) return `${d.getFullYear()}-${d.getMonth()}`;
    if (bucketByWeek) {
      const ws = weekStartOf(d);
      return `${ws.getFullYear()}-${ws.getMonth()}-${ws.getDate()}`;
    }
    return `${d.getFullYear()}-${d.getMonth()}-${d.getDate()}`;
  }
  function labelFor(d) {
    return bucketByMonth ? d.toLocaleDateString("tr-TR", {month: "short"}) : `${d.getDate()}/${d.getMonth() + 1}`;
  }

  const buckets = new Map();
  if (bucketByMonth) {
    let cursor = new Date(start.getFullYear(), start.getMonth(), 1);
    const endCursor = new Date(end.getFullYear(), end.getMonth(), 1);
    while (cursor <= endCursor) {
      buckets.set(keyFor(cursor), {label: labelFor(cursor), count: 0});
      cursor = new Date(cursor.getFullYear(), cursor.getMonth() + 1, 1);
    }
  } else {
    const step = bucketByWeek ? 7 : 1;
    let cursor = new Date(start);
    while (cursor <= end) {
      buckets.set(keyFor(cursor), {label: labelFor(cursor), count: 0});
      cursor = new Date(cursor.getFullYear(), cursor.getMonth(), cursor.getDate() + step);
    }
  }

  events.forEach((e) => {
    const bucket = buckets.get(keyFor(e.createdAt));
    if (bucket) bucket.count += 1;
  });

  return [...buckets.values()].map((b) => ({label: b.label, value: b.count, color: "var(--color-primary)"}));
}

const ENGAGEMENT_METRIC_LABELS = {
  view: "Görüntülenme", contact_click: "WhatsApp Tıklaması", favorite: "Favori", sale: "Satış",
};

async function renderEngagementStats() {
  const kpiEl = document.getElementById("engagement-kpis");
  if (!kpiEl) return;

  let allEvents;
  try {
    allEvents = await fetchEngagementEvents();
  } catch (err) {
    kpiEl.innerHTML = `<p class="status status-error">İstatistikler yüklenemedi: ${escapeHtml(err.message)}</p>`;
    return;
  }

  const events = engagementState.platform === "all" ?
    allEvents :
    allEvents.filter((e) => e.platform === engagementState.platform);

  const views = events.filter((e) => e.type === "view").length;
  const clicks = events.filter((e) => e.type === "contact_click").length;
  const favorites = events.filter((e) => e.type === "favorite").length;
  const sales = events.filter((e) => e.type === "sale");
  const revenue = sales.reduce((s, e) => s + (e.price || 0), 0);

  const kpis = [
    [ICON_EYE, "var(--color-info)", views.toLocaleString("tr-TR"), "Görüntülenme"],
    [ICON_SPARKLE, "var(--color-success)", clicks.toLocaleString("tr-TR"), "WhatsApp Tıklaması"],
    [ICON_TAG, "var(--color-error)", favorites.toLocaleString("tr-TR"), "Favori"],
    [ICON_WALLET, "var(--color-accent)", sales.length.toLocaleString("tr-TR"), "Satış"],
    [ICON_CHART, "var(--color-primary)", `${revenue.toLocaleString("tr-TR")} ₺`, "Gelir"],
  ];
  kpiEl.innerHTML = kpis.map(([icon, color, value, label], i) => `
    <div class="admin-stat-card" style="--stat-color:${color};animation-delay:${i * 40}ms">
      <span class="admin-stat-icon">${icon}</span>
      <span class="admin-stat-text"><strong>${value}</strong><span>${label}</span></span>
    </div>`).join("");

  const favoriteNote = document.getElementById("engagement-web-favorite-note");
  if (favoriteNote) favoriteNote.hidden = engagementState.platform === "mobile";

  const metricEvents = events.filter((e) => e.type === engagementState.metric);

  renderBarChart(document.getElementById("chart-engagement-trend"), engagementTrendBars(metricEvents));

  const catCounts = {};
  metricEvents.forEach((e) => { catCounts[e.category] = (catCounts[e.category] || 0) + 1; });
  renderBarChart(
      document.getElementById("chart-engagement-category"),
      Object.entries(catCounts)
          .sort((a, b) => b[1] - a[1])
          .map(([key, value]) => ({label: categoryLabels[key] || key, value, color: categoryColorFor(key)})),
  );

  const prodCounts = {};
  metricEvents.forEach((e) => { prodCounts[e.productId] = (prodCounts[e.productId] || 0) + 1; });
  const topBars = Object.entries(prodCounts)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([id, value]) => {
        const product = findByDocId(id);
        const name = product ? product.name : id;
        return {
          label: name.length > 12 ? `${name.slice(0, 12)}…` : name,
          value,
          color: "var(--color-info)",
        };
      });
  renderBarChart(document.getElementById("chart-engagement-top"), topBars);
}

// "Kategori beğenme" (bkz. lib/core/providers/category_likes_provider.dart)
// — CategoryMeta/{kategori}.likeCount, Product.viewCountWeb/Mobile'daki
// AYNI "basit, dürüst, anonim sayaç" deseni. Tarih/platform filtresinden
// BAĞIMSIZ, her zaman güncel bir toplam olduğu için renderEngagementStats'ın
// (tarih aralığına bağlı) akışının dışında, sekme her açıldığında bir kez
// okunur.
async function renderLikedCategories() {
  const container = document.getElementById("chart-liked-categories");
  if (!container) return;
  try {
    const snap = await getDocs(collection(db, "CategoryMeta"));
    const bars = snap.docs
        .map((d) => ({key: d.id, count: d.data().likeCount || 0}))
        .filter((e) => e.count > 0)
        .sort((a, b) => b.count - a.count)
        .slice(0, 8)
        .map((e) => ({
          label: categoryLabels[e.key] || e.key,
          value: e.count,
          color: categoryColorFor(e.key),
        }));
    renderBarChart(container, bars);
  } catch (err) {
    container.innerHTML = `<p class="status status-error">Yüklenemedi: ${escapeHtml(err.message)}</p>`;
  }
}

// Önceden gönderilmiş kampanyaların "kime, kaç cihaza gitti" geçmişi —
// `notification_broadcasts`'tan (bkz. functions/index.js >
// sendCampaignNotification'ın yazdığı segment/sentCount alanları) okunur.
// Bu alanlar eklenmeden önce bu bilgi hiçbir yerde kalıcı görünmüyordu —
// sadece gönderim anındaki tek seferlik toast'ta (bkz. Flutter tarafındaki
// AYNI not: campaign_notification_provider.dart > campaignHistoryProvider).
const CAMPAIGN_SEGMENT_LABELS = {
  all: "Tüm Kullanıcılar",
  favorited: "Favorisi Olanlar",
  "favorited_condition:new": "Sıfır Ürünle İlgilenenler",
  "favorited_condition:spot": "İkinci El ile İlgilenenler",
};
function campaignSegmentLabel(segment) {
  if (!segment) return "";
  if (CAMPAIGN_SEGMENT_LABELS[segment]) return CAMPAIGN_SEGMENT_LABELS[segment];
  if (segment.startsWith("category:")) {
    const key = segment.slice("category:".length);
    return `Kategori Takipçileri: ${categoryLabels[key] || key}`;
  }
  if (segment.startsWith("favorited_price:")) return "Fiyat Aralığıyla İlgilenenler";
  return segment;
}
function campaignSentCountLabel(sentCount) {
  if (sentCount === null || sentCount === undefined) return "";
  if (sentCount < 0) return "Bildirim tüm kullanıcılara gönderildi.";
  if (sentCount === 0) return "Gönderildi ama bu segmentte hiç cihaz bulunamadı.";
  return `Bildirim ${sentCount} cihaza gönderildi.`;
}
async function renderCampaignHistory() {
  const container = document.getElementById("campaign-history");
  if (!container) return;
  try {
    const snap = await getDocs(query(
        collection(db, "notification_broadcasts"),
        where("type", "==", "admin_campaign"),
        orderBy("createdAt", "desc"),
        limit(10),
    ));
    if (snap.empty) {
      container.innerHTML = "<p class=\"lede\">Henüz kampanya gönderilmedi.</p>";
      return;
    }
    container.innerHTML = snap.docs.map((d) => {
      const data = d.data();
      const meta = [campaignSegmentLabel(data.segment), campaignSentCountLabel(data.sentCount)]
          .filter(Boolean).join(" · ");
      return `<div class="admin-list-row">
        <strong>${escapeHtml(data.title || "")}</strong>
        <p class="status">${escapeHtml(meta)}</p>
      </div>`;
    }).join("");
  } catch (err) {
    container.innerHTML = `<p class="status status-error">Yüklenemedi: ${escapeHtml(err.message)}</p>`;
  }
}

document.querySelectorAll("#engagement-range-chips [data-range]").forEach((btn) => {
  btn.addEventListener("click", () => {
    document.querySelectorAll("#engagement-range-chips [data-range]")
        .forEach((b) => b.classList.toggle("is-active", b === btn));
    engagementState.range = btn.dataset.range;
    const customRangeEl = document.getElementById("engagement-custom-range");
    if (customRangeEl) customRangeEl.hidden = btn.dataset.range !== "custom";
    if (btn.dataset.range !== "custom") renderEngagementStats();
  });
});

["engagement-date-from", "engagement-date-to"].forEach((id) => {
  document.getElementById(id)?.addEventListener("change", () => {
    engagementState.customFrom = document.getElementById("engagement-date-from").value;
    engagementState.customTo = document.getElementById("engagement-date-to").value;
    if (engagementState.range === "custom" && engagementState.customFrom && engagementState.customTo) {
      renderEngagementStats();
    }
  });
});

document.querySelectorAll("#engagement-platform-chips [data-platform]").forEach((btn) => {
  btn.addEventListener("click", () => {
    document.querySelectorAll("#engagement-platform-chips [data-platform]")
        .forEach((b) => b.classList.toggle("is-active", b === btn));
    engagementState.platform = btn.dataset.platform;
    renderEngagementStats();
  });
});

document.querySelectorAll("#engagement-metric-chips [data-metric]").forEach((btn) => {
  btn.addEventListener("click", () => {
    document.querySelectorAll("#engagement-metric-chips [data-metric]")
        .forEach((b) => b.classList.toggle("is-active", b === btn));
    engagementState.metric = btn.dataset.metric;
    renderEngagementStats();
  });
});

// --- "Bildirimler" sekmesi: gerçek FCM kampanya gönderimi ---
// `functions/index.js > sendCampaignNotification` — Flutter admin
// panelinin (bkz. lib/features/home/presentation/providers/
// campaign_notification_provider.dart) çağırdığı AYNI callable, burada
// web istemci SDK'sıyla çağrılıyor. Tek gönderim mantığı, iki istemci.
const campaignForm = document.getElementById("campaign-form");
const campaignLinkType = document.getElementById("campaign-link-type");
const campaignProductField = document.querySelector("[data-field=campaign-product]");
const campaignPageField = document.querySelector("[data-field=campaign-page]");
const campaignProductSelect = document.getElementById("campaign-product-select");
const campaignSegment = document.getElementById("campaign-segment");
const campaignCategoryField = document.querySelector("[data-field=campaign-category]");
const campaignPriceField = document.querySelector("[data-field=campaign-price]");
const campaignPriceMin = document.getElementById("campaign-price-min");
const campaignPriceMax = document.getElementById("campaign-price-max");
const campaignAudiencePreview = document.getElementById("campaign-audience-preview");
const campaignErrorEl = document.getElementById("campaign-error");

campaignLinkType?.addEventListener("change", () => {
  if (campaignProductField) campaignProductField.hidden = campaignLinkType.value !== "product";
  if (campaignPageField) campaignPageField.hidden = campaignLinkType.value !== "page";
});

// Admin'in seçtiği segmentin GERÇEK Firestore segment string'i — "price"
// (UI'da ayrı bir seçenek, min/max alanları gerektirir) dışında select
// değeriyle birebir aynı. Alanlar eksik/geçersizse (ör. fiyat aralığı
// henüz girilmemiş) null döner — ne önizleme ne gönderim yapılabilir.
function resolveCampaignSegmentValue() {
  if (campaignSegment.value === "category") {
    return `category:${document.getElementById("campaign-category-select").value}`;
  }
  if (campaignSegment.value === "price") {
    const min = Number(campaignPriceMin.value);
    const max = Number(campaignPriceMax.value);
    if (!Number.isFinite(min) || !Number.isFinite(max) || min < 0 || max < min) return null;
    return `favorited_price:${Math.round(min)}-${Math.round(max)}`;
  }
  return campaignSegment.value;
}

// Admin GÖNDERMEDEN ÖNCE seçtiği segmentte gerçekte kaç cihaz olduğunu
// görsün diye (bkz. functions/index.js > getCampaignSegmentSize) —
// "Favorisi Olanlar" segmentinin aslında TÜM kullanıcılara gitmiş gibi
// görünmesi (kök neden: favori listesi cihazda hiç kalıcı tutulmuyordu)
// esnafta güven kaybına yol açmıştı. "all" için kesin sayı FCM konu
// aboneliğinden sorgulanamaz — sahte bir sayı UYDURULMAZ, durum açıkça
// yazılır.
let audiencePreviewToken = 0;
async function refreshAudiencePreview() {
  if (!campaignAudiencePreview) return;
  const segmentValue = resolveCampaignSegmentValue();
  const token = ++audiencePreviewToken;

  if (!segmentValue) {
    campaignAudiencePreview.textContent = "";
    return;
  }
  if (segmentValue === "all") {
    campaignAudiencePreview.textContent = "Tüm cihazlar — kesin sayı önceden gösterilemez.";
    return;
  }

  campaignAudiencePreview.textContent = "Hedef kitle sayılıyor…";
  try {
    const getSize = httpsCallable(functions, "getCampaignSegmentSize");
    const result = await getSize({segment: segmentValue});
    if (token !== audiencePreviewToken) return; // Kullanıcı bu arada segmenti değiştirdi.
    const size = result.data && typeof result.data.size === "number" ? result.data.size : null;
    campaignAudiencePreview.textContent = size === null ?
      "Tüm cihazlar — kesin sayı önceden gösterilemez." :
      size === 0 ?
        "Bu segmentte şu an hiç cihaz yok." :
        `Bu segmentte şu an ${size} cihaz var.`;
  } catch (err) {
    if (token !== audiencePreviewToken) return;
    campaignAudiencePreview.textContent = "";
    console.error("getCampaignSegmentSize başarısız:", err);
  }
}

campaignSegment?.addEventListener("change", () => {
  if (campaignCategoryField) campaignCategoryField.hidden = campaignSegment.value !== "category";
  if (campaignPriceField) campaignPriceField.hidden = campaignSegment.value !== "price";
  refreshAudiencePreview();
});
document.getElementById("campaign-category-select")?.addEventListener("change", refreshAudiencePreview);
// Fiyat alanları her tuşta yeniden sorgulamaz (gereksiz Firestore taraması) —
// yalnızca alandan çıkınca (blur) önizleme tazelenir.
campaignPriceMin?.addEventListener("blur", refreshAudiencePreview);
campaignPriceMax?.addEventListener("blur", refreshAudiencePreview);

function populateCampaignProductSelect() {
  if (!campaignProductSelect) return;
  const available = productsCache.filter((p) => !p.isSold);
  campaignProductSelect.innerHTML = available.length ?
    available.map((p) => `<option value="${escapeHtml(p._docId)}">${escapeHtml(p.name)}</option>`).join("") :
    "<option value=\"\" disabled>Önce bir ürün ekleyin</option>";
}

campaignForm?.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!campaignErrorEl) return;
  campaignErrorEl.hidden = true;

  const title = document.getElementById("campaign-title").value.trim();
  const body = document.getElementById("campaign-body").value.trim();
  if (!title || !body) {
    campaignErrorEl.textContent = "Başlık ve mesaj gerekli.";
    campaignErrorEl.hidden = false;
    return;
  }

  const segmentValue = resolveCampaignSegmentValue();
  if (!segmentValue) {
    campaignErrorEl.textContent = "Geçerli bir fiyat aralığı girin.";
    campaignErrorEl.hidden = false;
    return;
  }

  if (!window.confirm("Bu bildirim seçtiğiniz hedefteki tüm kullanıcılara gönderilecek. Bu işlem geri alınamaz.")) {
    return;
  }

  const payload = {title, body, segment: segmentValue};
  if (campaignLinkType.value === "product") {
    payload.linkType = "product";
    payload.productId = campaignProductSelect.value;
  } else if (campaignLinkType.value === "page") {
    payload.linkType = "page";
    payload.page = document.getElementById("campaign-page-select").value;
  }

  const submitBtn = campaignForm.querySelector("button[type=submit]");
  submitBtn.disabled = true;
  try {
    const sendCampaign = httpsCallable(functions, "sendCampaignNotification");
    const result = await sendCampaign(payload);
    const sentCount = result.data && typeof result.data.sentCount === "number" ? result.data.sentCount : -1;
    const message = sentCount < 0 ?
      "Bildirim tüm kullanıcılara gönderildi." :
      sentCount === 0 ?
        "Gönderildi ama bu segmentte hiç cihaz bulunamadı." :
        `Bildirim ${sentCount} cihaza gönderildi.`;
    toast(message);
    campaignForm.reset();
    if (campaignProductField) campaignProductField.hidden = true;
    if (campaignPageField) campaignPageField.hidden = true;
    if (campaignCategoryField) campaignCategoryField.hidden = true;
    if (campaignPriceField) campaignPriceField.hidden = true;
    if (campaignAudiencePreview) campaignAudiencePreview.textContent = "";
    renderCampaignHistory();
  } catch (err) {
    campaignErrorEl.textContent = "Bildirim gönderilemedi: " + err.message;
    campaignErrorEl.hidden = false;
  } finally {
    submitBtn.disabled = false;
  }
});
