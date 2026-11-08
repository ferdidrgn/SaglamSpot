import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_design_tokens.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/design_system/adaptive_backdrop_blur.dart';
import '../../../features/cart/presentation/providers/cart_provider.dart';
import '../../../features/products/presentation/providers/favorites_provider.dart';

/// Soft, floating bottom nav — thin outline icons, brand-tinted active
/// pill, project colors only. Destinations: Home / Discover / Cart /
/// Favorites / Profile (matches the storeflow reference while staying
/// on Sağlam Spot routes).
class MobileBottomNav extends ConsumerWidget {
  const MobileBottomNav({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final int favoritesCount = ref.watch(favoritesCountProvider);
    final int cartCount = ref.watch(cartItemCountProvider);

    final items = <_NavItemData>[
      _NavItemData(
        path: '/',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: context.l10n.home,
      ),
      _NavItemData(
        path: '/discover',
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: context.l10n.navDiscover,
      ),
      _NavItemData(
        path: '/cart',
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart_rounded,
        label: context.l10n.navCart,
        badgeCount: cartCount,
      ),
      _NavItemData(
        path: '/favorites',
        icon: Icons.favorite_border_rounded,
        activeIcon: Icons.favorite_rounded,
        label: context.l10n.navFavorites,
        badgeCount: favoritesCount,
      ),
      _NavItemData(
        path: '/settings',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: context.l10n.navProfile,
      ),
    ];

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: AdaptiveBackdropBlur(
          sigma: context.glass.blurLg,
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.mobileSurface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.mobileBorder.withValues(alpha: 0.55),
              ),
              boxShadow: AppShadows.level3(AppColors.mobilePrimary),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: [
                for (final item in items)
                  Expanded(
                    child: _NavButton(
                      item: item,
                      isActive: _isActive(currentPath, item.path),
                      onTap: () {
                        if (_isActive(currentPath, item.path)) {
                          return;
                        }
                        HapticFeedback.selectionClick();
                        context.go(item.path);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isActive(final String currentPath, final String itemPath) {
    if (itemPath == '/') {
      return currentPath == '/';
    }
    return currentPath.startsWith(itemPath);
  }
}

class _NavItemData {
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badgeCount;

  const _NavItemData({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount = 0,
  });
}

class _NavButton extends StatelessWidget {
  final _NavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    final Color color =
        isActive ? AppColors.mobileAccent : AppColors.mobileMutedDark;

    return Semantics(
      button: true,
      selected: isActive,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.standard,
          margin: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm, horizontal: 2),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.mobileAccent.withValues(alpha: 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: AppMotion.fast,
                    child: Icon(
                      isActive ? item.activeIcon : item.icon,
                      key: ValueKey(isActive),
                      color: color,
                      size: isActive ? 24 : 22,
                    ),
                  ),
                  if (item.badgeCount > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        constraints: const BoxConstraints(minWidth: 16),
                        decoration: BoxDecoration(
                          color: AppColors.mobileAccent,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          '${item.badgeCount}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: AppMotion.normal,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                  color: color,
                  letterSpacing: isActive ? 0.1 : 0,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
