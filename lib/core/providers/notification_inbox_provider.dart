import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_inbox_cache.dart';

/// Bildirim gelen kutusu — NotificationInboxCache'in (SharedPreferences)
/// üzerine ince bir Riverpod katmanı. Bell ikonundaki okunmamış rozeti ve
/// NotificationsPage listesi buradan beslenir.
class NotificationInboxNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() => NotificationInboxCache.load();

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
