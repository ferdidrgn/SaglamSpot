import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/config/page_transitions.dart';
import 'package:saglamspot/core/config/seo/seo_route_observer.dart';
import '../../features/auth/presentation/provider/auth_provider_notifier.dart';

// ÖNEMLİ: Wrapper üzerinden çekiyoruz
import '../../features/home/presentation/page/wrapper/app_home_page.dart';
import '../../features/login/presentation/page/login_page.dart';
import '../../features/products/domain/entites/product.dart';
import '../../features/products/presentation/pages/add_product_page.dart';
import '../../features/products/presentation/pages/edit_product_page.dart';
import '../../features/products/presentation/pages/new_products_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/spot_products_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../shared/navigation/widgets/navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((final ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    // Web için '/' başlangıç noktası, mobil için '/login'
    initialLocation: kIsWeb ? '/' : '/login',
    observers: [SeoRouteObserver()],

    /// 🛡️ REDIRECT MANTIĞI (Bembeyaz ekranı çözen kısım)
    redirect: (final context, final state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      // Admin sayfaları koruması
      final adminRoutes = ['/add-product', '/edit-product'];
      final isAdminPage =
          adminRoutes.any((r) => state.matchedLocation.startsWith(r));

      // 1. Web'de herkes gezebilir, sadece admin sayfaları için login gerekir
      if (kIsWeb) {
        if (!isLoggedIn && isAdminPage) return '/login';
        return null;
      }

      // 2. Mobil için katı kurallar
      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (final context, final state) => const LoginPage(),
      ),

      /// 🔹 MAIN SHELL (NAVIGATION SCREEN)
      StatefulShellRoute.indexedStack(
        builder: (final context, final state, final navigationShell) {
          return NavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                // Doğru platform sayfasını yükleyen wrapper
                pageBuilder: (final context, final state) =>
                    const NoTransitionPage(child: AppHomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/new',
                name: 'new-products',
                pageBuilder: (final context, final state) =>
                    const NoTransitionPage(child: NewProductsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/spot',
                name: 'spot-products',
                pageBuilder: (final context, final state) =>
                    const NoTransitionPage(child: SpotProductsPage()),
              ),
            ],
          ),
        ],
      ),

      /// 🏷️ ÜRÜN DETAY (Showroom odaklı)
      GoRoute(
        path: '/product/:productId',
        name: 'product-detail',
        builder: (final context, final state) {
          final productId = state.pathParameters['productId'] ?? '';
          return WebProductDetailPage(productId: productId);
        },
      ),

      /// 🔍 ARAMA
      GoRoute(
        path: '/search',
        name: 'search',
        pageBuilder: (final context, final state) =>
            const NoTransitionPage(child: SearchPage()),
      ),
    ],
  );
});
