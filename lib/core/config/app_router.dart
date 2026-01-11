import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/config/page_transitions.dart';
import 'package:saglamspot/core/config/seo/seo_route_observer.dart';
import '../../features/auth/presentation/provider/auth_provider_notifier.dart';
import '../../features/home/presentation/page/home_page_web.dart';
import '../../features/info/presentation/pages/info_page.dart';
import '../../features/login/presentation/page/login_page.dart';
import '../../features/products/domain/entites/product.dart';
import '../../features/products/presentation/pages/add_product_page.dart';
import '../../features/products/presentation/pages/edit_product_page.dart';
import '../../features/products/presentation/pages/new_products_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/spot_products_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/sss/presentation/pages/sss_page.dart';
import '../../shared/navigation/widgets/navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((final ref) {
  // Auth durumunu izle (Giriş kontrolü için)
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: kIsWeb ? '/' : '/login',
    observers: [SeoRouteObserver()],

    /// 🛡️ GLOBAL REDIRECT (GÜVENLİK DUVARI)
    redirect: (final context, final state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      // 1. Korumalı Rotalar (Admin paneli sayfaları)
      final protectedRoutes = ['/add-product', '/edit-product'];
      final isProtected = protectedRoutes
          .any((final route) => state.matchedLocation.startsWith(route));

      if (!isLoggedIn && isProtected)
        return '/login'; // Giriş yapmamışsa login'e gönder

      // 2. Login olmuş kullanıcıyı tekrar login sayfasına sokma
      if (isLoggedIn && isLoggingIn) return '/';

      return null;
    },

    routes: [
      /// 🔹 LOGIN PAGE
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (final context, final state) => const LoginPage(),
      ),

      /// 🔹 MAIN SHELL (BOTTOM / TOP NAV)
      /// Uygulamanın ana iskeleti, sekmeler arası geçişte durumu korur.
      StatefulShellRoute.indexedStack(
        builder: (final context, final state, final navigationShell) {
          return NavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // 🏠 ANA SAYFA
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                pageBuilder: (final _, final __) =>
                    const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),

          // 🆕 YENİ ÜRÜNLER
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/new',
                name: 'new-products',
                pageBuilder: (final _, final __) =>
                    const NoTransitionPage(child: NewProductsPage()),
              ),
            ],
          ),

          // 🔥 SPOT ÜRÜNLER
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/spot',
                name: 'spot-products',
                pageBuilder: (final _, final __) =>
                    const NoTransitionPage(child: SpotProductsPage()),
              ),
            ],
          ),
        ],
      ),

      /// 🔍 ARAMA SAYFASI
      GoRoute(
        path: '/search',
        name: 'search',
        pageBuilder: (final context, final state) => const NoTransitionPage(
          child: SearchPage(),
        ),
      ),

      /// 🏷️ ÜRÜN DETAY (Dışarıdan derin link ile erişilebilir)
      GoRoute(
        path: '/product/:productId',
        name: 'product-detail',
        builder: (final context, final state) {
          final productId = state.pathParameters['productId'] ?? '';
          return WebProductDetailPage(productId: productId);
        },
      ),

      /// ➕ ÜRÜN EKLEME (Admin)
      GoRoute(
        path: '/add-product',
        name: 'addProduct',
        pageBuilder: (final context, final state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddProductPage(),
          transitionsBuilder: shimmerSlideTransition,
        ),
      ),

      /// ✏️ ÜRÜN DÜZENLEME (Admin)
      GoRoute(
        path: '/edit-product/:productId',
        name: 'editProduct',
        pageBuilder: (final context, final state) {
          final productId = state.pathParameters['productId'] ?? '';
          final product =
              state.extra as Product?; // Eğer objeyi direkt paslıyorsak

          return CustomTransitionPage(
            key: state.pageKey,
            child: EditProductPage(productId: productId, product: product),
            transitionsBuilder: shimmerSlideTransition,
          );
        },
      ),

      /// ℹ️ BİLGİ SAYFALARI (Opsiyonel)
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (final context, final state) => const InfoPage(),
      ),
      GoRoute(
        path: '/sss',
        name: 'sss',
        builder: (final context, final state) => const SSSPage(),
      ),
    ],
  );
});
