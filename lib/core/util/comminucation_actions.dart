import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/navigation/providers/navigation_keys.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';

/// 🏬 Sağlam Spot İletişim, Konum ve Ulaşım Servisi
final class SaglamSpotCommunication {
  SaglamSpotCommunication._();

  // --- MAĞAZA BİLGİLERİ ---
  static const String _phoneNumber = "905392019961";
  static const String _instaUser = "saglamspot";
  static const String _fbUser = "saglamspot";
  static const String email = "info@saglamspot.com";

  /// Ekranda göstermek için biçimlendirilmiş telefon numarası.
  static String get displayPhone => "+90 539 201 99 61";

  // Koordinatlar: İçerenköy / Buket Sokak
  static const double _lat = 40.9691;
  static const double _lng = 29.1105;

  // Google'daki doğrulanmış mağaza kaydının hassas koordinatları (yukarıdaki
  // kaba _lat/_lng'den farklı — openStoreLocation()'daki Google URL'sinden
  // alınmıştır). Harita gömme/görsel amaçlı kullanılır.
  static const double placeLatitude = 40.9699196;
  static const double placeLongitude = 29.1148379;

  // --- 📞 İLETİŞİM AKSİYONLARI ---

  /// WhatsApp hattını başlatır. Uygulama açılmazsa telefonla aramayı önerir.
  static Future<void> launchWhatsApp(
      {String message =
          "Merhaba, mobilyalar hakkında bilgi almak istiyorum."}) async {
    final Uri url = Uri.parse(
        "https://wa.me/$_phoneNumber?text=${Uri.encodeComponent(message)}");
    final opened = await _launch(url);
    if (opened) return;
    final ctx = NavigationKeys.rootNavigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) return;
    final call = await showDialog<bool>(
      context: ctx,
      builder: (final dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.whatsAppUnavailableTitle),
        content: Text(dialogContext.l10n.whatsAppUnavailableBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.l10n.callInstead,
                style: TextStyle(color: AppColors.accentDark)),
          ),
        ],
      ),
    );
    if (call == true) await makeCall();
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

  /// Facebook sayfasını açar
  static Future<void> openFacebook() async {
    final native = Uri.parse("fb://facewebmodal/f?href=https://www.facebook.com/$_fbUser");
    final web = Uri.parse("https://www.facebook.com/$_fbUser");

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
    // Google için tam mağaza kaydını gösteren kesin adres (place ID'li).
    const String googleUrl =
        'https://www.google.com/maps/place/Sa%C4%9Flam+Spot/@40.9699248,29.1146853,21z/data=!4m6!3m5!1s0x14cac64216b4ccb7:0x49124944b40496f6!8m2!3d40.9699196!4d29.1148379!16s%2Fg%2F11dxc20095?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D';
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

  /// Bugünün açılış-kapanış saati (tek satır, dinamik gösterimler için).
  static String get todayHoursLabel =>
      DateTime.now().weekday == DateTime.sunday
          ? "10:00 - 20:00"
          : "09:00 - 22:00";

  /// Mağazanın şu anda (gerçek saate göre) açık olup olmadığı.
  static bool get isOpenNow {
    final now = DateTime.now();
    final isSunday = now.weekday == DateTime.sunday;
    final openMinutes = (isSunday ? 10 : 9) * 60;
    final closeMinutes = (isSunday ? 20 : 22) * 60;
    final nowMinutes = now.hour * 60 + now.minute;
    return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
  }

  // --- 🛠 YARDIMCI METOT ---
  static Future<bool> _launch(Uri url) async {
    try {
      final opened =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!opened) debugPrint("URL başlatılamadı: $url");
      return opened;
    } catch (e) {
      debugPrint("Hata: $e");
      return false;
    }
  }
}
