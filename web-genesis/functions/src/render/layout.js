const fs = require("node:fs");
const path = require("node:path");
const crypto = require("node:crypto");
const business = require("../businessInfo");
const {t, isRtl, SUPPORTED_LOCALES, DEFAULT_LOCALE, NATIVE_NAMES} = require("../i18n");

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

function escapeHtml(value) {
  return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
}

// Arama sekmesi bilerek metin yerine evrensel bir ikon kullanıyor — ARB'de
// tek kelimelik bağımsız bir "Ara" anahtarı yok ve 11 dilin hepsi için
// güvenilir bir kaynak olmadan kendimiz çeviri UYDURMUYORUZ (brief'in
// açık isteği). İkon bu sorunu dile bağımlı olmadan çözüyor.
function navItems(locale, path) {
  return [
    {href: "/", label: t(locale, "home")},
    {href: "/sifir", label: t(locale, "newCollection")},
    {href: "/spot", label: t(locale, "spotProducts")},
    {href: "/arama", label: "🔍", ariaLabel: t(locale, "filter")},
    {href: "/hakkimizda", label: t(locale, "aboutUs")},
    {href: "/sss", label: t(locale, "sss")},
    {href: "/sepet", label: t(locale, "cartTitle"), cart: true},
  ];
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
  locale = DEFAULT_LOCALE,
}) {
  const siteName = business.brandName;
  const fullTitle = title ? `${title} – ${siteName}` : t(locale, "seoHomeTitle");
  const safeDescription = escapeHtml(description || t(locale, "seoHomeDesc"));

  const navHtml = navItems(locale, path).map((item) => {
    const active = item.href === path ? " aria-current=\"page\"" : "";
    const aria = item.ariaLabel ? ` aria-label="${escapeHtml(item.ariaLabel)}"` : "";
    const badge = item.cart ? " <span id=\"cart-badge\" class=\"cart-badge\" hidden>0</span>" : "";
    return `<a class="nav-link" href="${escapeHtml(item.href)}"${active}${aria}>${item.label}${badge}</a>`;
  }).join("\n");

  const langOptionsHtml = SUPPORTED_LOCALES.map((loc) =>
    `<option value="${loc}" ${loc === locale ? "selected" : ""}>${escapeHtml(NATIVE_NAMES[loc])}</option>`).join("");

  const jsonLdHtml = jsonLd ? `<script type="application/ld+json">${JSON.stringify(jsonLd)}</script>` : "";
  const dir = isRtl(locale) ? "rtl" : "ltr";

  return `<!DOCTYPE html>
<html lang="${locale}" dir="${dir}">
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
  <a class="brand" href="/">${escapeHtml(siteName)}</a>
  <div class="site-nav-group">
    <nav class="site-nav" aria-label="${escapeHtml(t(locale, "home"))}">
      ${navHtml}
    </nav>
    <select id="lang-switcher" data-lang-switcher aria-label="Language">${langOptionsHtml}</select>
  </div>
</header>
<main id="content">
${bodyHtml}
</main>
<footer class="site-footer">
  <p>${escapeHtml(business.address.line)}, ${escapeHtml(business.address.district)}/${escapeHtml(business.address.city)}</p>
  <p><a href="${business.whatsappUrl()}" rel="noopener">WhatsApp: <bdi>${escapeHtml(business.displayPhone)}</bdi></a></p>
  <p>${escapeHtml(t(locale, "allRightsReserved"))}</p>
</footer>
<script src="${versionedAsset("static/js/main.js")}" defer></script>
${inlineData ? `<script>window.__DATA__ = ${JSON.stringify(inlineData)};</script>` : ""}
${extraScripts.map((s) => `<script src="${versionedAsset(s)}" type="module"></script>`).join("\n")}
</body>
</html>`;
}

module.exports = {renderLayout, escapeHtml};
