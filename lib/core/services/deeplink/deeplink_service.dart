import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/extentions/reg_exp_extentions.dart'; //
import '../../util/comminucation_actions.dart';

final class FurnitureShareService {
  FurnitureShareService._(); //

  // Ürün ve sepet linkleri herkese açık vitrin verisidir; client-side secret
  // güvenlik sınırı değildir. Yetki yalnızca Firestore/Storage kuralları ve
  // admin callable'larıyla korunur.
  static const String _domain = "https://saglamspotcu.web.app";

  /// Genel mağaza linki (tekil ürün değil) — sepet gibi toplu mesajlarda
  /// "tüm ürünleri görmek isterseniz" şeklinde eklenir.
  static String get storeUrl => _domain;

  /// 🛋️ Herkese açık ürün linki oluşturucu.
  static String generateProductUrl(final String id, final String name) {
    final slug = name.toSlug(); // SEO uyumlu isim

    // URL parametreleri tarayıcı standartlarına göre encode edilir
    final safeSlugWithId = Uri.encodeComponent("$slug-$id");
    return "$_domain/product/$safeSlugWithId";
  }

  // ─────────────────────────────────────────────────────────────
  // SEPET DERİN BAĞLANTISI — müşteri WhatsApp'tan "sepeti gönder" dediğinde
  // mesaja TEK bir link eklenir; o linki açan kişi (genelde esnaf, kendi
  // telefonunda) uygulamada AYNI ürün+adet listesiyle dolu bir sepet
  // görür — mesaj metnini tek tek okuyup ürünleri tek tek aramak yerine.
  // ─────────────────────────────────────────────────────────────

  /// "id1:adet1,id2:adet2" formatında, tek kaynaktan encode/decode.
  static String encodeCartItemsParam(
      final Iterable<({String productId, int quantity})> items) {
    return items.map((final i) => '${i.productId}:${i.quantity}').join(',');
  }

  /// Bozuk/eksik parçaları sessizce atlar; sepet yalnızca herkese açık ürün
  /// verisini temsil eder, satın alma veya ödeme yetkisi taşımaz.
  static Map<String, int> decodeCartItemsParam(final String raw) {
    final result = <String, int>{};
    for (final part in raw.split(',')) {
      final pieces = part.split(':');
      if (pieces.length != 2) continue;
      final qty = int.tryParse(pieces[1]);
      if (qty == null || qty < 1 || pieces[0].isEmpty) continue;
      result[pieces[0]] = qty;
    }
    return result;
  }

  static String generateCartUrl(
      final Iterable<({String productId, int quantity})> items) {
    final itemsParam = encodeCartItemsParam(items);
    return "$_domain/cart?items=${Uri.encodeComponent(itemsParam)}";
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

  // Google Play'deki gerçek paket adı — android/app/build.gradle.kts'teki
  // applicationId ile birebir aynı olmalı.
  static const String _androidPackageId = "com.ferdidrgn.saglamspot";

  /// ⭐ Mağaza Sayfasını Aç (Uygulamayı Değerlendir)
  /// Play Store uygulaması kuruluysa doğrudan içinde, değilse tarayıcıda açar.
  static Future<void> openStoreListingForReview() async {
    final Uri marketUri = Uri.parse("market://details?id=$_androidPackageId");
    final Uri webUri = Uri.parse(
        "https://play.google.com/store/apps/details?id=$_androidPackageId");

    try {
      if (defaultTargetPlatform == TargetPlatform.android &&
          await canLaunchUrl(marketUri)) {
        await launchUrl(marketUri, mode: LaunchMode.externalApplication);
        return;
      }
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
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
