import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

/// Favorilenen ürünleri, bu cihazın FCM push token'ıyla eşleştirerek
/// Firestore'a yazar — bir ürünün fiyatı düşünce Cloud Functions
/// (`notifyPriceDrop`, bkz. functions/index.js) bu eşleşmeyi kullanarak
/// SADECE o ürünü favorileyen cihazlara kişiye özel bildirim gönderebilsin
/// diye. `notification_subscriptions/{fcmToken}` dokümanında
/// `productIds` dizisi olarak tutulur.
///
/// Web'de (VAPID anahtarı henüz kurulmadığı için, bkz.
/// docs/PUSH_NOTIFICATIONS.md) ya da bildirim izni reddedildiğinde token
/// olmayabilir — bu durumda sessizce hiçbir şey yapılmaz. Favori
/// ekleme/çıkarma akışı bu senkronizasyondan BAĞIMSIZ çalışmaya devam
/// eder (best-effort, asla UI'ı bloklamaz veya hataya düşürmez).
abstract final class FavoriteNotificationSync {
  static const String _collection = 'notification_subscriptions';

  static Future<void> sync(final List<String> favoriteProductIds) async {
    final token = NotificationService.currentToken;
    if (token == null || token.isEmpty) return;

    try {
      final doc = FirebaseFirestore.instance.collection(_collection).doc(token);
      if (favoriteProductIds.isEmpty) {
        await doc.delete();
        return;
      }
      await doc.set({
        'productIds': favoriteProductIds,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('⚠️ Favori bildirim senkronizasyonu başarısız: $e');
    }
  }
}
