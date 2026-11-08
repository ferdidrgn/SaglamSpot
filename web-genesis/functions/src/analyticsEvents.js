const {FieldValue} = require("firebase-admin/firestore");
const {getDb} = require("./firebaseAdmin");

/**
 * `analytics_events` koleksiyonuna sunucu tarafında (Admin SDK ile,
 * firestore.rules'tan muaf) tek bir olay yazar — lib/core/services/
 * analytics_event_logger.dart'ın (Flutter istemcisi) SUNUCU KARŞILIĞI.
 * Admin panelindeki tarih filtreli istatistikler BUNDAN okur (bkz.
 * admin-dashboard.js > fetchEngagementEvents). Ziyaretçi kimliği
 * TUTULMAZ — sadece olay türü + ürün/kategori + platform + zaman
 * (viewCountWeb/Mobile sayaçlarıyla AYNI felsefe).
 *
 * Admin SDK kuralları atladığı için burada `type: 'sale'` dahil HER tür
 * yazılabilir — çağıran kod (productDetail.js > view, app.js > tıklama
 * route'u) hangi türü yazacağını kendi belirler.
 */
async function logAnalyticsEvent({type, productId, category, platform, price}) {
  try {
    const doc = {
      type,
      productId,
      category: category || "other",
      platform,
      createdAt: FieldValue.serverTimestamp(),
    };
    if (typeof price === "number") doc.price = price;
    await getDb().collection("analytics_events").add(doc);
  } catch (err) {
    // İstatistik yazımı ASLA sayfa açılışını/isteği engellemez.
    console.error("logAnalyticsEvent başarısız:", err);
  }
}

module.exports = {logAnalyticsEvent};
