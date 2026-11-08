import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Admin istatistikler ekranının okuduğu, zaman damgalı, gerçek olay
/// kaydı — `viewCountWeb`/`viewCountMobile` gibi ömür boyu toplam
/// sayaçların AKSİNE (bkz. product_view_tracker.dart), bunlar tarihe göre
/// filtrelenebilir grafik/tablo üretebilmek için TEK TEK Firestore'a
/// yazılır (`analytics_events` koleksiyonu). Ziyaretçi kimliği/oturumu
/// TUTULMAZ — sadece olay türü + ürün/kategori + platform + zaman
/// (viewCountWeb/Mobile'daki AYNI "basit ve dürüst ham sayaç" felsefesi).
///
/// `sale` dışındaki türler (view/contact_click/favorite) girişsiz
/// ziyaretçilerden de yazılabilir (bkz. firestore.rules →
/// isValidPublicAnalyticsEvent); `sale` sadece admin ürünü satıldı
/// işaretlerken yazılır (fiyat içerdiği için admin'e özel).
abstract final class AnalyticsEventLogger {
  static const String _collection = 'analytics_events';

  static Future<void> log({
    required final String type,
    required final String productId,
    required final String category,
    final double? price,
  }) async {
    if (productId.isEmpty) return;
    try {
      await FirebaseFirestore.instance.collection(_collection).add({
        'type': type,
        'productId': productId,
        'category': category,
        'platform': kIsWeb ? 'web' : 'mobile',
        if (price != null) 'price': price,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // İstatistik yazımı ASLA kullanıcı eylemini (görüntüleme, favori,
      // WhatsApp'tan sorma, satış işaretleme) engellemez — ağ/izin
      // hatası burada sessizce yutulur (ProductViewTracker ile AYNI desen).
      debugPrint('📊 analytics_events yazılamadı ($type): $e');
    }
  }
}
