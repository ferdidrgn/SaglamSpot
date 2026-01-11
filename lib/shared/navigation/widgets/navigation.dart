import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/util/responsive_utils.dart';
import '../providers/navigation_service.dart';

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
          headerSliverBuilder: (final _, final __) => [
            _buildModernNavbar(context),
          ],
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
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: context.isDesktop ? _buildCentralBlackBar() : null,
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

  Widget _buildCentralBlackBar() => Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWebNavItem(0, "Ana Sayfa"),
            _buildWebNavItem(1, "Sıfır"),
            _buildWebNavItem(2, "İkinci El"),
            _buildWebNavItem(3, "Hakkımızda"),
            _buildWebNavItem(4, "SSS"),
            _buildSearchMiniButton(),
          ],
        ),
      );

  Widget _buildWebNavItem(final int index, final String label) {
    final isSelected = navigationShell.currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchMiniButton() => GestureDetector(
        onTap: () => NavigationService.goToSearch(),
        child: Container(
          margin: const EdgeInsets.only(left: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.search_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
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
