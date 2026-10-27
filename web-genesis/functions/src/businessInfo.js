/**
 * Mağaza/iletişim/konum bilgileri — lib/core/util/comminucation_actions.dart
 * (Flutter) ile BİREBİR aynı tutulmalı. Tek kaynak burası değil, oradaki
 * dosya; bu sadece web-genesis'in kendi kopyası.
 */
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
  whatsappUrl(message = "Merhaba, mobilyalar hakkında bilgi almak istiyorum.") {
    return `https://wa.me/${this.phoneNumberIntl}?text=${encodeURIComponent(message)}`;
  },
};
