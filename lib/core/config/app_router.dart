import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/navigation/navigation.dart';
import '../../presentation/pages/main_pages/home/home_page.dart';
import '../../presentation/pages/main_pages/info_page.dart';
import '../../presentation/pages/main_pages/new_products_page.dart';
import '../../presentation/pages/main_pages/spot_products_page.dart';
import '../../presentation/pages/main_pages/sss_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (final context, final state, final navigationShell) {
        return NavigationScreen(navigationShell: navigationShell);
      },
      branches: [
        // 0️⃣ Ana Sayfa
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (final context, final state) =>
                  const NoTransitionPage(child: HomePage()),
            ),
          ],
        ),

        // 1️⃣ Sıfır Ürünler
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/new',
              pageBuilder: (final context, final state) =>
                  const NoTransitionPage(child: NewProductsPage()),
            ),
          ],
        ),

        // 2️⃣ Spot Ürünler
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/spot',
              pageBuilder: (final context, final state) =>
                  const NoTransitionPage(child: SpotProductsPage()),
            ),
          ],
        ),

        // 3️⃣ Hakkımızda
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/about',
              pageBuilder: (final context, final state) =>
                  const NoTransitionPage(child: InfoPage()),
            ),
          ],
        ),

        // 4️⃣ SSS
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/sss',
              pageBuilder: (final context, final state) =>
                  const NoTransitionPage(child: SSSPage()),
            ),
          ],
        ),
      ],
    ),
  ],
);
