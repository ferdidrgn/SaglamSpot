import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/config/seo/seo_route_observer.dart';
import 'package:saglamspot/features/products/presentation/pages/add_product_page.dart';
import '../../features/home/presentation/page/wrapper/app_home_page.dart';
import '../../features/login/presentation/page/login_page.dart';
import '../../features/products/presentation/pages/new_products_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/spot_products_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../shared/navigation/providers/navigation_keys.dart';
import '../../shared/navigation/widgets/navigation.dart';
import 'page_transitions.dart';

final appRouterProvider = Provider<GoRouter>((final ref) {
  return GoRouter(
    navigatorKey: NavigationKeys.rootNavigatorKey,
    // MOBİLDE isen '/login' sayfasından başla, WEB'de isen '/' ana sayfadan.
    initialLocation: kIsWeb ? '/' : '/login',
    observers: [SeoRouteObserver()],
    routes: [
      /// 🚪 LOGIN PAGE (Mobil için zorunlu başlangıç)
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (final context, final state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginPage(),
          transitionsBuilder: focalTransition, // Rüya gibi netleşme efekti
          transitionDuration: const Duration(milliseconds: 800),
        ),
      ),

      /// 🔹 MAIN SHELL (BOTTOM / TOP NAV)
      StatefulShellRoute.indexedStack(
        builder: (final context, final state, final navigationShell) {
          return NavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // 🏠 HOME
          StatefulShellBranch(
            navigatorKey: NavigationKeys.homeShellKey,
            routes: [
              GoRoute(
                path: '/',
                name: '/',
                pageBuilder: (final context, final state) =>
                    CustomTransitionPage(
                  key: state.pageKey,
                  child: const AppHomePage(),
                  transitionsBuilder: curtainTransition,
                  // Sahne açılış efekti
                  transitionDuration: const Duration(milliseconds: 600),
                ),
              ),
            ],
          ),

          // 🆕 NEW PRODUCTS
          StatefulShellBranch(
            navigatorKey: NavigationKeys.newProductsShellKey,
            routes: [
              GoRoute(
                path: '/new',
                name: '/new',
                pageBuilder: (final context, final state) =>
                    CustomTransitionPage(
                  key: state.pageKey,
                  child: const NewProductsPage(),
                  transitionsBuilder: scrollSlideTransition, // Parşömen kayması
                ),
              ),
            ],
          ),

          // 🔥 SPOT PRODUCTS
          StatefulShellBranch(
            navigatorKey: NavigationKeys.spotProductsShellKey,
            routes: [
              GoRoute(
                path: '/spot',
                name: '/spot',
                pageBuilder: (final context, final state) =>
                    CustomTransitionPage(
                  key: state.pageKey,
                  child: const SpotProductsPage(),
                  transitionsBuilder: spiralTransition, // Mistik sarmal
                ),
              ),
            ],
          ),
        ],
      ),

      /// 🏷️ PRODUCT DETAIL PAGE
      GoRoute(
        path: '/product/:productId',
        name: 'product-detail',
        pageBuilder: (final context, final state) {
          final productId = state.pathParameters['productId'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: WebProductDetailPage(productId: productId),
            transitionsBuilder: slideTransition, // Klasik sağdan sola kayma
            transitionDuration: const Duration(milliseconds: 400),
          );
        },
      ),

      /// 🔍 SEARCH
      GoRoute(
        path: '/search',
        name: '/search',
        pageBuilder: (final context, final state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SearchPage(),
          transitionsBuilder: shimmerSlideTransition, // Işık süzmesi efekti
        ),
      ),

      /// 🔍 SEARCH
      GoRoute(
        path: '/add-product',
        name: '/addProduct',
        pageBuilder: (final context, final state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddProductPage(),
          transitionsBuilder: shimmerSlideTransition, // Işık süzmesi efekti
        ),
      ),
    ],
  );
});

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
