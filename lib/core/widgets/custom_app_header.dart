import 'package:flutter/material.dart';
import '../../presentation/pages/search_page.dart';
import '../theme/app_colors.dart';
import 'custom_search.dart';

class CustomAppHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomAppHeader({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.3)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // Logo
              _buildLogo(),
              const Spacer(),
              // Navigation Items
              _buildDesktopNavigation(),
              const Spacer(),
              // User Actions
              _buildUserActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onItemSelected(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.weekend_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'MobilyaEvim',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavigation() {
    const navItems = [
      'Ana Sayfa',
      'Sıfır Ürünler',
      'Spot Ürünler',
      'Hakkımızda',
      'SSS'
    ];

    return Row(
      children: List.generate(navItems.length, (final index) {
        final isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _NavItem(
              title: navItems[index],
              isSelected: isSelected,
              onTap: () => onItemSelected(index)),
        );
      }),
    );
  }

  Widget _buildUserActions(final BuildContext context) {
    return Row(
      children: [
        _buildSearchBar(context),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.search_outlined,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (final context) => const SearchPage()),
            );
          },
          badge: false,
        ),
        const SizedBox(width: 16),
        Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.person_outline,
                color: AppColors.primary, size: 20)),
      ],
    );
  }

  Widget _buildSearchBar(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (final context) => const SearchPage()),
          );
        },
        child: Container(
          width: 200,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
          child: const Row(
            children: [
              Icon(Icons.search_rounded,
                  size: 20, color: AppColors.textTertiary),
              SizedBox(width: 8),
              Text('Ürün ara...',
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 14))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required final IconData icon,
    required final VoidCallback onPressed,
    required final bool badge,
    final int badgeCount = 0,
  }) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
          child: IconButton(
              icon: Icon(icon, size: 20),
              onPressed: onPressed,
              color: AppColors.textSecondary,
              padding: EdgeInsets.zero),
        ),
        if (badge && badgeCount > 0)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2)),
              child: Center(
                child: Text(badgeCount.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: AppColors.primary.withOpacity(0.3))
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15),
          ),
        ),
      ),
    );
  }
}
