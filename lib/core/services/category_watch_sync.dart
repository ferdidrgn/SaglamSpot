import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../common/enum/enums.dart';
import '../common/extentions/product_category_ex.dart';
import 'notification_service.dart';

/// "Yeni Ürün Bildirimi" (kategori takibi) — kullanıcının işaretlediği
/// kategorilerde yeni bir ürün eklendiğinde Cloud Functions
/// (`onProductCreated`, bkz. functions/index.js) push bildirimi
/// gönderebilsin diye, bu cihazın FCM token'ını takip ettiği kategori
/// listesiyle eşleştirerek Firestore'a yazar.
/// `category_watch_subscriptions/{fcmToken}` dokümanında `categories`
/// (enum adı dizisi, ör. ["sofa","chair"]) olarak tutulur —
/// `favorite_notification_sync.dart`'taki (fiyat düşüşü) desenle AYNI.
///
/// Push bildirimleri şu an SADECE Android/iOS'ta çalışıyor (web için
/// Service Worker + VAPID anahtarı henüz kurulmadı, bkz.
/// docs/PUSH_NOTIFICATIONS.md) — bu yüzden bu senkronizasyon ve ona
/// bağlı ayarlar ekranı kontrolü bilerek yalnızca native mobilde
/// gösterilir (`!kIsWeb`), web'de hiç çağrılmaz.
abstract final class CategoryWatchSync {
  static const String _collection = 'category_watch_subscriptions';

  static Future<void> sync(final Set<ProductCategory> categories) async {
    final token = NotificationService.currentToken;
    if (token == null || token.isEmpty) return;

    try {
      final doc = FirebaseFirestore.instance.collection(_collection).doc(token);
      if (categories.isEmpty) {
        await doc.delete();
        return;
      }
      await doc.set({
        'categories': categories.map((final c) => c.toFirestore()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('⚠️ Kategori bildirimi senkronizasyonu başarısız: $e');
    }
  }
}
