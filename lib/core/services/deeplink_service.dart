import 'dart:js_interop'; //
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart'; //
import '../common/extentions/reg_exp_extentions.dart'; //

// JS tarafındaki setMeta fonksiyonunu Flutter'a tanıtıyoruz
@JS()
external void setMeta(final String title, final String description, final String image, final String url);

class DeeplinkShareService {
  static const String _baseUrl = "https://saglamspotcu.web.app"; //

  static String generateProductUrl(final String id, final String name) {
    final String slug = name.toSlug(); //
    return "$_baseUrl/product/$slug-$id"; //
  }

  static Future<void> shareProduct({
    required final String productId,
    required final String productName,
  }) async {
    final String url = generateProductUrl(productId, productName);
    final String message = "Sağlam Spot - $productName\n$url";

    // Güncel share_plus kullanımı:
    // Eğer share_plus 10.0.0+ kullanıyorsan direkt Share.share kullanılır
    // ancak static kullanım yerine paket bazen instance bekler.
    // En güvenli ve güncel hali şudur:
    await Share.share(
      message,
      subject: productName,
    );
  }

  static void updateWebMeta({
    required final String title,
    required final String description,
    required final String imageUrl,
    required final String productId,
    required final String productName,
  }) {
    if (kIsWeb) { //
      try {
        final url = generateProductUrl(productId, productName);
        // index.html içindeki setMeta fonksiyonunu çağırır
        setMeta(title, description, imageUrl, url);
      } catch (e) {
        debugPrint("Meta hatası: $e");
      }
    }
  }
}