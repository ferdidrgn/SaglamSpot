const {getDb} = require("../firebaseAdmin");
const {renderLayout, escapeHtml} = require("../render/layout");
const business = require("../businessInfo");

/**
 * Faz 0 iskelet ana sayfası: Firestore bağlantısını kanıtlamak için
 * satılmamış ürün sayısını (aggregation query, doküman içeriği çekmeden)
 * okuyup gösterir. Gerçek vitrin listelemesi Faz 1'de burayı değiştirir.
 */
module.exports = async function homeRoute(req, res) {
  let productCount = null;
  let firestoreError = null;

  try {
    const snapshot = await getDb()
        .collection("Product")
        .where("isSold", "==", false)
        .count()
        .get();
    productCount = snapshot.data().count;
  } catch (err) {
    firestoreError = err.message;
  }

  const statusHtml = firestoreError
    ? `<p class="status status-error">Firestore bağlantı hatası: ${escapeHtml(firestoreError)}</p>`
    : `<p class="status status-ok">Firestore bağlantısı çalışıyor — şu anda satışta <strong>${productCount}</strong> ürün var.</p>`;

  const bodyHtml = `
<section class="hero">
  <p class="eyebrow">web-genesis — Faz 0 iskelet</p>
  <h1>Sağlam Spot'un yeni web vitrini inşa ediliyor</h1>
  <p class="lede">Bu sayfa henüz vitrin değil; sunucu tarafı render (SSR) + Firestore bağlantısının çalıştığını doğruluyor.</p>
  ${statusHtml}
  <p><a class="whatsapp-link" href="${business.whatsappUrl()}" rel="noopener">WhatsApp'tan yazın: ${escapeHtml(business.displayPhone)}</a></p>
</section>`;

  res.set("Cache-Control", "no-cache, no-store, must-revalidate");
  res.status(200).send(renderLayout({
    title: "Ana Sayfa",
    path: "/",
    bodyHtml,
  }));
};
