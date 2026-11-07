/**
 * Mağaza/iletişim/konum bilgileri — lib/core/util/comminucation_actions.dart
 * (Flutter) ile BİREBİR aynı tutulmalı. Tek kaynak burası değil, oradaki
 * dosya; bu sadece web-genesis'in kendi kopyası.
 */
// Müşterinin tarayıcıda seçtiği arayüz dili Türkçe değilse WhatsApp
// mesajının sonuna eklenen not için — esnaf sadece Türkçe okuyor, mesaj
// gövdesi HER ZAMAN Türkçe kalır (bkz. whatsappUrl) ama bu notla hangi
// dilde gezindiğini görür.
const LOCALE_TR_NAMES = {
  en: "İngilizce",
  ar: "Arapça",
  de: "Almanca",
  el: "Yunanca",
  it: "İtalyanca",
  ky: "Kırgızca",
  ru: "Rusça",
  uk: "Ukraynaca",
  uz: "Özbekçe",
  zh: "Çince",
};

module.exports = {
  brandName: "Sağlam Spot",
  phoneNumberIntl: "905392019961",
  displayPhone: "+90 539 201 99 61",
  email: "info@saglamspot.com",
  instagramUser: "saglamspot",
  facebookUser: "saglamspot",
  address: {
    line: "İçerenköy Mahallesi, Buket Sokak No:6",
    district: "Ataşehir",
    city: "İstanbul",
    country: "TR",
  },
  geo: {
    latitude: 40.9699196,
    longitude: 29.1148379,
  },
  workingHours: "Pzt-Cmt: 09:00 - 22:00\nPazar: 10:00 - 20:00",
  openingHoursSpecification: [
    {dayOfWeek: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], opens: "09:00", closes: "22:00"},
    {dayOfWeek: "Sunday", opens: "10:00", closes: "20:00"},
  ],
  googleMapsUrl: "https://www.google.com/maps/place/Sa%C4%9Flam+Spot/@40.9699248,29.1146853,21z/data=!4m6!3m5!1s0x14cac64216b4ccb7:0x49124944b40496f6!8m2!3d40.9699196!4d29.1148379!16s%2Fg%2F11dxc20095",
  // lib/core/util/comminucation_actions.dart -> getBusLines() ile aynı.
  busLines: [
    {stop: "Ziyapaşa Durağı (Kadıköy Yönü)", lines: ["19", "19F", "19FB", "14KS", "18UK", "KM46-1"]},
    {stop: "İçerenköy Durağı (Kayışdağı Yönü)", lines: ["19", "19F", "19FB", "14KS", "18UK", "KM46-1"]},
    {stop: "İçerenköy Durağı (Yeniyol)", lines: ["10", "319", "KM46", "13AB", "14T"]},
  ],
  whatsappUrl(message = "Merhaba, mobilyalar hakkında bilgi almak istiyorum.", locale) {
    const langName = LOCALE_TR_NAMES[locale];
    const fullMessage = langName ? `${message}\n\n— Not: Bu talep sitenin ${langName} sürümünden gönderildi.` : message;
    return `https://wa.me/${this.phoneNumberIntl}?text=${encodeURIComponent(fullMessage)}`;
  },
  get instagramUrl() {
    return `https://www.instagram.com/${this.instagramUser}`;
  },
  get facebookUrl() {
    return `https://www.facebook.com/${this.facebookUser}`;
  },
  // lib/core/util/comminucation_actions.dart'taki isOpenNow/todayHoursLabel
  // ile AYNI mantık. Türkiye 2016'dan beri yaz saati uygulamıyor, sabit
  // UTC+3 — sunucunun (Cloud Functions, UTC) kendi saat dilimine
  // GÜVENİLMEDEN İstanbul saatini elle hesaplar.
  _istanbulNow() {
    return new Date(Date.now() + 3 * 60 * 60 * 1000);
  },
  get isOpenNow() {
    const now = this._istanbulNow();
    const isSunday = now.getUTCDay() === 0;
    const openMinutes = (isSunday ? 10 : 9) * 60;
    const closeMinutes = (isSunday ? 20 : 22) * 60;
    const nowMinutes = now.getUTCHours() * 60 + now.getUTCMinutes();
    return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
  },
  get todayHoursLabel() {
    return this._istanbulNow().getUTCDay() === 0 ? "10:00 - 20:00" : "09:00 - 22:00";
  },
};
module.exports.LOCALE_TR_NAMES = LOCALE_TR_NAMES;
