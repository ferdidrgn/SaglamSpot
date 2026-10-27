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
  whatsappUrl(message = "Merhaba, mobilyalar hakkında bilgi almak istiyorum.") {
    return `https://wa.me/${this.phoneNumberIntl}?text=${encodeURIComponent(message)}`;
  },
};
