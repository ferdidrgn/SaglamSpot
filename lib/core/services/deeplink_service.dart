import 'package:share_plus/share_plus.dart';
import '../common/extentions/reg_exp_extentions.dart';

class DeepLinkService {
  static const String _baseUrl = "https://www.saglamspotcu.web.app";

  /// Sadece temiz ürün detay linkini oluşturur
  static String generateProductUrl({
    required final String productId,
    required final String productName,
  }) {
    final String slug = productName.toSlug();
    // Sonuç: https://www.saglamspotcu.web.app/product/tabureler-7Ig1s...
    return "$_baseUrl/product/$slug-$productId";
  }

  /// Ürünü paylaşım penceresiyle paylaşır
  static Future<void> shareProduct({
    required final String productId,
    required final String productName,
  }) async {
    final String url = generateProductUrl(
      productId: productId,
      productName: productName,
    );

    // Mesaj içeriğini daha kurumsal ve sade hale getirdik
    final String message = "Sağlam Spot - $productName:\n$url";

    await Share.share(
      message,
      subject: productName,
    );
  }
}
