const {renderLayout, escapeHtml} = require("../render/layout");
const business = require("../businessInfo");

/**
 * Gizlilik Politikası — lib/features/legal/presentation/pages/
 * privacy_policy_page.dart'taki Türkçe metinle BİREBİR aynı (tek kaynak
 * o dosya; yeniden çeviri/yazım yok). ARB'de karşılığı yok, admin paneli/
 * "Rezerve" rozeti gibi örneklerle AYNI gerekçeyle bilerek Türkçe literal
 * — bu zaten yalnızca Türkçe/İngilizce olarak hazırlanmış, uzun bir
 * hukuki metin; 11 dile dağıtmak anlam kaymasına yol açar.
 *
 * Google AdSense, yayıncı sitelerinde çerez/kişiselleştirilmiş reklam
 * kullanımını açıklayan görünür bir Gizlilik Politikası sayfası ARAR —
 * web-genesis'te bu sayfa YOKTU (saglamspotcu.web.app Flutter'dan
 * web-genesis'e geçtiğinde taşınmamış), bu da AdSense onayı için bir
 * engel. Bu route tam da o eksikliği kapatıyor.
 */
const SECTIONS = (email, phone) => [
  {
    title: "1. Veri Sorumlusu",
    body: [
      `Bu uygulama ve saglamspotcu.web.app web sitesi, İçerenköy Mahallesi, Buket Sokak No:6, Ataşehir/İstanbul adresinde faaliyet gösteren Sağlam Spot tarafından işletilir. Kişisel verilerinizin işlenmesine ilişkin veri sorumlusu sıfatıyla bize ${email} adresinden veya ${phone} numarasından ulaşabilirsiniz.`,
    ],
  },
  {
    title: "2. Topladığımız Bilgiler",
    body: [
      "Sağlam Spot uygulamasında müşteri hesabı/üyelik sistemi bulunmaz; ürünleri görüntülemek için giriş yapmanız gerekmez. Uygulama, hizmet kalitesini iyileştirmek amacıyla Google Firebase altyapısı üzerinden şu bilgileri toplayabilir:",
      "• Firebase Analytics — anonim uygulama kullanım istatistikleri (hangi ekranların ziyaret edildiği, genel cihaz/bölge bilgisi gibi).",
      "• Firebase Crashlytics — çökme ve hata raporları; uygulamayı daha kararlı hâle getirmek için kullanılır.",
      "• Firebase Cloud Messaging — bildirim gönderebilmemiz için cihazınıza özgü bir bildirim belirteci (token).",
      "• Firebase Cloud Firestore — ürün katalog verisi ve (varsa) favori/sepet listeniz gibi uygulama içi tercihleriniz; bu veriler kimliğinizle ilişkilendirilmez.",
      "• Uygulama ve web sitesi Firebase Hosting ve Cloud Functions altyapısında barındırılır; bu hizmetler standart sunucu günlükleri (IP adresi, erişim zamanı gibi) tutabilir.",
      "Bu veriler kimliğinizi doğrudan hedeflemez ve üçüncü kişilerle pazarlama amacıyla paylaşılmaz.",
    ],
  },
  {
    title: "3. Google Haritalar (Google Maps)",
    body: [
      "Mağaza konumumuzu ve yol tarifini göstermek için ana sayfada, Hakkımızda ve SSS sayfalarında Google Haritalar gömülü harita (embed) olarak kullanılır. Harita yüklendiğinde Google, kendi gizlilik politikasına (policies.google.com/privacy) tabi olarak IP adresiniz gibi teknik verileri işleyebilir; bu işleme bizim kontrolümüzde değildir.",
    ],
  },
  {
    title: "4. WhatsApp ve Telefon İletişimi",
    body: [
      `Bir ürünle ilgilenip "WhatsApp'tan Yaz" veya "Ara" butonuna dokunduğunuzda, sizi WhatsApp veya telefon uygulamanıza yönlendiririz; bu iletişim doğrudan sizinle ${phone} numarası arasında gerçekleşir ve WhatsApp/telefon operatörünüzün kendi gizlilik politikalarına tabidir.`,
    ],
  },
  {
    title: "5. Ödeme Bilgisi Toplamayız",
    body: [
      "Uygulama üzerinden çevrimiçi ödeme veya sipariş tamamlama işlemi yapılmaz; \"sepet\" özelliği yalnızca ilgilendiğiniz ürünleri not edip mağazaya toplu olarak sormanızı sağlayan bir istek listesidir. Kredi kartı, banka bilgisi gibi ödeme verileri hiçbir şekilde toplanmaz veya saklanmaz.",
    ],
  },
  {
    title: "6. Konum ve Diğer Cihaz İzinleri",
    body: [
      "Uygulama konumunuzu arka planda takip etmez. Bazı özellikler (örn. ürün fotoğrafı ekleme, bildirim gösterme) için cihazınızdan galeri/kamera veya bildirim izni isteyebiliriz; bu izinler yalnızca ilgili özellik kullanılırken devreye girer ve istediğiniz zaman cihaz ayarlarından geri alabilirsiniz.",
    ],
  },
  {
    title: "7. Çerezler ve Web Sitesi Analitiği",
    body: [
      "saglamspotcu.web.app web sitesi; oturum/tercih bilgilerinizi hatırlamak, site trafiğini ölçmek (Google Analytics/Firebase Analytics) ve reklam göstermek (Google AdSense) amacıyla çerez (cookie) ve benzeri teknolojiler kullanabilir. Tarayıcı ayarlarınızdan çerezleri silebilir veya engelleyebilirsiniz; ancak bu durumda sitenin bazı bölümleri beklendiği gibi çalışmayabilir.",
    ],
  },
  {
    title: "8. Verilerin Saklanması, Güvenliği ve Saklama Süresi",
    body: [
      "Toplanan sınırlı kullanım verileri Google Firebase altyapısında (sunucular Google'ın veri merkezlerinde) endüstri standardı güvenlik önlemleriyle saklanır. Analytics ve Crashlytics verileri Google'ın kendi varsayılan saklama süreleri boyunca (genellikle birkaç ay ile 14 ay arası) tutulur; bu süre sonunda otomatik olarak silinir. Verileriniz üçüncü taraflara satılmaz.",
    ],
  },
  {
    title: "9. Reklamlar (Google AdSense / AdMob)",
    body: [
      "Uygulamada ve web sitemizde, Sağlam Spot'un ücretsiz kalabilmesine katkı sağlayan reklamlar Google AdMob (mobil uygulama) ve Google AdSense (web sitesi) aracılığıyla gösterilir. Bu kapsamda:",
      "• Google, ilginizi çekebilecek reklamlar gösterebilmek için cihaz reklam kimliği (Advertising ID), IP adresi ve genel kullanım verileri gibi bilgileri işleyebilir; buna \"kişiselleştirilmiş reklamcılık\" denir.",
      "• Bu verileri biz doğrudan görmeyiz veya saklamayız; işleme Google'ın kendi gizlilik politikasına (policies.google.com/privacy) tabidir.",
      "• Kişiselleştirilmiş reklamları cihazınızın ayarlarından (Android: Ayarlar > Google > Reklamlar; iOS: Ayarlar > Gizlilik > İzleme) ya da adssettings.google.com üzerinden kapatabilirsiniz; bu durumda reklamlar kişiselleştirilmemiş olarak gösterilmeye devam edebilir.",
      "• Web sitemizde Google AdSense çerez (cookie) ve benzer tanımlayıcılar kullanabilir; tarayıcı ayarlarınızdan çerezleri yönetebilirsiniz.",
    ],
  },
  {
    title: "10. Avrupa Ekonomik Alanı (EEA), İngiltere ve İsviçre",
    body: [
      "Avrupa Ekonomik Alanı, Birleşik Krallık veya İsviçre'den web sitemizi ziyaret ediyorsanız, Google'ın reklam ortakları politikası gereği kişiselleştirilmiş reklam gösterilmeden önce onayınız alınır; bu onay akışı Google'ın kendi reklam/çerez onay mekanizması üzerinden yönetilir. Onay tercihlerinizi istediğiniz zaman değiştirebilirsiniz.",
    ],
  },
  {
    title: "11. KVKK Kapsamındaki Haklarınız",
    body: [
      `6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) madde 11 uyarınca; kişisel verilerinizin işlenip işlenmediğini öğrenme, işlenmişse buna ilişkin bilgi talep etme, işlenme amacını ve amacına uygun kullanılıp kullanılmadığını öğrenme, yurt içinde/yurt dışında aktarıldığı üçüncü kişileri bilme, eksik/yanlış işlenmişse düzeltilmesini isteme, kanuni şartlar çerçevesinde silinmesini veya yok edilmesini isteme ve bu işlemlerin verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme hakkına sahipsiniz. Bu haklarınızı kullanmak için ${email} adresinden bize ulaşabilirsiniz; talepleriniz en kısa sürede ve her hâlükârda kanuni süre içinde yanıtlanır.`,
    ],
  },
  {
    title: "12. Çocukların Gizliliği",
    body: [
      "Uygulamamız ve web sitemiz 13 yaş altı çocuklara özel olarak yönlendirilmemiştir; bilerek çocuklardan kişisel veri toplamayız. Bir çocuğun bize bilmeden veri sağladığını düşünüyorsanız lütfen bizimle iletişime geçin, ilgili veriyi sileriz.",
    ],
  },
  {
    title: "13. Haklarınız ve İletişim",
    body: [`Gizlilikle ilgili sorularınız için bize ${email} adresinden ulaşabilirsiniz.`],
  },
  {
    title: "14. Değişiklikler",
    body: [
      "Bu politika zaman zaman güncellenebilir; önemli değişiklikler bu sayfada duyurulur ve bu sayfanın başındaki \"son güncelleme\" tarihi güncellenir.",
    ],
  },
];

module.exports = function privacyRoute(req, res) {
  const locale = req.locale;

  const sectionsHtml = SECTIONS(business.email, business.displayPhone).map((s) => `
<section class="section about-panel">
  <h2>${escapeHtml(s.title)}</h2>
  ${s.body.map((p) => `<p>${escapeHtml(p)}</p>`).join("\n  ")}
</section>`).join("\n");

  const bodyHtml = `
<section class="hero about-hero">
  <p class="eyebrow">Hukuki</p>
  <h1>Gizlilik Politikası</h1>
  <p class="lede">Son güncelleme: 13 Ekim 2026</p>
</section>
${sectionsHtml}`;

  res.set("Cache-Control", "public, max-age=3600");
  res.status(200).send(renderLayout({
    req,
    title: "Gizlilik Politikası",
    description: "Sağlam Spot gizlilik politikası — topladığımız veriler, çerezler, Google AdSense/Analytics kullanımı ve KVKK haklarınız.",
    path: "/gizlilik",
    bodyHtml,
    locale,
  }));
};
