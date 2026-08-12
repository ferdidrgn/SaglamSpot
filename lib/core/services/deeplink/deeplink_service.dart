import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import '../../common/extentions/reg_exp_extentions.dart'; //
import '../../util/comminucation_actions.dart';

final class FurnitureShareService {
  FurnitureShareService._(); //

  // ELITE SECURITY REFACTOR: WhatsApp/Mail uyarılarını aşmak için onaylı domain ve kriptografik anahtar
  static const String _domain = "https://saglamspotcu.web.app";
  static const String _hmacSecret = "SAGLAM_SPOT_CYBER_SECURITY_KEY_2026";

  /// Tek kaynaktan HMAC imzası. Hem dışa paylaşılan linkler (bu dosya) hem
  /// de router'daki (app_router.dart → DeepLinkSecurityEngine) doğrulama
  /// hem de uygulama içi gezinme (NavigationHandler.goToProduct) AYNI bu
  /// fonksiyonu ve aynı anahtarı kullanır — iki farklı anahtarla imzalanıp
  /// asla doğrulanamayan linkler üretilmesin diye.
  static String signProductId(final String id) {
    final key = utf8.encode(_hmacSecret);
    final bytes = utf8.encode(id);
    final hmac = Hmac(sha256, key);
    return hmac.convert(bytes).toString();
  }

  /// 🛋️ Kriptografik İmzalı Güvenli Ürün Linki Oluşturucu
  static String generateProductUrl(final String id, final String name) {
    final slug = name.toSlug(); // SEO uyumlu isim
    final signature = signProductId(id);

    // URL parametreleri tarayıcı standartlarına göre encode edilir
    final safeSlugWithId = Uri.encodeComponent("$slug-$id");
    return "$_domain/product/$safeSlugWithId?sig=$signature";
  }

  /// 📤 Ürün Paylaş
  static Future<void> shareProduct({
    required final String productId,
    required final String productName,
    final String? price,
  }) async {
    final url = generateProductUrl(productId, productName);

    final String priceInfo = price != null ? "\nFiyat: $price TL" : ""; //
    final String message =
        "Sağlam Spot'ta harika bir mobilya buldum! ✨\n\n$productName$priceInfo\nDetaylar: $url"; //

    await Share.share(message, subject: productName); //
  }

  /// 📱 Uygulama Paylaş
  static Future<void> shareApp() async {
    await Share.share(
        "Eviniz için en kaliteli spot mobilyalar Sağlam Spot'ta! 🏠\nUygulamayı indir: $_domain"); //
  }

  // ─────────────────────────────────────────────────────────────
  // WHATSAPP İLETİŞİM (Ürün detay sayfasındaki "Satın Al"/"Mesaj" butonları)
  // ─────────────────────────────────────────────────────────────

  /// Ürünle ilgili WhatsApp üzerinden iletişime geçer; mesaja ürün adını,
  /// fiyatını ve linkini otomatik doldurur. Numara tek kaynaktan
  /// (SaglamSpotCommunication) gelir, burada tekrar tanımlanmaz.
  static Future<void> contactAboutProduct({
    required final String productId,
    required final String productName,
    required final double price,
  }) async {
    final url = generateProductUrl(productId, productName);
    final message = 'Merhaba, "$productName" (₺${price.toStringAsFixed(0)}) '
        'ürünü ile ilgileniyorum.\n$url';
    await SaglamSpotCommunication.launchWhatsApp(message: message);
  }
}