import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Uygulama içinde alınan bir bildirimin kaydı — FCM'den (push) veya
/// uygulama içi bir olaydan gelebilir. Cihazda kalıcı olarak saklanır.
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.read = false,
  });

  AppNotification copyWith({final bool? read}) => AppNotification(
        id: id,
        title: title,
        body: body,
        receivedAt: receivedAt,
        read: read ?? this.read,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'receivedAt': receivedAt.toIso8601String(),
        'read': read,
      };

  factory AppNotification.fromJson(final Map<String, dynamic> json) => AppNotification(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        receivedAt: DateTime.tryParse(json['receivedAt'] as String? ?? '') ?? DateTime.now(),
        read: json['read'] as bool? ?? false,
      );
}

/// Bildirim gelen kutusunun cihazdaki kalıcı deposu. Bir arka plan
/// izole'ünde (FCM background handler) de çağrılabileceği için tamamen
/// SharedPreferences tabanlı, senkron bir bellek önbelleği YOK — her
/// zaman diskten okur/yazar.
final class NotificationInboxCache {
  NotificationInboxCache._();

  static const String _key = 'notification_inbox_v1';
  static const int _maxItems = 100;

  static Future<List<AppNotification>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw
        .map((final s) {
          try {
            return AppNotification.fromJson(
                jsonDecode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<AppNotification>()
        .toList()
      ..sort((final a, final b) => b.receivedAt.compareTo(a.receivedAt));
  }

  static Future<void> _save(final List<AppNotification> items) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = items.take(_maxItems).toList();
    await prefs.setStringList(
        _key, trimmed.map((final n) => jsonEncode(n.toJson())).toList());
  }

  static Future<List<AppNotification>> add(final AppNotification notification) async {
    final items = await load();
    items.insert(0, notification);
    await _save(items);
    return items;
  }

  static Future<List<AppNotification>> markRead(final String id) async {
    final items = await load();
    final updated = items
        .map((final n) => n.id == id ? n.copyWith(read: true) : n)
        .toList();
    await _save(updated);
    return updated;
  }

  static Future<List<AppNotification>> markAllRead() async {
    final items = await load();
    final updated = items.map((final n) => n.copyWith(read: true)).toList();
    await _save(updated);
    return updated;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
