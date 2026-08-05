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
import '../../features/info/presentation/pages/about_page.dart';
import '../../features/products/presentation/pages/new_products_page.dart';
import '../../features/products/presentation/pages/spot_products_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/sss/presentation/pages/sss_page.dart';
import '../../shared/navigation/widgets/navigation.dart';

mixin DeepLinkSecurityEngine {
  // Canlı üretim ortamında bu anahtar CI/CD süreçlerinden derleme anında (compile-time flag) enjekte edilmelidir
  static const String _hmacSecret =
      "SAGLAM_SPOT_CYBER_SECURE_FURNITURE_TOKEN_2026";

  /// Gelen link imzasını sabit zamanlı (constant-time) algoritma döngüsü ile güvenli bir şekilde doğrular
  static bool verifySignedIdentifier(
      final String rawId, final String signature) {
    if (rawId.isEmpty || signature.isEmpty) return false;
    try {
      final List<int> keyBytes = utf8.encode(_hmacSecret);
      final List<int> dataBytes = utf8.encode(rawId);
      final Hmac hmac = Hmac(sha256, keyBytes);
      final String calculatedSignature = hmac.convert(dataBytes).toString();

      return _fixedTimeStringEquals(calculatedSignature, signature);
    } catch (_) {
      return false;
    }
  }

  /// Karakterleri bit düzeyinde XOR işlemine sokarak zamanlama analizi (side-channel timing) açıklarını engeller
  static bool _fixedTimeStringEquals(final String a, final String b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}

final appRouterProvider = Provider<GoRouter>((final Ref ref) {
  final routerNotifier = _AuthRouterNotifier(ref);

  return GoRouter(
    navigatorKey: NavigationKeys.rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: routerNotifier,
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      SeoRouteObserver(),
    ],
    redirect: (final BuildContext context, final GoRouterState state) {
      final AsyncValue<dynamic> authState = ref.read(authProvider);
      if (authState.isLoading) return null;

      final bool isLoggedIn = authState.value != null;
      final String currentPath = state.uri.path;
      final bool isOnLoginPage = currentPath == '/login';

      // Web platformunda halka açık mobilya listelerinin taranabilmesi için yönlendirme bypass mekanizması
      if (kIsWeb) {
        if (isLoggedIn && isOnLoginPage) return '/';
        return null;
      }

      // Kullanıcı oturum açmamışsa geldiği derin link verisini kaybetmeden güvenli parametre olarak taşı
      if (!isLoggedIn) {
        if (isOnLoginPage) return null;
        return '/login?redirect=${Uri.encodeComponent(state.uri.toString())}';
      }

      if (isOnLoginPage) {
        final String? prospectiveTarget = state.uri.queryParameters['redirect'];
        if (prospectiveTarget != null && prospectiveTarget.isNotEmpty) {
          final String decodedTarget = Uri.decodeComponent(prospectiveTarget);
          // Açık yönlendirme saldırılarını engellemek için adresin sadece iç rota olduğunu doğrula
          if (decodedTarget.startsWith('/') && !decodedTarget.contains('//')) {
            return decodedTarget;
          }
        }
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (final context, final state) => const CustomTransitionPage(
          child: LoginPage(),
          transitionsBuilder: focalTransition,
          transitionDuration: Duration(milliseconds: 400),
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
                  transitionDuration: Duration(milliseconds: 450),
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
                  transitionDuration: Duration(milliseconds: 400),
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
                  transitionDuration: Duration(milliseconds: 400),
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
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        pageBuilder: (final context, final state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AboutPage(),
          transitionsBuilder: focalTransition,
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ),
      GoRoute(
        path: '/sss',
        name: 'sss',
        pageBuilder: (final context, final state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SSSPage(),
          transitionsBuilder: focalTransition,
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ),
      GoRoute(
        path: '/product/:slugWithId',
        name: 'productDetail',
        pageBuilder: (final BuildContext context, final GoRouterState state) {
          final String rawParam = state.pathParameters['slugWithId'] ?? '';
          final String fullParam = Uri.decodeComponent(rawParam);

          if (!fullParam.contains('-')) {
            return const NoTransitionPage(
              child:
                  ArchitecturalErrorScreen(message: 'GEÇERSİZ BAĞLANTI YAPISI'),
            );
          }

          final List<String> parts = fullParam.split('-');
          final String productId = parts.last;
          final String inboundSig = state.uri.queryParameters['sig'] ?? '';

          final bool isSecure = DeepLinkSecurityEngine.verifySignedIdentifier(
            productId,
            inboundSig,
          );

          // Mobil cihazlarda imzasız derin linklerin içeriğe erişmesini engelle
          if (!isSecure && !kIsWeb) {
            return const NoTransitionPage(
              child: ArchitecturalErrorScreen(
                  message: 'GÜVENLİK DOĞRULAMASI BAŞARISIZ'),
            );
          }

          return CustomTransitionPage(
            key: state.pageKey,
            child: ProductDetailPage(
              productId: productId,
            ),
            transitionsBuilder: shimmerSlideTransition,
            transitionDuration: const Duration(milliseconds: 450),
          );
        },
      ),
    ],
  );
});

class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(final Ref ref) {
    ref.listen<AsyncValue<dynamic>>(
      authProvider,
      (final previous, final next) {
        if ((previous?.isLoading ?? true) != next.isLoading ||
            previous?.value != next.value) {
          notifyListeners();
        }
      },
    );
  }
}

class ArchitecturalErrorScreen extends StatelessWidget {
  final String message;

  const ArchitecturalErrorScreen({super.key, required this.message});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
