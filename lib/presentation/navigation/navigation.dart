import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_app_header.dart';

class NavigationScreen extends ConsumerWidget {
  NavigationScreen({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  // 🔥 BURASI
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemSelected(final BuildContext context, final int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey, // 🔥 BURASI
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CustomAppHeader(
            currentIndex: navigationShell.currentIndex,
            onNavigate: (final i) => _onItemSelected(context, i),
            scaffoldKey: _scaffoldKey,
          ),
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text(
                'Sağlam Spot',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
