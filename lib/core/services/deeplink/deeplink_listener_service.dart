import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

final class DeeplinkListener {
  DeeplinkListener._();

  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _sub;

  /// 🚀 App ilk açıldığında + runtime deeplink listener
  static Future<void> start(final GoRouter router) async {
    if (kIsWeb) return; // Web'de gerek yok

    // 1️⃣ Uygulama KAPALIYKEN gelen deeplink
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handleUri(router, initialUri);
    } catch (e) {
      debugPrint('❌ Initial deeplink error: $e');
    }

    // 2️⃣ Uygulama AÇIKKEN gelen deeplink
    _sub = _appLinks.uriLinkStream.listen(
      (final uri) {
        _handleUri(router, uri);
      },
      onError: (final err) {
        debugPrint('❌ Deeplink stream error: $err');
      },
    );
  }

  static void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  static void _handleUri(final GoRouter router, final Uri uri) {
    final path = uri.path;

    debugPrint('🔗 Deeplink received: $path');

    // GoRouter path bazlı navigation
    router.go(path);
  }
}
