import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 🧭 Global Navigation Handler
/// Tüm uygulama genelinde navigasyon işlemlerini yönetir
class NavigationHandler {
  NavigationHandler._();

  static final NavigationHandler instance = NavigationHandler._();

  // ═══════════════════════════════════════════════════════════════
  // PRODUCT NAVIGATION
  // ═══════════════════════════════════════════════════════════════

  /// Ürün detay sayfasına git (nereden geldiğini kaydet)
  static void goToProduct({
    required final BuildContext context,
    required final String productId,
    required final String productSlug,
  }) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final String targetPath =
        '/product/$productSlug-$productId?from=${Uri.encodeComponent(currentPath)}';

    context.go(targetPath);
  }

  // ═══════════════════════════════════════════════════════════════
  // SMART BACK NAVIGATION
  // ═══════════════════════════════════════════════════════════════

  /// Akıllı geri dön (nereden geldiyse oraya)
  static void smartGoBack(final BuildContext context) {
    final state = GoRouterState.of(context);
    final fromRoute = state.uri.queryParameters['from'];

    if (fromRoute != null && fromRoute.isNotEmpty) // Nereden geldiyse oraya dön
      context.go(Uri.decodeComponent(fromRoute));
    else {
      // from bilgisi yoksa Navigator stack kontrol et
      if (Navigator.canPop(context))
        Navigator.pop(context);
      else // Stack boşsa ana sayfaya git
        context.go('/');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ROUTE HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Ana sayfaya git
  static void goToHome(final BuildContext context) => context.go('/');

  /// Arama sayfasına git
  static void goToSearch(final BuildContext context) => context.go('/search');

  /// Yeni ürünler sayfasına git
  static void goToNewProducts(final BuildContext context) => context.go('/new');

  /// Spot ürünler sayfasına git
  static void goToSpotProducts(final BuildContext context) =>
      context.go('/spot');

  // ═══════════════════════════════════════════════════════════════
  // UTILITY
  // ═══════════════════════════════════════════════════════════════

  /// Mevcut route path'i al
  static String getCurrentPath(final BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  /// Geri dönülebilir mi?
  static bool canGoBack(final BuildContext context) {
    final state = GoRouterState.of(context);
    final fromRoute = state.uri.queryParameters['from'];

    return fromRoute != null || Navigator.canPop(context);
  }
}
