import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import '../../common/extentions/reg_exp_extentions.dart';

final class FurnitureShareService {
  FurnitureShareService._();

  static const String _fallbackDomain = "https://saglamspot.com";
  static const String _hmacSecret =
      "PRODUCTION_STRONG_SECRET_ROTATED_VAULT_KEY";

  /// Farklı çalışma ortamlarındaki (development, production vb.) hedef ekosistemin kök URI'sini (domain adresini) çözer.
  static String get activeDomainEnvironment =>
      const String.fromEnvironment('TARGET_ENVIRONMENT_DOMAIN',
          defaultValue: _fallbackDomain);

  /// Parametre enjeksiyonuna (değiştirilmesine) karşı korumalı, imzalanmış ve doğrulanabilir bir ürün derin bağlantı (deep link) URL'si oluşturur.
  static String generateSecureProductUrl(final String id, final String name) {
    final cleanSlug = name.toSlug();
    final key = utf8.encode(_hmacSecret);
    final bytes = utf8.encode(id);
    final hmac = Hmac(sha256, key);
    final signature = hmac.convert(bytes).toString();

    return "$activeDomainEnvironment/product/$cleanSlug-$id?sig=$signature";
  }

  /// Kriptografik olarak doğrulanmış yönlendirme bağlantılarını kullanarak paylaşım içeriklerini güvenli bir şekilde yönetir.
  static Future<void> shareProduct({
    required final String productId,
    required final String productName,
    final String? price,
  }) async {
    final safeUrl = generateSecureProductUrl(productId, productName);
    final String priceInfo = price != null ? "\nFiyat: $price TL" : "";
    final String message =
        "Sağlam Spot'ta harika bir mobilya buldum! ✨\n\n$productName$priceInfo\nDetaylar: $safeUrl";

    await Share.share(message, subject: productName);
  }

  static Future<void> shareApp() async =>
      Share.share(
          "Eviniz için en kaliteli spot mobilyalar Sağlam Spot'ta! 🏠\nUygulamayı indir: $activeDomainEnvironment");
}
