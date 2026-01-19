import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// 🔗 Sağlam Spot Deeplink Dinleyicisi
final class DeeplinkListener {
  DeeplinkListener._();

  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _subscription;
  static bool _initialized = false;

  static Future<void> start(final GoRouter router) async {
    if (_initialized) return;
    _initialized = true;

    if (kIsWeb) return;

    // 1️⃣ Kapalıyken gelen link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handleUri(router, initialUri);
    } catch (e) {
      debugPrint('❌ Initial link error: $e');
    }

    // 2️⃣ Açıkken gelen linkler
    _subscription = _appLinks.uriLinkStream.listen(
      (final uri) => _handleUri(router, uri),
      onError: (final error) => debugPrint('❌ Stream error: $error'),
    );
  }

  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }

  static void _handleUri(final GoRouter router, final Uri uri) {
    final String path = uri.path;
    if (path.isEmpty || path == '/') return;

    debugPrint('🔗 Deeplink: $path');

    final currentPath = router.routerDelegate.currentConfiguration.fullPath;
    if (currentPath == path) return;

    try {
      router.go(path); // Adres çubuğu senkronizasyonu için 'go'
    } catch (e) {
      debugPrint('❌ Path error: $path');
    }
  }
}
