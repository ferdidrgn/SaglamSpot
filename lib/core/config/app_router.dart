import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/config/seo/seo_route_observer.dart';
import 'package:saglamspot/features/products/presentation/pages/add_product_page.dart';
import '../../features/auth/presentation/provider/auth_provider_notifier.dart';
import '../../features/home/presentation/page/wrapper/app_home_page.dart';
import '../../features/login/presentation/page/login_page.dart';
import '../../features/products/domain/entites/product.dart';
import '../../features/products/presentation/pages/edit_product_page.dart';
import '../../features/products/presentation/pages/new_products_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/spot_products_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../shared/navigation/providers/navigation_keys.dart';
import '../../shared/navigation/widgets/navigation.dart';
import 'page_transitions.dart';

final appRouterProvider = Provider<GoRouter>((final ref) {
  // Auth durumunu izle
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: NavigationKeys.rootNavigatorKey,
    initialLocation: kIsWeb ? '/' : '/login',
    observers: [SeoRouteObserver()],

    /// 🛡️ GLOBAL REDIRECT (GÜVENLİK DUVARI)
    redirect: (final context, final state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      // 1. Kullanıcı giriş yapmamışsa ve korumalı bir sayfaya gitmeye çalışıyorsa
      final protectedRoutes = ['/add-product', '/edit-product'];
      final isProtected = protectedRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && isProtected) {
        return '/login'; // Hackerları login'e postala
      }

      // 2. Kullanıcı zaten giriş yapmışsa ve tekrar login'e gitmeye çalışıyorsa ana sayfaya gönder
      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null; // Her şey yolundaysa devam et
    },

    routes: [
      /// ... Diğer rotalar (Login, ShellRoute vb. aynen kalıyor) ...

      /// ➕ ÜRÜN EKLEME (Sadece Admin)
      GoRoute(
        path: '/add-product',
        name: 'addProduct',
        pageBuilder: (final context, final state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddProductPage(),
          transitionsBuilder: shimmerSlideTransition,
        ),
      ),

      GoRoute(
        path: '/edit-product/:productId', // ID artık URL'in bir parçası
        name: 'editProduct',
        pageBuilder: (final context, final state) {
          final productId = state.pathParameters['productId'] ?? '';
          // Opsiyonel: Eğer elinizde nesne varsa hala 'extra' ile geçebilirsiniz
          // ama ID her zaman yedek olarak URL'de durur.
          final product = state.extra as Product?;

          return CustomTransitionPage(
            key: state.pageKey,
            child: EditProductPage(productId: productId, product: product),
            transitionsBuilder: shimmerSlideTransition,
          );
        },
      ),
    ],
  );
});
