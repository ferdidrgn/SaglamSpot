const fs = require("node:fs");
const path = require("node:path");
const crypto = require("node:crypto");
const business = require("../businessInfo");
const {t, isRtl, SUPPORTED_LOCALES, DEFAULT_LOCALE, NATIVE_NAMES} = require("../i18n");
const {getBaseUrl} = require("../requestUrl");

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

// Küçük, tek renkli (currentColor) SVG ikonlar — harici bir ikon fontu/paket
// eklemeden footer sosyal bağlantıları için. Yalnızca çizgi/şekil, metin yok.
const ICON_WHATSAPP = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12.04 2c-5.46 0-9.9 4.44-9.9 9.9 0 1.75.46 3.45 1.32 4.95L2 22l5.25-1.38a9.9 9.9 0 0 0 4.79 1.22h.01c5.46 0 9.9-4.44 9.9-9.9S17.5 2 12.04 2zm5.8 14.17c-.24.68-1.4 1.3-1.93 1.37-.49.07-1.1.1-1.78-.11-.41-.13-.94-.3-1.62-.6-2.84-1.23-4.7-4.1-4.84-4.29-.14-.19-1.15-1.53-1.15-2.92s.72-2.07.98-2.35c.24-.26.52-.33.7-.33h.5c.16 0 .37-.02.58.44.24.56.8 1.93.87 2.07.07.14.12.3.02.49-.1.19-.15.3-.3.47-.14.17-.3.37-.43.5-.14.14-.29.29-.13.57.17.28.74 1.22 1.6 1.97 1.1.98 2.03 1.28 2.31 1.43.28.14.44.12.6-.07.17-.19.72-.84.91-1.13.19-.28.38-.23.63-.14.26.1 1.64.77 1.92.91.28.14.47.21.54.33.07.12.07.68-.17 1.36z\"/></svg>";
const ICON_INSTAGRAM = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" aria-hidden=\"true\"><rect x=\"3\" y=\"3\" width=\"18\" height=\"18\" rx=\"5\"/><circle cx=\"12\" cy=\"12\" r=\"4\"/><circle cx=\"17.2\" cy=\"6.8\" r=\"1\" fill=\"currentColor\" stroke=\"none\"/></svg>";
const ICON_FACEBOOK = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M14 21v-7h2.4l.4-3H14V9.2c0-.9.25-1.5 1.6-1.5H17V5.1C16.7 5 15.8 5 14.8 5c-2.2 0-3.7 1.3-3.7 3.9V11H8.7v3H11v7h3z\"/></svg>";
const ICON_PHONE = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" aria-hidden=\"true\"><path d=\"M6.5 4h3l1.5 4-2 1.5a12 12 0 0 0 5.5 5.5l1.5-2 4 1.5v3a2 2 0 0 1-2.2 2A17 17 0 0 1 4.5 6.2 2 2 0 0 1 6.5 4z\"/></svg>";

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
  req = null,
  image = null,
}) {
  const siteName = business.brandName;
  const fullTitle = title ? `${title} – ${siteName}` : t(locale, "seoHomeTitle");
  const descriptionText = description || t(locale, "seoHomeDesc");
  const safeDescription = escapeHtml(descriptionText);
  const baseUrl = req ? getBaseUrl(req) : null;
  const canonicalUrl = baseUrl ? `${baseUrl}${path}` : null;
  const ogImage = image || (baseUrl ? `${baseUrl}/icons/Icon-512.png` : null);

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
${canonicalUrl ? `<link rel="canonical" href="${escapeHtml(canonicalUrl)}">` : ""}
<link rel="icon" type="image/png" href="${versionedAsset("icons/Icon-192.png")}">
<link rel="apple-touch-icon" href="${versionedAsset("icons/Icon-192.png")}">
<meta property="og:site_name" content="${escapeHtml(siteName)}">
<meta property="og:title" content="${escapeHtml(fullTitle)}">
<meta property="og:description" content="${safeDescription}">
<meta property="og:type" content="website">
${canonicalUrl ? `<meta property="og:url" content="${escapeHtml(canonicalUrl)}">` : ""}
${ogImage ? `<meta property="og:image" content="${escapeHtml(ogImage)}">` : ""}
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="${escapeHtml(fullTitle)}">
<meta name="twitter:description" content="${safeDescription}">
${ogImage ? `<meta name="twitter:image" content="${escapeHtml(ogImage)}">` : ""}
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600;9..144,700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${versionedAsset("static/css/tokens.css")}">
<link rel="stylesheet" href="${versionedAsset("static/css/base.css")}">
${jsonLdHtml}
</head>
<body>
<!-- "İçeriğe geç" için ARB'de kaynak yok, brief'in "yeniden çevirme" kuralına
     uyarak Türkçe kalıyor (bkz. productDetail.js'teki aynı karar) — sadece
     klavye/ekran okuyucu kullanıcılarına görünen bir yardımcı bağlantı. -->
<a class="skip-link" href="#content">İçeriğe geç</a>
<header class="site-header">
  <a class="brand" href="/">${escapeHtml(siteName)}</a>
  <div class="site-nav-group">
    <nav class="site-nav" aria-label="${escapeHtml(t(locale, "home"))}">
      ${navHtml}
    </nav>
    <select id="lang-switcher" data-lang-switcher aria-label="${escapeHtml(t(locale, "languageTooltip"))}">${langOptionsHtml}</select>
  </div>
</header>
<main id="content">
${bodyHtml}
</main>
<footer class="site-footer">
  <div class="footer-grid">
    <div class="footer-col footer-brand-col">
      <p class="footer-brand">${escapeHtml(siteName)}</p>
      <p class="footer-desc">${escapeHtml(t(locale, "footerDesc"))}</p>
      <div class="footer-social">
        <a href="${business.whatsappUrl()}" rel="noopener" aria-label="${escapeHtml(t(locale, "whatsappCta"))}" title="WhatsApp">${ICON_WHATSAPP}</a>
        <a href="${escapeHtml(business.instagramUrl)}" target="_blank" rel="noopener" aria-label="Instagram" title="Instagram">${ICON_INSTAGRAM}</a>
        <a href="${escapeHtml(business.facebookUrl)}" target="_blank" rel="noopener" aria-label="Facebook" title="Facebook">${ICON_FACEBOOK}</a>
        <a href="tel:+${business.phoneNumberIntl}" aria-label="${escapeHtml(t(locale, "aboutContactPhoneLabel"))}" title="${escapeHtml(business.displayPhone)}">${ICON_PHONE}</a>
      </div>
    </div>
    <div class="footer-col">
      <p class="footer-col-title">${escapeHtml(t(locale, "explore"))}</p>
      <a href="/">${escapeHtml(t(locale, "home"))}</a>
      <a href="/sifir">${escapeHtml(t(locale, "newCollection"))}</a>
      <a href="/spot">${escapeHtml(t(locale, "spotProducts"))}</a>
      <a href="/hakkimizda">${escapeHtml(t(locale, "aboutUs"))}</a>
      <a href="/sss">${escapeHtml(t(locale, "sss"))}</a>
    </div>
    <div class="footer-col">
      <p class="footer-col-title">${escapeHtml(t(locale, "contact"))}</p>
      <a href="tel:+${business.phoneNumberIntl}" dir="ltr">${escapeHtml(business.displayPhone)}</a>
      <a href="${business.whatsappUrl()}" rel="noopener">${escapeHtml(t(locale, "whatsappCta"))}</a>
      <a href="${escapeHtml(business.googleMapsUrl)}" target="_blank" rel="noopener">${escapeHtml(business.address.line)}, ${escapeHtml(business.address.district)}/${escapeHtml(business.address.city)}</a>
      <p class="footer-hours">${escapeHtml(business.workingHours).replace(/\n/g, "<br>")}</p>
    </div>
  </div>
  <p class="footer-rights">${escapeHtml(t(locale, "allRightsReserved"))}</p>
</footer>
<a class="whatsapp-fab" href="${business.whatsappUrl()}" rel="noopener" aria-label="${escapeHtml(t(locale, "whatsappCta"))}">${ICON_WHATSAPP}</a>
<script src="${versionedAsset("static/js/main.js")}" defer></script>
${inlineData ? `<script>window.__DATA__ = ${JSON.stringify(inlineData)};</script>` : ""}
${extraScripts.map((s) => `<script src="${versionedAsset(s)}" type="module"></script>`).join("\n")}
</body>
</html>`;
}

module.exports = {renderLayout, escapeHtml};
