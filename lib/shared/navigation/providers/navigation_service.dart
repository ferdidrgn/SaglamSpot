import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter get _router => GoRouter.of(rootNavigatorKey.currentContext!);

  // =========================
  // GLOBAL NAVIGATION
  // =========================

  static void go(final String location) => _router.go(location);

  static void push(final String location) => _router.push(location);

  static void pop() {
    if (_router.canPop()) _router.pop();
  }

  // =========================
  // APP SPECIFIC
  // =========================

  static void goToSearch() => go('/search');
}
