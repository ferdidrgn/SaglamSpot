const fs = require("node:fs");
const path = require("node:path");
const crypto = require("node:crypto");
const business = require("../businessInfo");

/**
 * Statik dosyalar `/static/**` için agresif tarayıcı önbelleklemesi var
 * (bkz. firebase.json). Dosya adı DEĞİŞMEDEN içerik değişirse (her kod
 * güncellemesinde) eski ziyaretçiler günlerce bayat JS/CSS görebilirdi —
 * bu yüzden her dosyanın URL'sine içerik hash'i eklenir: hash değişmediği
 * sürece agresif önbellekleme güvenli, değiştiğinde URL de değişip anında
 * yeni içerik çeker. Build adımı olmadan (hand-rolled) basit bir çözüm.
 */
const _assetHashCache = {};
function versionedAsset(relativePath) {
  if (!_assetHashCache[relativePath]) {
    try {
      const fullPath = path.join(__dirname, "../../../public", relativePath);
      const content = fs.readFileSync(fullPath);
      _assetHashCache[relativePath] = crypto.createHash("sha256").update(content).digest("hex").slice(0, 10);
    } catch (_) {
      _assetHashCache[relativePath] = "0";
    }
  }
  return `/${relativePath}?v=${_assetHashCache[relativePath]}`;
}

const SITE_NAME = "Sağlam Spot";
const NAV_ITEMS = [
  {href: "/", label: "Ana Sayfa"},
  {href: "/sifir", label: "Sıfır Ürünler"},
  {href: "/spot", label: "Spot Ürünler"},
  {href: "/arama", label: "Ara"},
  {href: "/hakkimizda", label: "Hakkımızda"},
  {href: "/sss", label: "SSS"},
  {href: "/sepet", label: "Sepet"},
];

function escapeHtml(value) {
  return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
}

/**
 * Tam bir HTML sayfası döndürür. `bodyHtml` zaten güvenli/escape edilmiş
 * HTML olmalı — bu fonksiyon onu kaçışlamaz (çağıran sorumlu).
 */
function renderLayout({
  title,
  description,
  path = "/",
  bodyHtml,
  jsonLd = null,
  robots = "index, follow",
  extraScripts = [],
  inlineData = null,
}) {
  const fullTitle = title ? `${title} – ${SITE_NAME}` : `${SITE_NAME} – Spot & Sıfır Mobilya`;
  const safeDescription = escapeHtml(description || "Spot ve sıfır mobilyalarda en uygun fiyatlar. Sağlam Spot, 20 yıllık esnaf güvencesiyle hizmetinizde.");

  const navHtml = NAV_ITEMS.map((item) => {
    const active = item.href === path ? " aria-current=\"page\"" : "";
    const badge = item.href === "/sepet" ? " <span id=\"cart-badge\" class=\"cart-badge\" hidden>0</span>" : "";
    return `<a class="nav-link" href="${escapeHtml(item.href)}"${active}>${escapeHtml(item.label)}${badge}</a>`;
  }).join("\n");

  const jsonLdHtml = jsonLd ? `<script type="application/ld+json">${JSON.stringify(jsonLd)}</script>` : "";

  return `<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${escapeHtml(fullTitle)}</title>
<meta name="description" content="${safeDescription}">
<meta name="robots" content="${escapeHtml(robots)}">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${versionedAsset("static/css/tokens.css")}">
<link rel="stylesheet" href="${versionedAsset("static/css/base.css")}">
${jsonLdHtml}
</head>
<body>
<header class="site-header">
  <a class="brand" href="/">${SITE_NAME}</a>
  <nav class="site-nav" aria-label="Ana gezinme">
    ${navHtml}
  </nav>
</header>
<main id="content">
${bodyHtml}
</main>
<footer class="site-footer">
  <p>${escapeHtml(business.address.line)}, ${escapeHtml(business.address.district)}/${escapeHtml(business.address.city)}</p>
  <p><a href="${business.whatsappUrl()}" rel="noopener">WhatsApp: ${escapeHtml(business.displayPhone)}</a></p>
  <p>&copy; ${new Date().getFullYear()} ${SITE_NAME}</p>
</footer>
<script src="${versionedAsset("static/js/main.js")}" defer></script>
${inlineData ? `<script>window.__DATA__ = ${JSON.stringify(inlineData)};</script>` : ""}
${extraScripts.map((s) => `<script src="${versionedAsset(s)}" type="module"></script>`).join("\n")}
</body>
</html>`;
}

module.exports = {renderLayout, escapeHtml};
