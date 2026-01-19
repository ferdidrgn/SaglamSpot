import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// 🏬 Sağlam Spot İletişim, Konum ve Ulaşım Servisi
final class SaglamSpotCommunication {
  SaglamSpotCommunication._();

  // --- MAĞAZA BİLGİLERİ ---
  static const String _phoneNumber = "905392019961";
  static const String _instaUser = "saglamspot";
  static const String _fullAddress =
      "İçerenköy Mahallesi Buket Sokak No:6, Ataşehir/İstanbul";

  // Koordinatlar: İçerenköy / Buket Sokak
  static const double _lat = 40.9691;
  static const double _lng = 29.1105;

  // --- 📞 İLETİŞİM AKSİYONLARI ---

  /// WhatsApp hattını başlatır
  static Future<void> launchWhatsApp(
      {String message =
          "Merhaba, mobilyalar hakkında bilgi almak istiyorum."}) async {
    final Uri url = Uri.parse(
        "https://wa.me/$_phoneNumber?text=${Uri.encodeComponent(message)}");
    await _launch(url);
  }

  /// Doğrudan telefon araması başlatır
  static Future<void> makeCall() async {
    final Uri url = Uri.parse("tel:+$_phoneNumber");
    await _launch(url);
  }

  /// Instagram profilini açar
  static Future<void> openInstagram() async {
    final native = Uri.parse("instagram://user?username=$_instaUser");
    final web = Uri.parse("https://www.instagram.com/$_instaUser");

    try {
      if (!await launchUrl(native,
          mode: LaunchMode.externalNonBrowserApplication)) {
        await launchUrl(web, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(web, mode: LaunchMode.externalApplication);
    }
  }

  // --- 📍 KONUM VE NAVİGASYON ---

  /// Mağaza konumunu Apple veya Google Haritalar'da açar
  static Future<void> openStoreLocation() async {
    final String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$_lat,$_lng";
    final String appleUrl =
        "https://maps.apple.com/?q=Sağlam Spot&ll=$_lat,$_lng";

    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        if (await canLaunchUrl(Uri.parse(appleUrl))) {
          await launchUrl(Uri.parse(appleUrl),
              mode: LaunchMode.externalApplication);
          return;
        }
      }

      await launchUrl(Uri.parse(googleUrl),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Harita açılırken hata: $e");
    }
  }

  // --- 🚌 ULAŞIM VE HİZMET BİLGİLERİ ---

  /// Mağazaya yakın otobüs hatlarını döndürür
  static Map<String, List<String>> getBusLines() {
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

  /// Ücretsiz nakliye yapılan bölgeler
  static List<String> get freeDeliveryZones => [
        'İçerenköy',
        'Fındıklı',
        'Kayışdağı',
        'Küçükbakkalköy',
        'İnönü Mahallesi',
        'Bostancı Sanayi Çevresi'
      ];

  /// Haftalık çalışma saatleri
  static String get workingHours =>
      "Pzt-Cmt: 09:00 - 22:00\nPazar: 10:00 - 20:00";

  // --- 🛠 YARDIMCI METOT ---
  static Future<void> _launch(Uri url) async {
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        debugPrint("URL başlatılamadı: $url");
      }
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }
}
