/**
 * Sağlam Spot Cloud Functions
 * ============================================================
 * "Stüdyo görsel" özelliği: admin panelinde bir fotoğraf SEÇİLİR
 * SEÇİLMEZ (henüz Storage'a yüklenmeden, base64 olarak) bu fonksiyona
 * gönderilir; fonksiyon remove.bg API'sine gönderip arka planı
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

const {onCall, onRequest, HttpsError} = require("firebase-functions/v2/https");
const {onDocumentDeleted, onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {defineSecret} = require("firebase-functions/params");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getStorage} = require("firebase-admin/storage");
const {getMessaging} = require("firebase-admin/messaging");
const {randomUUID, createHmac} = require("crypto");

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
      // Admin fotoğraf seçer seçmez, henüz Storage'a hiç yüklenmeden
      // ÇIPLAK BAYT olarak gönderiliyor (base64) — bu sayede önce
      // Storage'a yükleyip sonra URL üretmek gibi ekstra bir adıma/gecikmeye
      // gerek kalmıyor, seçimden hemen sonra önizleme üretilebiliyor.
      const imageBase64 = request.data && request.data.imageBase64;
      if (!imageBase64 || typeof imageBase64 !== "string") {
        throw new HttpsError("invalid-argument", "imageBase64 gerekli.");
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
          body: JSON.stringify({image_file_b64: imageBase64, size: "auto", format: "png"}),
        });

        if (!removeBgResponse.ok) {
          await releaseQuotaSlot(db);
          const errText = await removeBgResponse.text();
          throw new HttpsError("internal", `remove.bg hatası (${removeBgResponse.status}): ${errText}`);
        }

        const arrayBuffer = await removeBgResponse.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);

        // Dosya adı bilinçli olarak "studio-" ile başlıyor — Flutter tarafı
        // bu görseli artık ayrı bir alanda değil, doğrudan ürünün normal
        // imagesUrl dizisine ekliyor; adın kendisi Storage konsolunda hangi
        // dosyaların remove.bg çıktısı olduğunu ayırt etmenin tek yolu.
        const fileName = `studio_images/studio-${Date.now()}_${randomUUID()}.png`;
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

/**
 * Bir Firebase Storage indirme URL'inden (`.../o/<encodedPath>?alt=media&...`)
 * dosyanın bucket içindeki gerçek yolunu çıkarır. Ayrıştırılamazsa null döner.
 */
function storagePathFromUrl(url) {
  const match = typeof url === "string" && url.match(/\/o\/([^?]+)/);
  if (!match) return null;
  try {
    return decodeURIComponent(match[1]);
  } catch (err) {
    return null;
  }
}

/**
 * Bir ürün dokümanı silindiğinde, Storage'daki tüm görsellerini (orijinal +
 * stüdyo) sunucu tarafında (Admin SDK ile) temizler. Bilinçli olarak
 * istemci tarafında DEĞİL burada yapılıyor: Admin SDK, Storage Security
 * Rules'tan tamamen muaf — stüdyo görselleri zaten yalnızca bu dosyadaki
 * Admin SDK ile yazıldığı için (bkz. removeProductBackground), istemci
 * tarafında onlara "delete" izni veren bir kural hiç tanımlanmamıştı; bu
 * yüzden Flutter'dan yapılan silme denemeleri sessizce yetkisiz kalıp
 * hiçbir şey silmiyordu.
 */
exports.onProductDeleted = onDocumentDeleted("Product/{productId}", async (event) => {
  const data = event.data && event.data.data();
  if (!data) return;

  const urls = [
    ...(Array.isArray(data.imagesUrl) ? data.imagesUrl : []),
    ...(Array.isArray(data.studioImagesUrl) ? data.studioImagesUrl : []),
  ].filter((u) => typeof u === "string" && u.length > 0);

  if (urls.length === 0) return;

  const bucket = getStorage().bucket();
  await Promise.all(urls.map(async (url) => {
    const path = storagePathFromUrl(url);
    if (!path) return;
    await bucket.file(path).delete().catch(() => {});
  }));
});

/**
 * GÜNLÜK ÜRÜN ÖZETİ BİLDİRİMİ — her ürün eklendiğinde ayrı ayrı bildirim
 * GÖNDERMEZ (gece yarısı veya art arda çok sayıda ürün eklenirse
 * kullanıcıyı bildirim yağmuruna tutar, rahatsız eder ve bildirimleri
 * kapatmasına yol açar). Bunun yerine her gün SABİT bir saatte (11:00,
 * İstanbul saati) bir kez çalışır: son özetten bu yana kaç yeni ürün
 * eklendiğine bakar, varsa TEK bir özet bildirimi gönderir
 * ("3 yeni ürün eklendi"), yoksa hiçbir şey göndermez.
 *
 * Ürün dokümanlarındaki `_createdAt` alanı "dd.MM.yyyy, HH:mm" formatında
 * bir STRING olduğu için Firestore'da tarih aralığı sorgusuna uygun değil
 * (leksikografik sıralama gerçek tarih sırasıyla eşleşmiyor). Bunun yerine
 * Firestore'un her dokümana otomatik atadığı, her zaman doğru sıralanan
 * gerçek zaman damgası olan `doc.createTime` kullanılıyor.
 */
exports.dailyProductDigest = onSchedule(
    {schedule: "0 11 * * *", timeZone: "Europe/Istanbul"},
    async () => {
      const db = getFirestore();
      const configRef = db.doc("system_config/notificationDigest");
      const configSnap = await configRef.get();
      const lastSentAt = configSnap.exists && configSnap.data().lastSentAt ?
        configSnap.data().lastSentAt.toDate() :
        new Date(Date.now() - 24 * 60 * 60 * 1000); // ilk çalıştırmada: son 24 saat

      const snap = await db.collection("Product")
          .where("isSold", "==", false)
          .get();

      const newCount = snap.docs.filter((d) =>
        d.createTime && d.createTime.toDate() > lastSentAt).length;

      // Bir sonraki pencere için işaretçiyi HER ZAMAN güncelle — 0 yeni
      // ürün olsa bile, aksi halde eski ürünler her gün "yeni" sayılmaya
      // devam eder.
      await configRef.set(
          {lastSentAt: FieldValue.serverTimestamp()}, {merge: true});

      if (newCount === 0) return;

      const title = "Yeni Ürünler Eklendi! 🛋️";
      const body = newCount === 1 ?
        "Mağazaya 1 yeni ürün eklendi, göz atmak ister misiniz?" :
        `Mağazaya ${newCount} yeni ürün eklendi, göz atmak ister misiniz?`;

      try {
        await getMessaging().send({
          topic: "all_users",
          notification: {title, body},
          data: {type: "new_products_digest", count: String(newCount)},
        });
      } catch (err) {
        console.error("dailyProductDigest: FCM gönderimi başarısız.", err);
      }
    },
);

/**
 * FİYAT DÜŞÜŞÜ BİLDİRİMİ — bir ürünün fiyatı gerçekten DÜŞTÜĞÜNDE
 * (satıldı olarak işaretlenmemişse), o ürünü favorileyen cihazlara
 * kişiye özel bir bildirim gönderir. Günlük özetten farklı olarak
 * ANINDA gönderilir — bu, spam değil kişiye özel/nadir bir olay (yalnızca
 * ürünü bilerek favorileyen kişiye, yalnızca fiyat gerçekten düşünce).
 *
 * Hangi cihazın hangi ürünleri favorilediği `notification_subscriptions/
 * {fcmToken}` dokümanında `productIds` dizisi olarak tutulur — bkz.
 * Flutter tarafı: lib/core/services/favorite_notification_sync.dart.
 */
exports.notifyPriceDrop = onDocumentUpdated("Product/{productId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (!before || !after || after.isSold) return;

  const oldPrice = typeof before.price === "number" ? before.price : null;
  const newPrice = typeof after.price === "number" ? after.price : null;
  if (oldPrice === null || newPrice === null || newPrice >= oldPrice) return;

  const productId = event.params.productId;
  const db = getFirestore();

  const snap = await db.collection("notification_subscriptions")
      .where("productIds", "array-contains", productId)
      .get();
  if (snap.empty) return;

  const tokens = snap.docs.map((d) => d.id);
  const title = "Favorin Ucuzladı! 🎉";
  const body = `${after.name || "Favori ürünün"} artık ₺${Math.round(newPrice)}` +
      ` — az önce ₺${Math.round(oldPrice)} idi.`;

  // FCM tek istekte en fazla 500 token kabul eder — mağaza ölçeğinde asla
  // aşılmaz ama yine de güvenli olsun diye parçalara bölünüyor.
  const chunks = [];
  for (let i = 0; i < tokens.length; i += 500) chunks.push(tokens.slice(i, i + 500));

  const staleTokens = [];
  for (const chunk of chunks) {
    try {
      const response = await getMessaging().sendEachForMulticast({
        tokens: chunk,
        notification: {title, body},
        data: {type: "price_drop", productId},
      });
      response.responses.forEach((r, i) => {
        if (!r.success && r.error &&
            r.error.code === "messaging/registration-token-not-registered") {
          staleTokens.push(chunk[i]);
        }
      });
    } catch (err) {
      console.error("notifyPriceDrop: FCM gönderimi başarısız.", err);
    }
  }

  // Artık geçersiz (uygulama silinmiş/token değişmiş) kayıtları temizle —
  // aksi halde her fiyat değişiminde boşuna sorgulanır dururlar.
  await Promise.all(staleTokens.map((t) =>
    db.collection("notification_subscriptions").doc(t).delete().catch(() => {})));
});

/**
 * Dinamik ÜRÜN sitemap'i — web/sitemap.xml (statik, her zaman çalışan,
 * ana sayfaları listeleyen dosya) ile ÇAKIŞMAZ, onu TAMAMLAR. Ayrı bir
 * yolda (/sitemap-products.xml) yayınlanır ki fonksiyon deploy edilmese
 * veya hata verse bile ana sitemap.xml her zaman geçerli kalsın.
 *
 * ÖNEMLİ: Ürün linkleri, Flutter tarafındaki FurnitureShareService ile
 * BİREBİR AYNI imzalama şemasını kullanır (bkz.
 * lib/core/services/deeplink/deeplink_service.dart ve
 * lib/core/common/extentions/reg_exp_extentions.dart). Buradaki
 * DOMAIN/HMAC_SECRET/toSlug() farklılaşırsa, üretilen linkler uygulamanın
 * kendi DeepLinkSecurityEngine.verifySignedIdentifier kontrolünü geçemez
 * (mobilde "GÜVENLİK DOĞRULAMASI BAŞARISIZ" ekranı gösterilir).
 *
 * firebase.json → hosting.rewrites içinde "/sitemap-products.xml" bu
 * fonksiyona yönlendirilir (SPA catch-all rewrite'ından ÖNCE tanımlı).
 * Devreye girmesi için `firebase deploy --only functions` gerekir —
 * deploy edilmeden bu URL 404 döner ama site/SEO'nun geri kalanı bundan
 * ETKİLENMEZ.
 */
const SITEMAP_DOMAIN = "https://saglamspotcu.web.app";
const SITEMAP_HMAC_SECRET = "SAGLAM_SPOT_CYBER_SECURITY_KEY_2026";

function signProductId(id) {
  return createHmac("sha256", SITEMAP_HMAC_SECRET).update(id, "utf8").digest("hex");
}

// lib/core/common/extentions/reg_exp_extentions.dart'taki toSlug() ile
// AYNI sırada, AYNI karakter eşleştirmeleriyle çalışmalı.
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

function escapeXml(value) {
  return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&apos;");
}

exports.sitemap = onRequest({cors: true, memory: "256MiB"}, async (req, res) => {
  const today = new Date().toISOString().slice(0, 10);
  const entries = [];

  try {
    const db = getFirestore();
    const snap = await db.collection("Product")
        .where("isSold", "==", false)
        .limit(500)
        .get();

    snap.forEach((doc) => {
      const data = doc.data();
      const id = data._id || doc.id;
      const name = data.name;
      if (!id || !name) return;

      const slug = toSlug(name);
      const signature = signProductId(id);
      const loc = `${SITEMAP_DOMAIN}/product/${encodeURIComponent(`${slug}-${id}`)}?sig=${signature}`;
      const lastmod = doc.updateTime ?
        doc.updateTime.toDate().toISOString().slice(0, 10) :
        today;

      entries.push({loc, lastmod, changefreq: "weekly", priority: "0.7"});
    });
  } catch (err) {
    console.error("Sitemap: ürün sorgusu başarısız oldu, boş bir sitemap döndürülüyor.", err);
  }

  const body = entries.map((e) => `  <url>
    <loc>${escapeXml(e.loc)}</loc>
    <lastmod>${e.lastmod}</lastmod>
    <changefreq>${e.changefreq}</changefreq>
    <priority>${e.priority}</priority>
  </url>`).join("\n");

  const xml = `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${body}\n</urlset>\n`;

  res.set("Content-Type", "application/xml; charset=utf-8");
  res.set("Cache-Control", "public, max-age=3600");
  res.status(200).send(xml);
});
