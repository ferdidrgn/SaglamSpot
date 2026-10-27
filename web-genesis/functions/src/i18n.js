/**
 * lib/l10n/app_*.arb dosyalarını (Flutter uygulamasının ZATEN sahip
 * olduğu 11 dildeki çevirileri) doğrudan okuyup web-genesis'te kullanır —
 * yeniden çeviri YOK, tek kaynak hâlâ o dosyalar. Sadece müşteri yüzü
 * (ana sayfa/kategori/arama/sepet/ürün detay) çevrilir; admin paneli
 * kasıtlı olarak Türkçe kalır (sadece esnaf kullanıyor).
 */
const fs = require("node:fs");
const path = require("node:path");

const SUPPORTED_LOCALES = ["tr", "en", "ar", "de", "el", "it", "ky", "ru", "uk", "uz", "zh"];
const DEFAULT_LOCALE = "tr";
const RTL_LOCALES = new Set(["ar"]);

const NATIVE_NAMES = {
  tr: "Türkçe",
  en: "English",
  ar: "العربية",
  de: "Deutsch",
  el: "Ελληνικά",
  it: "Italiano",
  ky: "Кыргызча",
  ru: "Русский",
  uk: "Українська",
  uz: "Oʻzbekcha",
  zh: "中文",
};

const translations = {};
for (const locale of SUPPORTED_LOCALES) {
  try {
    const filePath = path.join(__dirname, "../../../lib/l10n", `app_${locale}.arb`);
    const raw = fs.readFileSync(filePath, "utf8");
    const parsed = JSON.parse(raw);
    const clean = {};
    for (const [key, value] of Object.entries(parsed)) {
      if (!key.startsWith("@")) clean[key] = value;
    }
    translations[locale] = clean;
  } catch (_) {
    translations[locale] = {};
  }
}

/**
 * ICU "plural" biçimindeki ARB değerlerini (ör. productsFound) çözer.
 * Sadece bu projede gerçekten kullanılan basit `{var, plural, =0{...}
 * =1{...} other{...}}` kalıbını destekler — iç içe süslü parantezleri
 * (ör. `other{{count} Ürün}`) dengeli parantez taramasıyla doğru ayırır.
 */
function resolveIcuPlural(template, varName, count) {
  const prefix = `{${varName}, plural, `;
  if (!template.startsWith(prefix) || !template.endsWith("}")) return null;
  const body = template.slice(prefix.length, -1);

  const clauses = {};
  let i = 0;
  while (i < body.length) {
    const braceIdx = body.indexOf("{", i);
    if (braceIdx === -1) break;
    const selector = body.slice(i, braceIdx).trim();
    let depth = 1;
    let j = braceIdx + 1;
    while (j < body.length && depth > 0) {
      if (body[j] === "{") depth++;
      else if (body[j] === "}") depth--;
      j++;
    }
    clauses[selector] = body.slice(braceIdx + 1, j - 1);
    i = j;
  }

  const chosen = clauses["=" + count] !== undefined ? clauses["=" + count] : (clauses.other || "");
  return chosen.split(`{${varName}}`).join(String(count));
}

/** Anahtar hedef dilde yoksa Türkçeye, o da yoksa anahtarın kendisine düşer. */
function t(locale, key, params) {
  const dict = translations[locale] || translations[DEFAULT_LOCALE];
  let template = dict[key] ?? translations[DEFAULT_LOCALE][key] ?? key;

  if (params && typeof params.count === "number" && template.includes(", plural,")) {
    const pluralResolved = resolveIcuPlural(template, "count", params.count);
    if (pluralResolved !== null) template = pluralResolved;
  }

  if (params) {
    for (const [paramKey, value] of Object.entries(params)) {
      template = template.split(`{${paramKey}}`).join(String(value));
    }
  }

  return template;
}

function isSupportedLocale(locale) {
  return SUPPORTED_LOCALES.includes(locale);
}

function isRtl(locale) {
  return RTL_LOCALES.has(locale);
}

module.exports = {SUPPORTED_LOCALES, DEFAULT_LOCALE, NATIVE_NAMES, t, isSupportedLocale, isRtl};
