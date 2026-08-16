/**
 * Sağlam Spot Cloud Functions
 * ============================================================
 * "Stüdyo görsel" özelliği: admin panelinde bir ürün fotoğrafı
 * yüklendiğinde, bu fonksiyon remove.bg API'sine gönderip arka planı
 * kaldırılmış bir versiyon üretir ve Firebase Storage'a kaydeder.
 *
 * remove.bg API anahtarı BURADA, sunucu tarafında bir "secret" olarak
 * saklanır — istemci (Flutter) koduna asla gömülmez. Anahtarı ayarlamak
 * için (bir kereliğine, bu klasörde):
 *
 *     firebase functions:secrets:set REMOVEBG_API_KEY
 *
 * ve ardından deploy etmek için:
 *
 *     firebase deploy --only functions
 *
 * Aylık kota (remove.bg ücretsiz plan: 50 istek/ay) Firestore'daki
 * system_config/removeBgQuota dokümanında, transaction ile yarış
 * durumuna dayanıklı şekilde takip edilir. Kota dolduğunda fonksiyon
 * remove.bg'ye HİÇ istek atmadan { success: false, reason: 'quota_exceeded' }
 * döner — Flutter tarafı bunu görünce orijinal fotoğrafı olduğu gibi
 * yükler, sadece "stüdyo" versiyonunu atlar.
 */

const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getStorage} = require("firebase-admin/storage");
const {randomUUID} = require("crypto");

initializeApp();

const REMOVEBG_API_KEY = defineSecret("REMOVEBG_API_KEY");
const MONTHLY_LIMIT = 50;
const QUOTA_DOC_PATH = "system_config/removeBgQuota";

function currentMonthKey() {
  const now = new Date();
  return `${now.getUTCFullYear()}-${String(now.getUTCMonth() + 1).padStart(2, "0")}`;
}

/**
 * Kotadan bir hak "rezerve eder" (transaction içinde okuyup artırır).
 * Ay değiştiyse sayaç otomatik sıfırlanır. Rezervasyon başarısızsa
 * (kota dolu) false döner — remove.bg'ye hiç istek gitmez.
 */
async function reserveQuotaSlot(db) {
  const quotaRef = db.doc(QUOTA_DOC_PATH);
  const month = currentMonthKey();

  return db.runTransaction(async (tx) => {
    const snap = await tx.get(quotaRef);
    const data = snap.exists ? snap.data() : {};
    const sameMonth = data.month === month;
    const count = sameMonth ? (data.count || 0) : 0;

    if (count >= MONTHLY_LIMIT) return false;

    tx.set(quotaRef, {month, count: count + 1, updatedAt: FieldValue.serverTimestamp()}, {merge: true});
    return true;
  });
}

/** Başarısız/hatalı bir denemede rezerve edilen hakkı geri iade eder. */
async function releaseQuotaSlot(db) {
  const quotaRef = db.doc(QUOTA_DOC_PATH);
  await quotaRef.set({count: FieldValue.increment(-1)}, {merge: true}).catch(() => {});
}

exports.removeProductBackground = onCall(
    {secrets: [REMOVEBG_API_KEY], timeoutSeconds: 60, memory: "512MiB"},
    async (request) => {
      const imageUrl = request.data && request.data.imageUrl;
      if (!imageUrl || typeof imageUrl !== "string") {
        throw new HttpsError("invalid-argument", "imageUrl gerekli.");
      }

      const db = getFirestore();
      const reserved = await reserveQuotaSlot(db);
      if (!reserved) {
        return {success: false, reason: "quota_exceeded"};
      }

      try {
        const removeBgResponse = await fetch("https://api.remove.bg/v1.0/removebg", {
          method: "POST",
          headers: {
            "X-Api-Key": REMOVEBG_API_KEY.value(),
            "Content-Type": "application/json",
          },
          body: JSON.stringify({image_url: imageUrl, size: "auto", format: "png"}),
        });

        if (!removeBgResponse.ok) {
          await releaseQuotaSlot(db);
          const errText = await removeBgResponse.text();
          throw new HttpsError("internal", `remove.bg hatası (${removeBgResponse.status}): ${errText}`);
        }

        const arrayBuffer = await removeBgResponse.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);

        const fileName = `studio_images/${Date.now()}_${randomUUID()}.png`;
        const bucket = getStorage().bucket();
        const file = bucket.file(fileName);
        const downloadToken = randomUUID();

        await file.save(buffer, {
          metadata: {
            contentType: "image/png",
            metadata: {firebaseStorageDownloadTokens: downloadToken},
          },
        });

        const encodedPath = encodeURIComponent(fileName);
        const studioImageUrl =
          `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodedPath}?alt=media&token=${downloadToken}`;

        return {success: true, studioImageUrl};
      } catch (err) {
        await releaseQuotaSlot(db);
        if (err instanceof HttpsError) throw err;
        throw new HttpsError("internal", `Beklenmeyen hata: ${err.message}`);
      }
    },
);
