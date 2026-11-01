/**
 * Firebase Hosting, dinamik rotaları bir Cloud Function'a REWRITE eder —
 * istek fonksiyona kendi iç adresinden (ör. 127.0.0.1:5001, ya da
 * production'da cloudfunctions.net) gelir, TARAYICININ gerçekte ziyaret
 * ettiği adresten (asıl hosting domaini) değil. Gerçek dış adresi almak
 * için Hosting'in eklediği X-Forwarded-* başlıklarına bakmak gerekir —
 * yoksa sitemap/canonical/OG URL'leri yanlışlıkla iç adrese işaret eder.
 */
function getBaseUrl(req) {
  const forwardedHost = req.headers["x-forwarded-host"];
  const host = forwardedHost || req.get("host");
  const forwardedProto = req.headers["x-forwarded-proto"];
  const protocol = (forwardedProto ? forwardedProto.split(",")[0].trim() : null) || req.protocol;
  return `${protocol}://${host}`;
}

module.exports = {getBaseUrl};
