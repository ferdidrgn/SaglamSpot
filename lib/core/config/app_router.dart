import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/config/page_transitions.dart';
import 'package:saglamspot/core/config/seo/seo_route_observer.dart';
import 'package:saglamspot/features/products/presentation/pages/product_detail_page.dart';
import '../../features/auth/presentation/provider/auth_provider_notifier.dart';
import '../../features/home/presentation/page/wrapper/app_home_page.dart';
import '../../features/login/presentation/page/login_page.dart';
import '../../features/products/presentation/pages/new_products_page.dart';
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

    /// 🛡️ SENİN ORİJİNAL REDIRECT MANTIĞIN (Aynen korundu)
    redirect: (final context, final state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      // Admin sayfaları koruması
      final adminRoutes = ['/add-product', '/edit-product'];
      final isAdminPage =
          adminRoutes.any((final r) => state.matchedLocation.startsWith(r));

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
      // LOGIN SAYFASI
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
          // 0: ANASAYFA (Focal Transition)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                pageBuilder: (final context, final state) =>
                    const CustomTransitionPage(
                  child: AppHomePage(),
                  transitionsBuilder: focalTransition,
                  transitionDuration: Duration(milliseconds: 600),
                ),
              ),
            ],
          ),
          // 1: SIFIR ÜRÜNLER (Curtain Transition)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/new',
                name: 'new-products',
                pageBuilder: (final context, final state) =>
                    const CustomTransitionPage(
                  child: NewProductsPage(),
                  transitionsBuilder: curtainTransition,
                ),
              ),
            ],
          ),
          // 2: İKİNCİ EL (Scroll Slide Transition)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/spot',
                name: 'spot-products',
                pageBuilder: (final context, final state) =>
                    const CustomTransitionPage(
                  child: SpotProductsPage(),
                  transitionsBuilder: scrollSlideTransition,
                ),
              ),
            ],
          ),
          /*// 3: HAKKINDA (Cinematic Fade)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/about',
                name: 'about',
                pageBuilder: (final context, final state) =>
                    const CustomTransitionPage(
                  child: AboutPage(),
                  transitionsBuilder: cinematicFadeTransition,
                ),
              ),
            ],
          ),
          // 4: SSS (Spiral Transition)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sss',
                name: 'sss',
                pageBuilder: (final context, final state) =>
                    const CustomTransitionPage(
                  child: SSSPage(),
                  transitionsBuilder: spiralTransition,
                ),
              ),
            ],
          ),*/
        ],
      ),

      /// 🔍 ARAMA (Shimmer Slide Transition)
      GoRoute(
        path: '/search',
        name: 'search',
        pageBuilder: (final context, final state) => const CustomTransitionPage(
          child: SearchPage(),
          transitionsBuilder: shimmerSlideTransition,
        ),
      ),

      GoRoute(
        path: '/product/:id',
        name: 'product',
        pageBuilder: (final context, final state) {
          final String productId = state.pathParameters['id'] ?? '';

          return CustomTransitionPage(
            key: state.pageKey,
            child: WebProductDetailPage(productId: productId),
            transitionsBuilder: shimmerSlideTransition,
          );
        },
      ),
    ],
  );
});
