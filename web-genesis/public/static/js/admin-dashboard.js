import {
  auth, db, storage, functions,
  onAuthStateChanged, firebaseSignOut, isCurrentUserAdmin,
  collection, doc, getDocs, setDoc, updateDoc, deleteDoc,
  storageRef, uploadBytes, getDownloadURL, deleteObject,
  httpsCallable,
} from "./firebase-client.js";

const categoryLabels = (window.__DATA__ && window.__DATA__.categoryLabels) || {};
const wearTierLabels = (window.__DATA__ && window.__DATA__.wearTierLabels) || {};

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

let productsCache = [];
const selectedIds = new Set();

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
onAuthStateChanged(auth, async (user) => {
  if (!user) {
    window.location.href = "/admin/login";
    return;
  }
  const admin = await isCurrentUserAdmin();
  if (!admin) {
    await firebaseSignOut(auth);
    window.location.href = "/admin/login";
    return;
  }
  loadProducts();
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
  <div class="admin-row-actions">
    <button type="button" data-action="edit">Düzenle</button>
    <button type="button" data-action="toggle-sold">${p.isSold ? "Satıldı Kaldır" : "Satıldı İşaretle"}</button>
    <button type="button" data-action="toggle-reserved">${p.isReserved ? "Rezerve Kaldır" : "Rezerve Et"}</button>
    <button type="button" data-action="delete" class="admin-danger-btn">Sil</button>
  </div>
</div>`;
}

searchInput?.addEventListener("input", renderList);
filterSelect?.addEventListener("change", renderList);

document.getElementById("admin-bulk-sold")?.addEventListener("click", () => bulkSetSold(true));
document.getElementById("admin-bulk-unsold")?.addEventListener("click", () => bulkSetSold(false));
document.getElementById("admin-bulk-delete")?.addEventListener("click", handleBulkDelete);

async function bulkSetSold(sold) {
  const ids = [...selectedIds];
  if (!ids.length) return;
  try {
    await Promise.all(ids.map((id) => updateDoc(doc(db, "Product", id), {
      isSold: sold,
      _soldAt: sold ? formattedNow() : "",
    })));
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
  <label>Renk Seçenekleri (opsiyonel, virgülle ayrılmış hex — örn. #2E7D6B,#C79868)
    <input type="text" name="availableColors" value="${escapeHtml((product && product.availableColors || []).join(","))}">
  </label>
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

  function sync(isSpot) {
    wearTierField.hidden = !isSpot;
    colorsField.hidden = isSpot;
  }

  radios.forEach((radio) => radio.addEventListener("change", () => sync(radio.value === "true" && radio.checked)));
  sync(initialIsSpot);
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
