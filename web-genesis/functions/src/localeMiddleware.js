const {SUPPORTED_LOCALES, DEFAULT_LOCALE, isSupportedLocale} = require("./i18n");

const COOKIE_NAME = "lang";

function parseCookies(header) {
  const result = {};
  if (!header) return result;
  for (const part of header.split(";")) {
    const idx = part.indexOf("=");
    if (idx === -1) continue;
    const key = part.slice(0, idx).trim();
    const value = part.slice(idx + 1).trim();
    if (key) result[key] = decodeURIComponent(value);
  }
  return result;
}

/** `Accept-Language: tr-TR,tr;q=0.9,en;q=0.8` gibi bir başlıktan en iyi eşleşeni seçer. */
function bestAcceptLanguageMatch(header) {
  if (!header) return null;
  const candidates = header.split(",").map((part) => {
    const [tag, qPart] = part.trim().split(";q=");
    return {tag: (tag || "").trim().toLowerCase(), q: qPart ? Number(qPart) : 1};
  }).sort((a, b) => b.q - a.q);

  for (const {tag} of candidates) {
    const base = tag.split("-")[0];
    if (isSupportedLocale(base)) return base;
  }
  return null;
}

/**
 * Dil, Flutter uygulamasının web/index.html'deki NOTU ile AYNI prensiple
 * tek URL üzerinde, istemci tarafı (burada: çerez) tercihiyle belirlenir
 * — her dil için ayrı bir URL/rota yok (hreflang eklenmedi, aynı
 * gerekçeyle). `?lang=xx` ile gelen bir istek çerezi kurar ve aynı yola
 * (query olmadan) 302 ile yönlendirilir, böylece URL'ler temiz kalır.
 */
function localeMiddleware(req, res, next) {
  const requestedLang = req.query.lang;
  if (requestedLang && isSupportedLocale(requestedLang)) {
    res.cookie(COOKIE_NAME, requestedLang, {maxAge: 31536000000, path: "/"});
    const url = new URL(req.originalUrl, "http://localhost");
    url.searchParams.delete("lang");
    res.redirect(302, url.pathname + url.search);
    return;
  }

  const cookies = parseCookies(req.headers.cookie);
  const cookieLang = cookies[COOKIE_NAME];
  const locale = (cookieLang && isSupportedLocale(cookieLang))
    ? cookieLang
    : (bestAcceptLanguageMatch(req.headers["accept-language"]) || DEFAULT_LOCALE);

  req.locale = locale;
  next();
}

module.exports = {localeMiddleware, SUPPORTED_LOCALES};
