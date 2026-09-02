import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_inbox_cache.dart';

/// FCM (push) mesajını uygulama arka planda/kapalıyken yakalar. Dart'ın
/// gereksinimi gereği TOP-LEVEL (sınıf dışı) ve `@pragma('vm:entry-point')`
/// ile işaretli olmak ZORUNDA — aksi halde release modda ayrı izole'de
/// çalıştırılamaz. Burada sadece bildirimi yerel gelen kutusuna kaydediyoruz;
/// sistem bildirimini Android/iOS zaten kendi başına gösterir (uygulama
/// foreground'da DEĞİLKEN "notification" tipi FCM mesajları otomatik
/// gösterilir — manuel gösterime sadece foreground'da ihtiyaç var, bkz.
/// NotificationService._onForegroundMessage).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    final RemoteMessage message) async {
  final title = message.notification?.title ?? message.data['title'] ?? '';
  final body = message.notification?.body ?? message.data['body'] ?? '';
  if (title.isEmpty && body.isEmpty) return;
  await NotificationInboxCache.add(AppNotification(
    id: message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
    title: title,
    body: body,
    receivedAt: DateTime.now(),
  ));
}

/// Push (FCM) + uygulama içi bildirim alt yapısı.
///
/// Mimari — bu proje ayrı bir bildirim GÖNDERME sunucusu/Cloud Function'ı
/// İÇERMİYOR. Yayın (broadcast) göndermek için Firebase Console'daki
/// "Messaging" (Cloud Messaging) panelinden `all_users` konusuna (topic)
/// hedefli bir kampanya oluşturmak yeterli — hiç kod yazmadan. Ayrıntılar
/// için bkz. docs/PUSH_NOTIFICATIONS.md.
final class NotificationService {
  NotificationService._();

  static const String _defaultTopic = 'all_users';
  static const String _androidChannelId = 'saglam_spot_default_channel';

  static final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Bu cihazın FCM push token'ı — init() başarıyla tamamlandıktan sonra
  /// dolar. Favori bildirim senkronizasyonu (bkz.
  /// FavoriteNotificationSync) bu değeri Firestore'a yazarak "bu cihaz şu
  /// ürünleri favoriledi" eşleşmesini kurar. Web'de VAPID anahtarı henüz
  /// kurulmadığı için (bkz. docs/PUSH_NOTIFICATIONS.md) ya da bildirim
  /// izni reddedildiğinde null kalabilir — bu durumda favori senkronu
  /// sessizce atlanır.
  static String? currentToken;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Arka plan/kapalı-uygulama mesaj yakalayıcısını runApp'ten önce kaydet
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('🔕 Bildirim izni reddedildi.');
      return;
    }

    await _initLocalNotifications();
    await FirebaseMessaging.instance.subscribeToTopic(_defaultTopic);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTapped);

    // Uygulama, bir bildirime dokunularak (terminated durumdan) açıldıysa
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) await _onNotificationTapped(initialMessage);

    final token = await FirebaseMessaging.instance.getToken();
    currentToken = token;
    debugPrint('📲 FCM cihaz token: $token');
  }

  static Future<void> _initLocalNotifications() async {
    if (kIsWeb) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localPlugin.initialize(
      settings:
          const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    const channel = AndroidNotificationChannel(
      _androidChannelId,
      'Sağlam Spot Bildirimleri',
      description: 'Kampanya, fırsat ve önemli duyurular',
      importance: Importance.high,
    );
    await _localPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Uygulama AÇIKKEN (foreground) gelen mesajlar sistem tarafından
  /// OTOMATİK gösterilmez — bu yüzden burada elle bir yerel bildirim
  /// gösteriyoruz, aynı zamanda gelen kutusuna da ekliyoruz.
  static Future<void> _onForegroundMessage(final RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'] ?? '';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    if (title.isEmpty && body.isEmpty) return;

    await NotificationInboxCache.add(AppNotification(
      id: message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      body: body,
      receivedAt: DateTime.now(),
    ));

    if (!kIsWeb) {
      await _localPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannelId,
            'Sağlam Spot Bildirimleri',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }

  /// Kullanıcı bir bildirime dokunup uygulamayı açtığında (arka plandan
  /// veya kapalıyken) çalışır. Şimdilik sadece okunmuş işaretlemiyoruz —
  /// gelecekte burada belirli bir sayfaya yönlendirme eklenebilir
  /// (örn. mesaj verisinde bir ürün ID'si taşınıyorsa).
  static Future<void> _onNotificationTapped(final RemoteMessage message) async {
    debugPrint('🔔 Bildirime dokunuldu: ${message.messageId}');
  }
}
