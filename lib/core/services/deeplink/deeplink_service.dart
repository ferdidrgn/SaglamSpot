import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import '../../common/extentions/reg_exp_extentions.dart';
import 'deeplink_service_stub.dart'
    if (dart.library.js_interop) 'social_share_web.dart';
// KOŞULLU IMPORT: Web ise web dosyasını, değilse stub dosyasını yükle

class DeeplinkShareService {
  static const String _baseUrl = "https://saglamspotcu.web.app";

  static String generateProductUrl(final String id, final String name) {
    final String slug = name.toSlug();
    return "$_baseUrl/product/$slug-$id";
  }

  static Future<void> shareProduct({
    required final String productId,
    required final String productName,
  }) async {
    final String url = generateProductUrl(productId, productName);
    final String message = "Sağlam Spot - $productName\n$url";

    await Share.share(message, subject: productName);
  }

  static void updateWebMeta({
    required final String title,
    required final String description,
    required final String imageUrl,
    required final String productId,
    required final String productName,
  }) {
    // kIsWeb kontrolü ile sadece web'de çalıştırıyoruz
    if (kIsWeb) {
      try {
        final url = generateProductUrl(productId, productName);
        // Bu çağrı, web'de deeplink_service_web.dart'taki fonksiyonu,
        // mobilde ise deeplink_service_stub.dart'taki boş fonksiyonu çağırır.
        setMeta(title, description, imageUrl, url);
      } catch (e) {
        debugPrint("Meta hatası: $e");
      }
    }
  }
}
