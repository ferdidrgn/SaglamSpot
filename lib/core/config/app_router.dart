import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/config/seo/seo_route_observer.dart';
import '../../presentation/navigation/navigation.dart';
import '../../presentation/pages/add_product_page.dart';
import '../../presentation/pages/main_pages/home/home_page.dart';
import '../../presentation/pages/main_pages/info_page.dart';
import '../../presentation/pages/main_pages/new_products_page.dart';
import '../../presentation/pages/main_pages/spot_products_page.dart';
import '../../presentation/pages/main_pages/sss_page.dart';
import '../../presentation/pages/search_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// 🧭 Global App Router Provider
final appRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    observers: [
      SeoRouteObserver(),
    ],
    routes: [
      /// 🔹 MAIN SHELL (BOTTOM / TOP NAV)
      StatefulShellRoute.indexedStack(
        builder: (final context, final state, final navigationShell) {
          return NavigationScreen(
            navigationShell: navigationShell,
          );
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
          StatefulShellBranch(
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
          ),
        ],
      ),

      /// ➕ ADD PRODUCT (SHELL DIŞI)
      GoRoute(
        path: '/add-product',
        name: '/add-product',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (final _, final __) => const MaterialPage(
          child: AddProductPage(),
        ),
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
