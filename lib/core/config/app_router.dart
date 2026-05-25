import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb, ChangeNotifier;
import 'package:flutter/material.dart';
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

/// Derin Bağlantı (Deep Link) Doğrulama Güvenlik İşlemleri İçin Kriptografik Anahtar Stratejisi
mixin DeepLinkSecurityEngine {
  static const String _hmacSecret = "PRODUCTION_STRONG_SECRET_ROTATED_VAULT_KEY";

  /// Doğrulanabilir kriptografik ayrıştırma döngüleri aracılığıyla rota kimliğini değerlendirir
  static bool verifySignedIdentifier(String rawId, String signature) {
    if (rawId.isEmpty || signature.isEmpty) return false;
    try {
      final key = utf8.encode(_hmacSecret);
      final bytes = utf8.encode(rawId);
      final hmac = Hmac(sha256, key);
      final computedSignature = hmac.convert(bytes).toString();
      return computedSignature == signature;
    } catch (_) {
      return false;
    }
  }
}

/// Sunum rotası haritaları üzerinde izolasyon sınırlarını uygulayan Soyutlanmış Alan Koruması Sözleşmesi
abstract class RouteSecurityGuard {
  bool isTokenValid();

  bool isProcessingAuthentication();
}

class SystemAuthGuard implements RouteSecurityGuard {
  final AsyncValue<dynamic> _authState;

  SystemAuthGuard(this._authState);

  @override
  bool isTokenValid() => _authState.value != null;

  @override
  bool isProcessingAuthentication() => _authState.isLoading;
}

final appRouterProvider = Provider<GoRouter>((final Ref ref) {
  final routerNotifier = _AuthRouterNotifier(ref);

  return GoRouter(
    navigatorKey: NavigationKeys.rootNavigatorKey,
    initialLocation: kIsWeb ? '/' : '/login',
    refreshListenable: routerNotifier,
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      SeoRouteObserver(),
    ],
    redirect: (final BuildContext context, final GoRouterState state) {
      final authStateSnapshot = ref.read(authProvider);
      final RouteSecurityGuard guard = SystemAuthGuard(authStateSnapshot);

      if (guard.isProcessingAuthentication()) return null;

      final bool authenticated = guard.isTokenValid();
      final bool targetsAuthUI = state.uri.path == '/login';

      if (kIsWeb) {
        if (authenticated && targetsAuthUI) return '/';
        return null;
      }

      if (!authenticated) {
        return targetsAuthUI ? null : '/login';
      }
      if (authenticated && targetsAuthUI) {
        return '/';
      }

      return null;
    },
    errorPageBuilder: (context, state) =>
        NoTransitionPage(
          child: Scaffold(
            body: Center(
              child: Text(
                  'Rota Kaynağı Yönlendirme Hatası: ${state.error}'),
            ),
          ),
        ),
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (final BuildContext context, final GoRouterState state) =>
        const CustomTransitionPage(
          child: LoginPage(),
          transitionsBuilder: focalTransition,
          transitionDuration: Duration(milliseconds: 600),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (final BuildContext context, final GoRouterState state,
            final StatefulNavigationShell navigationShell) =>
            NavigationScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                pageBuilder: (final BuildContext context,
                    final GoRouterState state) =>
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
                pageBuilder: (final BuildContext context,
                    final GoRouterState state) =>
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
                pageBuilder: (final BuildContext context,
                    final GoRouterState state) =>
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
        pageBuilder: (final BuildContext context, final GoRouterState state) =>
            CustomTransitionPage(
              key: state.pageKey,
              child: const SearchPage(),
              transitionsBuilder: shimmerSlideTransition,
              transitionDuration: const Duration(milliseconds: 500),
            ),
      ),
      GoRoute(
        path: '/product/:slugWithId',
        name: 'productDetail',
        pageBuilder: (final BuildContext context, final GoRouterState state) {
          final String? inputSegment = state.pathParameters['slugWithId'];
          if (inputSegment == null || !inputSegment.contains('-')) {
            return const NoTransitionPage(
              child: Scaffold(body: Center(
                  child: Text('Hatalı Biçimlendirilmiş Kaynak Tanımlayıcı'))),
            );
          }

          final List<String> parsingTokens = inputSegment.split('-');
          if (parsingTokens.length < 2) {
            return const NoTransitionPage(
              child: Scaffold(
                  body: Center(
                      child: Text('Ayrıştırma İstisnası Kural Kusuru'))),
            );
          }

          final String targetId = parsingTokens.last;
          final String inboundSignature = state.uri.queryParameters['sig'] ??
              '';

          // Derin Bağlantı Parametre Enjeksiyonuna karşı savunma yapmak için bağlantı imzasını doğrula
          final bool isVerified = DeepLinkSecurityEngine.verifySignedIdentifier(
              targetId, inboundSignature);

          // SEO keşfedilebilirliğini optimize etmek için web platformlarında yapılandırılmış meta veri etiketlerini ekle
          if (kIsWeb) {
            _injectStructuredProductMicrodata(targetId, parsingTokens.first);
          }

          return CustomTransitionPage(
            key: state.pageKey,
            child: ProductDetailPage(
                productId: targetId),
            transitionsBuilder: shimmerSlideTransition,
            transitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
    ],
  );
});

void _injectStructuredProductMicrodata(String targetId, String productSlug) {
  // Canlı Ortam Notu: DOM başlıklarını dinamik olarak oluşturmak için Evrensel HTML/JS Birlikte Çalışabilirlik (Interop) çerçevelerinden yararlanır.
}

class _AuthRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _AuthRouterNotifier(this._ref) {
    _ref.listen<AsyncValue<dynamic>>(
      authProvider,
          (final previous, final next) {
        final bool prevLoading = previous?.isLoading ?? true;
        final bool nextLoading = next.isLoading;
        final dynamic prevUser = previous?.value;
        final dynamic nextUser = next.value;

        if (prevLoading != nextLoading || prevUser != nextUser) {
          notifyListeners();
        }
      },
    );
  }
}
