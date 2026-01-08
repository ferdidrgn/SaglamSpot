import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/config/seo/seo_route_observer.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/spot_products_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/home/presentation/page/home_page_web.dart';
import '../../features/info/presentation/pages/info_page.dart';
import '../../features/sss/presentation/pages/sss_page.dart';
import '../../features/products/presentation/pages/new_products_page.dart';
import '../../shared/navigation/navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// 🧭 Global App Router Provider
final appRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    observers: [SeoRouteObserver()],
    routes: [
      /// 🔹 MAIN SHELL (BOTTOM / TOP NAV)
      StatefulShellRoute.indexedStack(
        builder: (final context, final state, final navigationShell) {
          return NavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // 🏠 HOME
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: '/',
                pageBuilder: (final _, final __) =>
                    const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),

          // 🆕 NEW PRODUCTS
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/new',
                name: '/new',
                pageBuilder: (final _, final __) =>
                    const NoTransitionPage(child: NewProductsPage()),
              ),
            ],
          ),

          // 🔥 SPOT PRODUCTS
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/spot',
                name: '/spot',
                pageBuilder: (final _, final __) =>
                    const NoTransitionPage(child: SpotProductsPage()),
              ),
            ],
          ),

          // ℹ️ ABOUT
          /*StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/about',
                name: '/about',
                pageBuilder: (final _, final __) =>
                    const NoTransitionPage(child: InfoPage()),
              ),
            ],
          ),

          // ❓ FAQ / SSS
         StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sss',
                name: '/sss',
                pageBuilder: (final _, final __) =>
                    const NoTransitionPage(child: SSSPage()),
              ),
            ],
          ),*/
        ],
      ),

      /// 🏷️ PRODUCT DETAIL PAGE (Parametrik Rota)
      GoRoute(
        path: '/product/:productId',
        name: 'product-detail',
        builder: (final context, final state) {
          // URL'den productId'yi yakalıyoruz
          final productId = state.pathParameters['productId'];
          //id yi pasladık
          return WebProductDetailPage(productId: productId ?? '');
        },
      ),

      // 🔍 SEARCH
      GoRoute(
        path: '/search',
        name: '/search',
        pageBuilder: (final _, final __) =>
            const NoTransitionPage(child: SearchPage()),
      ),
    ],
  );
});
