import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Bir ürünün detay sayfasının kaç kez açıldığını, platforma göre AYRI
/// sayan minik sayaç. Firestore'a doğrudan `FieldValue.increment(1)` ile
/// yazar — `firestore.rules`'daki `isValidViewIncrement` fonksiyonu,
/// girişsiz ziyaretçilerin SADECE bu iki alanı SADECE 1 artırabilmesine
/// izin verir, başka hiçbir alanı değiştiremezler.
///
/// Ziyaretçi kimliği/cihaz/IP TUTULMAZ — bu bilinçli bir tercih: tekil
/// ziyaretçi analitiği değil, "bu ürüne ne kadar ilgi var" için basit ve
/// dürüst bir ham sayaç (bkz. Product.viewCountWeb/viewCountMobile
/// dokümantasyonu).
abstract final class ProductViewTracker {
  static Future<void> trackView(final String productId) async {
    if (productId.isEmpty) return;
    try {
      final field = kIsWeb ? 'viewCountWeb' : 'viewCountMobile';
      await FirebaseFirestore.instance
          .collection('Product')
          .doc(productId)
          .update({field: FieldValue.increment(1)});
    } catch (e) {
      // Sayaç güncellemesi ASLA ürün detayını göstermeyi engellemez —
      // ağ/izin hatası burada sessizce yutulur.
      debugPrint('👁️ Görüntülenme sayacı güncellenemedi: $e');
    }
  }
}
