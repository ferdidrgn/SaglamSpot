import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunicationActions {
  // --- TEMEL BİLGİLER ---
  static const String phoneNumber = "905392019961";
  static const String fullAddress =
      "İçerenköy Mahallesi Buket Sokak No:6, Ataşehir/İstanbul";

  // Mağaza Koordinatları (İçerenköy/Buket Sokak civarı)
  static const double latitude = 40.9691;
  static const double longitude = 29.1105;

  // --- WHATSAPP ---
  static Future<void> launchWhatsApp(
      {String message =
          "Merhaba, mobilyalar hakkında bilgi almak istiyorum."}) async {
    final Uri url = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
    await _launch(url);
  }

  // --- TELEFON ARAMA ---
  static Future<void> makeCall() async {
    final Uri url = Uri.parse("tel:+$phoneNumber");
    await _launch(url);
  }

  // --- HARİTADA GÖSTER / YOL TARİFİ ---
  static Future<void> openMaps() async {
    // Google Maps ve Apple Maps için evrensel format
    final String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final String appleUrl = "https://maps.apple.com/?q=$latitude,$longitude";

    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl),
          mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(Uri.parse(appleUrl),
          mode: LaunchMode.externalApplication);
    }
  }

  // --- OTOBÜS HATLARI VERİSİ ---
  static Map<String, List<String>> getDetailedTransportInfo() {
    return {
      'Ziyapaşa Durağı (Kadıköy Yönü)': [
        '19',
        '19F',
        '19FB',
        '14KS',
        '18UK',
        'KM46-1'
      ],
      'İçerenköy Durağı (Kayışdağı Yönü)': [
        '19',
        '19F',
        '19FB',
        '14KS',
        '18UK',
        'KM46-1'
      ],
      'İçerenköy Durağı (Yeniyol)': ['10', '319', 'KM46', '13AB', '14T'],
    };
  }

  // --- ÇALIŞMA SAATLERİ ---
  static String get workingHours =>
      "Pzt-Cmt: 09:00 - 22:00\nPazar: 10:00 - 20:00";

  // --- NAKLİYE BÖLGELERİ ---
  static List<String> get freeDeliveryZones => [
        'İçerenköy',
        'Fındıklı',
        'Kayışdağı',
        'Küçükbakkalköy',
        'İnönü Mahallesi',
        'Bostancı Sanayi Çevresi'
      ];

  // Ortak Launch Fonksiyonu
  static Future<void> _launch(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication))
      throw 'Could not launch $url';
  }
}
