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

module.exports = {signProductId, toSlug, productPath};
