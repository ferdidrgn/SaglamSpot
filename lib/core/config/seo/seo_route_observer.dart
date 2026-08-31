import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'seo_routes.dart';

/// Her sayfa geçişinde (bkz. app_router.dart'ın `observers:` listesi)
/// SeoRoutes.update()'i tetikler — sekme başlığı, meta açıklaması ve
/// canonical/OpenGraph URL'i o anki rotaya göre güncellenir.
///
/// Yalnızca web'de anlamlı (SeoService zaten mobilde no-op), bu yüzden
/// diğer platformlarda hiçbir şey yapmaz.
class SeoRouteObserver extends NavigatorObserver {
  @override
  void didPush(
      final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _update(route);
  }

  @override
  void didPop(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _update(previousRoute);
  }

  @override
  void didReplace(
      {final Route<dynamic>? newRoute, final Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _update(newRoute);
  }

  void _update(final Route<dynamic> route) {
    if (!kIsWeb) return;
    final context = navigator?.context;
    if (context == null) return;
    SeoRoutes.update(context, route.settings.name);
  }
}
