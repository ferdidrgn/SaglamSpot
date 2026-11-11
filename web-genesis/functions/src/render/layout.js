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
 *
 * ÖNEMLİ: Deploy edilen Cloud Functions paketi SADECE "web-genesis/
 * functions" klasörünü içerir (bkz. firebase.json), "web-genesis/public"
 * canlıda bu paketin içinde DEĞİL — aşağıdaki doğrudan dosya okuma
 * CANLIDA HER ZAMAN BAŞARISIZ oluyor ve sessizce "v=0" sabit değerine
 * düşüyordu. Sonuç: her deploy'dan sonra bile CSS/JS URL'si HİÇ
 * değişmiyordu, `immutable` önbellek başlığıyla birlikte ziyaretçiler
 * SONSUZA KADAR eski CSS/JS görmeye devam ediyordu (gerçek bir kullanıcı
 * geri bildirimiyle yakalandı: yeni "yukarı çık" animasyonu hiç
 * görünmüyordu). Artık önce generate-asset-manifest.js'in (predeploy
 * kancası) deploy ZAMANINDA ürettiği assetManifest.json okunuyor — o
 * dosya "web-genesis/functions/" İÇİNDE olduğu için deploy paketine
 * giriyor. Manifest yoksa (yerel emülatör gibi repo'nun tamamı diskte
 * olan ortamlar) eski doğrudan-okuma yöntemine düşülüyor.
 */
const _assetHashCache = {};
let _assetManifest = null;
function loadAssetManifest() {
  if (_assetManifest) return _assetManifest;
  try {
    _assetManifest = JSON.parse(fs.readFileSync(path.join(__dirname, "../../assetManifest.json"), "utf8"));
  } catch (_) {
    _assetManifest = {};
  }
  return _assetManifest;
}
function versionedAsset(relativePath) {
  if (!_assetHashCache[relativePath]) {
    const manifest = loadAssetManifest();
    if (manifest[relativePath]) {
      _assetHashCache[relativePath] = manifest[relativePath];
    } else {
      try {
        const fullPath = path.join(__dirname, "../../../public", relativePath);
        const content = fs.readFileSync(fullPath);
        _assetHashCache[relativePath] = crypto.createHash("sha256").update(content).digest("hex").slice(0, 10);
      } catch (_) {
        _assetHashCache[relativePath] = "0";
      }
    }
  }
  return `/${relativePath}?v=${_assetHashCache[relativePath]}`;
}

// Küçük, tek renkli (currentColor) SVG ikonlar — harici bir ikon fontu/paket
// eklemeden footer sosyal bağlantıları için. Yalnızca çizgi/şekil, metin yok.
const ICON_WHATSAPP = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M12.04 2c-5.46 0-9.9 4.44-9.9 9.9 0 1.75.46 3.45 1.32 4.95L2 22l5.25-1.38a9.9 9.9 0 0 0 4.79 1.22h.01c5.46 0 9.9-4.44 9.9-9.9S17.5 2 12.04 2zm5.8 14.17c-.24.68-1.4 1.3-1.93 1.37-.49.07-1.1.1-1.78-.11-.41-.13-.94-.3-1.62-.6-2.84-1.23-4.7-4.1-4.84-4.29-.14-.19-1.15-1.53-1.15-2.92s.72-2.07.98-2.35c.24-.26.52-.33.7-.33h.5c.16 0 .37-.02.58.44.24.56.8 1.93.87 2.07.07.14.12.3.02.49-.1.19-.15.3-.3.47-.14.17-.3.37-.43.5-.14.14-.29.29-.13.57.17.28.74 1.22 1.6 1.97 1.1.98 2.03 1.28 2.31 1.43.28.14.44.12.6-.07.17-.19.72-.84.91-1.13.19-.28.38-.23.63-.14.26.1 1.64.77 1.92.91.28.14.47.21.54.33.07.12.07.68-.17 1.36z\"/></svg>";
const ICON_FACEBOOK = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"currentColor\" aria-hidden=\"true\"><path d=\"M14 21v-7h2.4l.4-3H14V9.2c0-.9.25-1.5 1.6-1.5H17V5.1C16.7 5 15.8 5 14.8 5c-2.2 0-3.7 1.3-3.7 3.9V11H8.7v3H11v7h3z\"/></svg>";
// Dil seçicinin yanındaki küp — ÖNCEDEN çıplak bir <select> + "Türkçe"
// metniydi, dil değiştirmenin bir seçenek olduğu hiç belli değildi
// (kullanıcı geri bildirimi). Diğer ikonlarla AYNI tek-renk çizgi dili:
// meridyen çizgili klasik "dünya/küre" glifi.
const ICON_GLOBE = "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.7\" aria-hidden=\"true\"><circle cx=\"12\" cy=\"12\" r=\"9\"/><path d=\"M3 12h18M12 3c2.5 2.7 4 6 4 9s-1.5 6.3-4 9c-2.5-2.7-4-6-4-9s1.5-6.3 4-9z\"/></svg>";
// Mobilde menü aç/kapa düğmesi — önceden mobilde nav HİÇ daralmıyordu,
// 8 bağlantı + dil seçici kendi genişliklerine göre satır satır
// sarıyordu (kullanıcı geri bildirimi: "en üst kısım çok alan kaplıyor,
// sayfanın %30'u kaplanarak scroll oluyor"). Artık ≤760px'te nav/dil
// seçici bu düğmeyle açılan bir dropdown panele taşınıyor (bkz. base.css
// .nav-toggle/.site-nav-group notu, main.js wireNavToggle()).
const ICON_MENU = "<svg width=\"20\" height=\"20\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" aria-hidden=\"true\"><path d=\"M4 7h16M4 12h16M4 17h16\"/></svg>";
const ICON_PHONE = "<svg width=\"18\" height=\"18\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\" aria-hidden=\"true\"><path d=\"M6.5 4h3l1.5 4-2 1.5a12 12 0 0 0 5.5 5.5l1.5-2 4 1.5v3a2 2 0 0 1-2.2 2A17 17 0 0 1 4.5 6.2 2 2 0 0 1 6.5 4z\"/></svg>";
// "Yukarı çık" düğmesi — gece lambası ipi metaforu, TEK bir SVG içinde:
// tavan bağlantısı + şişkin/tatlı yuvarlak bir abajur (sabit, sıcak
// parıltılı) + altında sarkan ip/püskül grubu (hover'da hafif sallanır,
// tıklanınca gerçek bir ip gibi aşağı "çekilip" geri döner, SONRA sayfa
// yukarı kayar). Önceki dört deneme ("boncuklu ip + çıngırak abajur",
// "ahşap meşe palamudu topuz", "aşırı sade daire", "ince/köşeli abajur")
// kullanıcıya hep kötü geldi — teknik, kullanıcının beğendiği
// https://tiyatrol.web.app sitesindeki perde/ip düğmesinden (hover'da
// sallanma + tıklamada translateY tug keyframe'i, transform-box:view-box
// ile SVG içi grup döndürme) birebir alınıp bizim "obez/tatlı" yuvarlak
// gece lambası temamıza uyarlandı.
const SCROLLTOP_LAMP_SVG = `<svg viewBox="0 0 64 98" aria-hidden="true">
  <rect x="27" y="0" width="10" height="5" rx="2.5" class="lamp-mount"></rect>
  <path class="lamp-mount-rod" d="M32 5v6"></path>
  <circle class="lamp-shade" cx="32" cy="29" r="21"></circle>
  <ellipse class="lamp-glow" cx="32" cy="44" rx="12" ry="5"></ellipse>
  <g class="cord-ip">
    <path class="cord-line" d="M32 47v15"></path>
    <rect x="28.5" y="61" width="7" height="6" rx="2" class="cord-cap"></rect>
    <path class="cord-tassel" d="M26 67h12l3 14H23Z"></path>
    <path class="cord-fringe" d="M27 73v8M32 73v8M37 73v8"></path>
  </g>
</svg>`;

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
    {href: "/favoriler", label: t(locale, "navFavorites"), fav: true},
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
    const badge = item.cart
      ? " <span id=\"cart-badge\" class=\"cart-badge\" hidden>0</span>"
      : (item.fav ? " <span id=\"fav-badge\" class=\"cart-badge\" hidden>0</span>" : "");
    return `<a class="nav-link" href="${escapeHtml(item.href)}"${active}${aria}>${item.label}${badge}</a>`;
  }).join("\n");

  const langOptionsHtml = SUPPORTED_LOCALES.map((loc) =>
    `<option value="${loc}" ${loc === locale ? "selected" : ""}>${escapeHtml(NATIVE_NAMES[loc])}</option>`).join("");

  // JSON.stringify "</script" dizisini kaçırmaz — ürün adı/açıklaması
  // (jsonLd.name/description, admin tarafından girilir) böyle bir alt dize
  // içerirse script etiketini erken kapatıp ardına rastgele HTML/JS enjekte
  // edebilir (bu GERÇEK ziyaretçilere giden canlı sayfa, sadece bot'lara
  // değil). "<" karakterini unicode kaçışıyla değiştirmek JSON'u bozmadan
  // bunu engeller.
  const siteUrl = baseUrl || "https://saglamspotcu.web.app";
  const siteJsonLd = {
    "@context": "https://schema.org",
    "@type": "WebSite",
    "@id": `${siteUrl}/#website`,
    "name": siteName,
    "url": siteUrl,
    "potentialAction": {
      "@type": "SearchAction",
      "target": `${siteUrl}/arama?q={search_term_string}`,
      "query-input": "required name=search_term_string",
    },
  };
  const structuredData = jsonLd ? [siteJsonLd, jsonLd] : siteJsonLd;
  const jsonLdHtml = `<script type="application/ld+json">${JSON.stringify(structuredData).replace(/</g, "\\u003c")}</script>`;
  const dir = isRtl(locale) ? "rtl" : "ltr";

  const pageData = inlineData ? {
    ...inlineData,
    // reCAPTCHA Enterprise site key is public by design. The corresponding
    // Firebase registration remains in the console; no secret is rendered.
    recaptchaEnterpriseSiteKey: process.env.RECAPTCHA_ENTERPRISE_SITE_KEY || "",
  } : null;

  return `<!DOCTYPE html>
<html lang="${locale}" dir="${dir}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- ================= GOOGLE SEARCH CONSOLE / YANDEX DOĞRULAMA =================
     Eskiden web/index.html'deki (Flutter web derlemesi) GERÇEK doğrulama
     kodları — saglamspotcu.web.app artık web-genesis'i sunduğu için bu
     etiketler olmadan Search Console/Yandex Webmaster'daki site
     sahipliği doğrulaması KOPARDI. Bing'in kendi kodu Flutter tarafında
     da hiç gerçek değildi (yer tutucu metin), o yüzden taşınmadı. -->
<meta name="google-site-verification" content="auwiqgjhUHUDIchgyzDfclFcgXn-B7MaMIl3fNXWphE">
<meta name="yandex-verification" content="94ec8563034a9a5f">
<meta name="application-name" content="Sağlam Spot">
<meta name="keywords" content="sağlam spot, spot mobilya, ikinci el mobilya, sıfır mobilya, İçerenköy mobilya">
<!-- ================= GOOGLE ANALYTICS ================= -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-3Z4LKNJ3N7"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag() { dataLayer.push(arguments); }
  gtag("js", new Date());
  gtag("config", "G-3Z4LKNJ3N7");
</script>
<!-- ================= GOOGLE ADSENSE =================
     Eskiden sadece web/index.html'de (Flutter web) vardı — web-genesis'e
     geçişte taşınmamıştı, yani canlıda AdSense HİÇ yüklenmiyordu. Asıl
     reklam alanları (<ins class="adsbygoogle">) henüz bu sitede YOK;
     bu script tek başına hesabın siteyi doğrulamasını ve "Otomatik
     reklamlar"ı (AdSense panelinden açılırsa) mümkün kılar. İleride
     belirli bir sayfaya elle bir reklam birimi eklenirse pushAdsenseAd()
     AYNI webdriver/bot korumasıyla (Playwright/Selenium görsel kontrolde
     gerçek reklamlara istek gitmesin diye, bkz. saglamspot-ui SKILL.md
     §5) o birimi doldurur. -->
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-5779807348211992" crossorigin="anonymous"></script>
<script>
  function pushAdsenseAd() {
    if (navigator.webdriver) {
      console.warn("AdSense: otomasyon tarayıcısı tespit edildi, reklam yüklenmedi.");
      return;
    }
    try {
      (window.adsbygoogle = window.adsbygoogle || []).push({});
    } catch (e) {
      console.warn("AdSense push hatası:", e);
    }
  }
</script>
<script>
// Firebase Hosting, Cloud Functions'a rewrite ederken Cookie başlığını
// İLETMİYOR (bkz. localeMiddleware.js'teki uzun not) — bu yüzden dil
// seçimi çerezle KALICI OLAMIYOR. Burada (parse'ın EN BAŞINDA, henüz
// hiçbir şey boyanmadan) localStorage'daki seçimi şu an render edilmiş
// dille karşılaştırıp farklıysa ?lang= ekleyip SESSİZCE yönlendiriyoruz
// — çoğu zaman görünür bir "yanlış dil" karesi olmadan. ?lang= zaten
// varsa (kullanıcı az önce seçiciden değiştirdi ya da bu zaten o
// yönlendirmenin kendisi) TEKRAR yönlendirme YAPMIYORUZ (sonsuz döngü).
(function () {
  try {
    var saved = localStorage.getItem("saglamspot_lang");
    var current = document.documentElement.lang;
    if (saved && saved !== current) {
      var url = new URL(window.location.href);
      if (url.searchParams.get("lang") !== saved) {
        url.searchParams.set("lang", saved);
        window.location.replace(url.pathname + url.search);
      }
    }
  } catch (_) {
    // localStorage engellenmiş olabilir (gizli pencere vb.) — sessizce yok say.
  }
})();
</script>
<script>
// saglamspotcu.web.app ESKİDEN bir Flutter PWA'sı sunuyordu ve
// (flutter_service_worker.js) bir Service Worker kaydediyordu. SW'ler
// normal tarayıcı önbelleğinin TAMAMEN DIŞINDA çalışır — bazı stratejiler
// sayfayı sunucuya hiç sormadan eski/önbellekteki HTML'i gösterir. Site
// artık web-genesis'i sunuyor; bu eski SW hâlâ kayıtlıysa butonlar/
// animasyonlar "çalışmıyormuş" gibi görünür (gerçek kullanıcı geri
// bildirimiyle yakalandı). Her sayfa yüklemesinde böyle bir kayıt
// bulunursa sessizce kaldırılır (kayıt yoksa bu no-op, zararsız).
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.getRegistrations().then(function (regs) {
    regs.forEach(function (reg) { reg.unregister(); });
  }).catch(function () {});
}
if (window.caches && caches.keys) {
  caches.keys().then(function (keys) {
    keys.forEach(function (key) { caches.delete(key); });
  }).catch(function () {});
}
</script>
<title>${escapeHtml(fullTitle)}</title>
<meta name="description" content="${safeDescription}">
<meta name="robots" content="${escapeHtml(robots)}">
${canonicalUrl ? `<link rel="canonical" href="${escapeHtml(canonicalUrl)}">` : ""}
<link rel="manifest" href="/manifest.json">
<link rel="icon" type="image/png" href="${versionedAsset("icons/Icon-192.png")}">
<link rel="apple-touch-icon" href="${versionedAsset("icons/Icon-192.png")}">
<meta property="og:site_name" content="${escapeHtml(siteName)}">
<meta property="og:title" content="${escapeHtml(fullTitle)}">
<meta property="og:description" content="${safeDescription}">
<meta property="og:type" content="website">
${canonicalUrl ? `<meta property="og:url" content="${escapeHtml(canonicalUrl)}">` : ""}
${ogImage ? `<meta property="og:image" content="${escapeHtml(ogImage)}">` : ""}
${ogImage ? `<meta property="og:image:width" content="512"><meta property="og:image:height" content="512">` : ""}
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="${escapeHtml(fullTitle)}">
<meta name="twitter:description" content="${safeDescription}">
${ogImage ? `<meta name="twitter:image" content="${escapeHtml(ogImage)}">` : ""}
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
  <button type="button" class="nav-toggle" data-nav-toggle aria-expanded="false" aria-controls="site-nav-panel" aria-label="Menü">${ICON_MENU}</button>
  <div class="site-nav-group" id="site-nav-panel" data-nav-panel>
    <nav class="site-nav" aria-label="${escapeHtml(t(locale, "home"))}">
      ${navHtml}
    </nav>
    <div class="lang-switcher-wrap">
      ${ICON_GLOBE}
      <select id="lang-switcher" data-lang-switcher aria-label="${escapeHtml(t(locale, "languageTooltip"))}">${langOptionsHtml}</select>
    </div>
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
        <a href="${business.whatsappUrl(undefined, locale)}" rel="noopener" aria-label="${escapeHtml(t(locale, "whatsappCta"))}" title="WhatsApp">${ICON_WHATSAPP}</a>
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
      <a href="${business.whatsappUrl(undefined, locale)}" rel="noopener">${escapeHtml(t(locale, "whatsappCta"))}</a>
      <a href="${escapeHtml(business.googleMapsUrl)}" target="_blank" rel="noopener">${escapeHtml(business.address.line)}, ${escapeHtml(business.address.district)}/${escapeHtml(business.address.city)}</a>
      <p class="footer-hours">${escapeHtml(business.workingHours).replace(/\n/g, "<br>")}</p>
    </div>
  </div>
  <p class="footer-rights">${escapeHtml(t(locale, "allRightsReserved"))} · <a href="/gizlilik">Gizlilik Politikası</a></p>
</footer>
<a class="whatsapp-fab" href="${business.whatsappUrl(undefined, locale)}" rel="noopener" aria-label="${escapeHtml(t(locale, "whatsappCta"))}">${ICON_WHATSAPP}</a>
<button type="button" class="scrolltop-cord" data-scroll-top aria-label="Yukarı çık" title="Işığı çek, yukarı çık">${SCROLLTOP_LAMP_SVG}</button>
<script src="${versionedAsset("static/js/main.js")}" defer></script>
${pageData ? `<script>window.__DATA__ = ${JSON.stringify(pageData).replace(/</g, "\\u003c")};</script>` : ""}
${extraScripts.map((s) => `<script src="${versionedAsset(s)}" type="module"></script>`).join("\n")}
</body>
</html>`;
}

module.exports = {renderLayout, escapeHtml};
