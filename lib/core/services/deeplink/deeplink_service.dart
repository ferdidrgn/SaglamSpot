import 'package:share_plus/share_plus.dart';
import '../../common/extentions/reg_exp_extentions.dart';

final class FurnitureShareService {
  FurnitureShareService._();

  static const String _domain = "https://saglamspot.com";

  /// 🛋️ Mobilya Ürün Linki Oluşturucu
  static String generateProductUrl(final String id, final String name) {
    final slug = name.toSlug(); // SEO uyumlu isim
    return "$_domain/product/$slug-$id";
  }

  /// 📤 Ürün Paylaş
  static Future<void> shareProduct({
    required final String productId,
    required final String productName,
    final String? price,
  }) async {
    final url = generateProductUrl(productId, productName);

    final String priceInfo = price != null ? "\nFiyat: $price TL" : "";
    final String message =
        "Sağlam Spot'ta harika bir mobilya buldum! ✨\n\n$productName$priceInfo\nDetaylar: $url";

    await Share.share(message, subject: productName);
  }

  /// 📱 Uygulama Paylaş
  static Future<void> shareApp() async {
    await Share.share(
        "Eviniz için en kaliteli spot mobilyalar Sağlam Spot'ta! 🏠\nUygulamayı indir: $_domain");
  }
}
