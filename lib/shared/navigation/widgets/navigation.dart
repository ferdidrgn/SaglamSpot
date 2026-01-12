import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/util/responsive_utils.dart';

class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onItemSelected(final int index) => navigationShell.goBranch(index,
      initialLocation: index == navigationShell.currentIndex);

  void _goToSearch(final BuildContext context) => context.go('/search');

  @override
  Widget build(final BuildContext context, final WidgetRef ref) => Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (final _, final __) =>
              [_buildModernNavbar(context)],
          body: navigationShell,
        ),
      );

  Widget _buildModernNavbar(final BuildContext context) => SliverAppBar(
        floating: true,
        pinned: true,
        elevation: 0,
        backgroundColor: AppColors.background.withOpacity(0.95),
        centerTitle: false,
        title: const Text(
          "SAĞLAM SPOT",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 18,
          ),
        ),
        actions: [
          _buildTopAction("Ana Sayfa", 0),
          _buildTopAction("Sıfır", 1),
          _buildTopAction("İkinci El", 2),
          _buildTopAction("Hakkımızda", 3),
          _buildTopAction("SSS", 4),
          IconButton(
            onPressed: () => _goToSearch(context),
            icon: const Icon(Icons.search_rounded),
            color: AppColors.textPrimary,
            tooltip: 'Ara',
          ),
          SizedBox(width: context.spacing),
        ],
      );

  Widget _buildTopAction(final String label, final int index) => TextButton(
        onPressed: () => _onItemSelected(index),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
