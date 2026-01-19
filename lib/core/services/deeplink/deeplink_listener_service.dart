import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// 🔗 Sağlam Spot Deeplink / App Link Dinleyicisi
/// - Uygulama kapalıyken gelen linkleri yakalar.
/// - Uygulama açıkken gelen link akışını dinler.
/// - Double init ve bellek sızıntısı korumasına sahiptir.
final class DeeplinkListener {
  DeeplinkListener._();

  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _subscription;
  static bool _isInitialized = false;

  /// 🚀 Uygulama başlatıldığında GoRouter ile entegre edilir.
  static Future<void> init(final GoRouter router) async {
    if (_isInitialized) return;
    _isInitialized = true;

    if (kIsWeb) return; // Web tarafında URL yönetimi tarayıcıya aittir.

    // 1️⃣ Uygulama TAM KAPALIYKEN (Cold Start) gelen linki yakala
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handleNavigation(router, initialUri);
    } catch (e) {
      debugPrint('❌ Sağlam Spot Deeplink Initial Error: $e');
    }

    // 2️⃣ Uygulama AÇIKKEN (Background/Foreground) gelen linkleri dinle
    _subscription = _appLinks.uriLinkStream.listen(
      (final uri) => _handleNavigation(router, uri),
      onError: (final err) =>
          debugPrint('❌ Sağlam Spot Deeplink Stream Error: $err'),
    );
  }

  /// 🎯 Navigasyon ve URL Senkronizasyonu
  static void _handleNavigation(final GoRouter router, final Uri uri) {
    final String path = uri.path;
    if (path.isEmpty || path == '/') return;

    debugPrint('🔗 Deeplink yakalandı: $path');

    // Mevcut konum kontrolü (Sonsuz döngü ve gereksiz render önleyici)
    final currentPath = router.routerDelegate.currentConfiguration.fullPath;
    if (currentPath == path) {
      debugPrint('ℹ️ Zaten hedef sayfadasınız: $path');
      return;
    }

    try {
      // Tarayıcı geçmişi ve URL çubuğu senkronizasyonu için 'go' kullanıyoruz
      router.go(path);
    } catch (e) {
      debugPrint('❌ Geçersiz Deeplink Yolu: $path');
    }
  }

  /// 🧹 Dinleyiciyi durdurur ve kaynakları serbest bırakır (Dispose)
  static void stop() {
    _subscription?.cancel();
    _subscription = null;
    _isInitialized = false;
    debugPrint('🛑 Deeplink dinleyicisi durduruldu.');
  }
}
