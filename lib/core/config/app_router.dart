import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb, ChangeNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/config/page_transitions.dart';
import 'package:saglamspot/core/config/seo/seo_route_observer.dart';
import 'package:saglamspot/features/products/presentation/pages/product_detail_page.dart';
import 'package:saglamspot/shared/navigation/providers/navigation_keys.dart';
import '../../features/auth/presentation/page/login_page.dart';
import '../../features/auth/presentation/provider/auth_provider_notifier.dart';
import '../../features/home/presentation/page/wrapper/app_home_page.dart';
import '../../features/products/presentation/pages/new_products_page.dart';
import '../../features/products/presentation/pages/spot_products_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../shared/navigation/widgets/navigation.dart';

final appRouterProvider = Provider<GoRouter>((final ref) {
  // ChangeNotifier'dan türetilmiş Listenable — GoRouter bunu kabul eder
  final routerNotifier = _AuthRouterNotifier(ref);

  final router = GoRouter(
    navigatorKey: NavigationKeys.rootNavigatorKey,
    initialLocation: kIsWeb ? '/' : '/login',
    // refreshListenable bir Listenable bekler — _AuthRouterNotifier bunu sağlar
    refreshListenable: routerNotifier,
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      SeoRouteObserver(),
    ],
    redirect: (final context, final state) {
      final authState = ref.read(authProvider);

      // Yükleniyor — yönlendirme yapma
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value != null;
      final isOnLoginPage = state.uri.path == '/login';

      // WEB: giriş zorunlu değil
      if (kIsWeb) {
        if (isLoggedIn && isOnLoginPage) return '/';
        return null;
      }

      // MOBİL: giriş zorunlu
      if (!isLoggedIn) return isOnLoginPage ? null : '/login';
      if (isLoggedIn && isOnLoginPage) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (final context, final state) => const CustomTransitionPage(
          child: LoginPage(),
          transitionsBuilder: focalTransition,
          transitionDuration: Duration(milliseconds: 600),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (final context, final state, final navigationShell) =>
            NavigationScreen(navigationShell: navigationShell),
        branches: [
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
        ],
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        pageBuilder: (final context, final state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SearchPage(),
          transitionsBuilder: shimmerSlideTransition,
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ),
      GoRoute(
        path: '/product/:slugWithId',
        name: 'productDetail',
        pageBuilder: (final context, final state) {
          final String fullParam = state.pathParameters['slugWithId']!;
          final String productId = fullParam.split('-').last;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProductDetailPage(productId: productId),
            transitionsBuilder: shimmerSlideTransition,
            transitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
    ],
  );

  // Provider dispose olunca notifier'ı temizle
  ref.onDispose(routerNotifier.dispose);

  return router;
});

/// GoRouter'ın `refreshListenable` parametresi `Listenable` bekler.
/// `ChangeNotifier`, `Listenable`'ı implement eder — bu doğru tür.
class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(final Ref ref) {
    // Auth state değiştiğinde GoRouter'ı redirect için tetikle
    ref.listen<AsyncValue>(
      authProvider,
      (final previous, final next) {
        // Loading bitti veya kullanıcı değişti → router'ı yenile
        final prevLoading = previous?.isLoading ?? true;
        final nextLoading = next.isLoading;
        final prevUser = previous?.value;
        final nextUser = next.value;

        if (prevLoading != nextLoading || prevUser != nextUser) {
          notifyListeners();
        }
      },
    );
  }
}
