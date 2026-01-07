import 'package:flutter/widgets.dart';
import 'seo_routes.dart';

final class SeoRouteObserver extends NavigatorObserver {
  @override
  void didPush(final Route route, final Route? previousRoute) =>_handle(route);

  @override
  void didReplace({final Route? newRoute, final Route? oldRoute}) {
    if (newRoute != null) _handle(newRoute);
  }

  void _handle(final Route route) {
    final name = route.settings.name;
    if (name != null) SeoRoutes.update(name);
  }
}
