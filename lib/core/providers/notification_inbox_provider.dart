import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_provider.dart';
import '../services/notification_inbox_cache.dart';

/// Bildirim gelen kutusu — NotificationInboxCache'in (SharedPreferences)
/// üzerine ince bir Riverpod katmanı. Bell ikonundaki okunmamış rozeti ve
/// NotificationsPage listesi buradan beslenir.
class NotificationInboxNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final local = await NotificationInboxCache.load();
    // Cihaz henüz almadığı (örn. bildirim izni yeni verilmiş, push o an
    // ulaşamamış) yayın bildirimlerini arka planda senkronla — ilk çizimi
    // BEKLETMEZ, tamamlanınca state'i günceller (bkz. _syncBroadcastFeed).
    unawaited(_syncBroadcastFeed());
    return local;
  }

  /// `notification_broadcasts` koleksiyonundaki (bkz.
  /// functions/index.js > onProductCreated) en yeni kayıtları çekip yerel
  /// gelen kutusuyla birleştirir. Ağ/izin hatası SESSİZCE yutulur — bildirim
  /// geçmişi olmadan da uygulama normal çalışmaya devam etmeli.
  Future<void> _syncBroadcastFeed() async {
    try {
      final snap = await ref
          .read(firestoreProvider)
          .collection('notification_broadcasts')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();
      if (snap.docs.isEmpty) return;

      final remote = snap.docs
          .map((final doc) {
            final data = doc.data();
            final title = data['title'] as String? ?? '';
            final body = data['body'] as String? ?? '';
            if (title.isEmpty && body.isEmpty) return null;
            final createdAt = data['createdAt'];
            return AppNotification(
              id: 'broadcast_${doc.id}',
              title: title,
              body: body,
              receivedAt: createdAt is Timestamp
                  ? createdAt.toDate()
                  : DateTime.now(),
            );
          })
          .whereType<AppNotification>()
          .toList();

      final merged = await NotificationInboxCache.mergeRemote(remote);
      state = AsyncData(merged);
    } catch (e) {
      debugPrint('🔔 Bildirim yayın akışı senkronu başarısız: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await NotificationInboxCache.load());
  }

  Future<void> add(final AppNotification notification) async {
    final updated = await NotificationInboxCache.add(notification);
    state = AsyncData(updated);
  }

  Future<void> markRead(final String id) async {
    final updated = await NotificationInboxCache.markRead(id);
    state = AsyncData(updated);
  }

  Future<void> markAllRead() async {
    final updated = await NotificationInboxCache.markAllRead();
    state = AsyncData(updated);
  }

  Future<void> clear() async {
    await NotificationInboxCache.clear();
    state = const AsyncData([]);
  }
}

final notificationInboxProvider =
    AsyncNotifierProvider<NotificationInboxNotifier, List<AppNotification>>(
        NotificationInboxNotifier.new);

final unreadNotificationCountProvider = Provider<int>((final ref) {
  final items = ref.watch(notificationInboxProvider).value ?? const [];
  return items.where((final n) => !n.read).length;
});
