import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../features/cart/presentation/providers/cart_provider.dart';
import '../../../features/products/presentation/providers/favorites_provider.dart';

/// Kenara yapışık, koyu marka renkli (AppColors.primary) modern alt
/// navigasyon — eski "yüzen pill" tasarımının yerini aldı (kullanıcı
/// isteği: düz, tam genişlikte, marka rengi). Destinations: Home /
/// Discover / Cart / Favorites / Profile.
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
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
        isActive ? Colors.white : Colors.white.withValues(alpha: 0.6);

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
                ? Colors.white.withValues(alpha: 0.16)
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
                          color: AppColors.accentLight,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Text(
                          '${item.badgeCount}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryDark,
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
