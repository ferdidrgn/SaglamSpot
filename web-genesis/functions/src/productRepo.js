const {FieldValue} = require("firebase-admin/firestore");
const {getDb} = require("./firebaseAdmin");
const {wearTierLabel} = require("./categories");
const {productPath} = require("./linkSigning");

function productCollection() {
  return getDb().collection("Product");
}

/**
 * `_createdAt`/`_updatedAt` Firestore'da "dd.MM.yyyy, HH:mm" biçiminde
 * SERBEST METİN olarak saklanıyor (bkz. lib/core/util/date_formatter.dart)
 * — bu yüzden Firestore orderBy ile doğru sıralanamaz (leksikografik sıra
 * gerçek tarih sırasıyla uyuşmuyor). Burada sayıya çevirip bellekte
 * sıralıyoruz; mağazanın envanteri (yüzlerce değil, onlarca/yüzlerce ürün)
 * için bu yeterince hızlı.
 */
function parseTrDateTime(value) {
  if (!value) return 0;
  const match = /^(\d{2})\.(\d{2})\.(\d{4}),\s*(\d{2}):(\d{2})$/.exec(value);
  if (!match) return 0;
  const [, day, month, year, hour, minute] = match;
  return Date.UTC(Number(year), Number(month) - 1, Number(day), Number(hour), Number(minute));
}

function formatPrice(value) {
  const n = Math.round(Number(value) || 0);
  return `${n.toLocaleString("tr-TR")} ₺`;
}

function primaryImage(data) {
  const studio = Array.isArray(data.studioImagesUrl) ? data.studioImagesUrl : [];
  const original = Array.isArray(data.imagesUrl) ? data.imagesUrl : [];
  return studio.find((u) => u) || original.find((u) => u) || null;
}

function toViewModel(doc) {
  const data = doc.data();
  const id = data._id || doc.id;
  const price = Number(data.price) || 0;
  const previousPrice = data.previousPrice != null ? Number(data.previousPrice) : null;

  return {
    id,
    name: data.name || "",
    desc: data.desc || "",
    category: data.category || "other",
    price,
    priceLabel: formatPrice(price),
    previousPrice,
    previousPriceLabel: previousPrice && previousPrice > price ? formatPrice(previousPrice) : null,
    image: primaryImage(data),
    images: [
      ...(Array.isArray(data.studioImagesUrl) ? data.studioImagesUrl : []).filter(Boolean),
      ...(Array.isArray(data.imagesUrl) ? data.imagesUrl : []).filter(Boolean),
    ],
    isSpotProduct: Boolean(data.isSpotProduct),
    isReserved: Boolean(data.isReserved),
    dimensions: data.dimensions || null,
    material: data.material || null,
    wearTier: data.wearTier || null,
    wearTierLabel: wearTierLabel(data.wearTier),
    createdAtSort: parseTrDateTime(data._createdAt),
    path: productPath(id, data.name || ""),
  };
}

async function listActiveProducts({isSpotProduct, limit = 200} = {}) {
  let query = productCollection().where("isSold", "==", false);
  if (typeof isSpotProduct === "boolean") {
    query = query.where("isSpotProduct", "==", isSpotProduct);
  }
  const snapshot = await query.limit(limit).get();
  return snapshot.docs
      .map(toViewModel)
      .sort((a, b) => b.createdAtSort - a.createdAtSort);
}

/**
 * Ürün ekleme sırasında `_id` alanı HER ZAMAN doküman ID'siyle aynı
 * değere set edilir (bkz. functions/index.js addProduct akışının Flutter
 * karşılığı, product_remote_data_source_impl.dart). Yine de brief'teki
 * uyarıya uyup `_id` ile doğrulama/arama yapıyoruz — doc.id ile bulunamazsa
 * `_id` alanına göre sorgu ile yedekli arıyoruz.
 */
async function getProductById(id) {
  const directDoc = await productCollection().doc(id).get();
  if (directDoc.exists) return toViewModel(directDoc);

  const snapshot = await productCollection().where("_id", "==", id).limit(1).get();
  if (!snapshot.empty) return toViewModel(snapshot.docs[0]);

  return null;
}

async function incrementWebViewCount(id) {
  await productCollection().doc(id).update({viewCountWeb: FieldValue.increment(1)}).catch(() => {});
}

module.exports = {listActiveProducts, getProductById, incrementWebViewCount, formatPrice};
