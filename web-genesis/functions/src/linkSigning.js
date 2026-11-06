/**
 * functions/index.js'teki sitemap() fonksiyonunun signProductId/toSlug'ı
 * ve lib/core/services/deeplink/deeplink_service.dart +
 * lib/core/common/extentions/reg_exp_extentions.dart ile AYNI algoritma —
 * DEĞİŞTİRME. Buradaki bir karakter farkı bile mobil uygulamadan paylaşılan
 * linklerin (veya bu sitenin kendi ürettiği linklerin) doğrulamasını
 * bozar.
 */
const {createHmac} = require("node:crypto");

const HMAC_SECRET = "SAGLAM_SPOT_CYBER_SECURITY_KEY_2026";

/**
 * lib/core/services/deeplink/deeplink_service.dart'taki `_domain` ile
 * AYNI — WhatsApp mesajlarına eklenen linkler BİLEREK bu (şu an canlı
 * olan Flutter) adrese işaret ediyor, web-genesis'in henüz yayında
 * olmayan kendi adresine değil. web-genesis canlıya alınıp bu domain'i
 * devraldığında burası da güncellenmeli.
 */
const SHARE_DOMAIN = "https://saglamspotcu.web.app";

function signProductId(id) {
  return createHmac("sha256", HMAC_SECRET).update(id, "utf8").digest("hex");
}

function toSlug(name) {
  return (name || "")
      .toLowerCase()
      .replace(/ /g, "-")
      .replace(/ş/g, "s")
      .replace(/ı/g, "i")
      .replace(/ç/g, "c")
      .replace(/ö/g, "o")
      .replace(/ü/g, "u")
      .replace(/ğ/g, "g")
      .replace(/[^a-z0-9-]/g, "");
}

function productPath(id, name) {
  const slug = toSlug(name);
  const sig = signProductId(id);
  return `/product/${encodeURIComponent(`${slug}-${id}`)}?sig=${sig}`;
}

/** Aynı ürün, WhatsApp mesajlarında kullanılan MUTLAK (SHARE_DOMAIN'li) link. */
function productShareUrl(id, name) {
  const slug = toSlug(name);
  const sig = signProductId(id);
  return `${SHARE_DOMAIN}/product/${encodeURIComponent(`${slug}-${id}`)}?sig=${sig}`;
}

// lib/core/services/deeplink/deeplink_service.dart'taki encodeCartItemsParam
// ile AYNI format: "id1:adet1,id2:adet2".
function encodeCartItemsParam(items) {
  return items.map((i) => `${i.id}:${i.quantity}`).join(",");
}

function cartShareUrl(items) {
  const itemsParam = encodeCartItemsParam(items);
  const sig = signProductId(itemsParam);
  return `${SHARE_DOMAIN}/cart?items=${encodeURIComponent(itemsParam)}&sig=${sig}`;
}

module.exports = {signProductId, toSlug, productPath, productShareUrl, encodeCartItemsParam, cartShareUrl, SHARE_DOMAIN};
