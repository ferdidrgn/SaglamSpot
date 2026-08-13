import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/cart/presentation/providers/cart_provider.dart';

/// Native mobil uygulamanın kalıcı alt navigasyon çubuğu — Ana Sayfa /
/// Keşfet / Sepet / Profil. Aktif sekme, o anki GoRouter yoluna göre
/// belirlenir; her sayfa bunu kendi Scaffold'unun `bottomNavigationBar`
/// alanına ekleyerek kullanır (bkz. NavigationScreen, SearchPage,
/// CartPage, SettingsPage).
class MobileBottomNav extends ConsumerWidget {
  const MobileBottomNav({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final int cartCount = ref.watch(cartItemCountProvider);

    final items = <_NavItemData>[
      _NavItemData(
        path: '/',
        icon: Icons.home_rounded,
        activeIcon: Icons.home_rounded,
        label: context.l10n.home,
      ),
      _NavItemData(
        path: '/search',
        icon: Icons.explore_outlined,
        activeIcon: Icons.explore_rounded,
        label: context.l10n.navDiscover,
      ),
      _NavItemData(
        path: '/cart',
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag_rounded,
        label: context.l10n.navCart,
        badgeCount: cartCount,
      ),
      _NavItemData(
        path: '/settings',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: context.l10n.navProfile,
      ),
    ];

    return Material(
      color: Colors.white,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.mobileBorder)),
          ),
          child: Row(
            children: [
              for (final item in items)
                Expanded(
                  child: _NavButton(
                    item: item,
                    isActive: _isActive(currentPath, item.path),
                    onTap: () => context.go(item.path),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isActive(final String currentPath, final String itemPath) {
    if (itemPath == '/') return currentPath == '/';
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

  const _NavButton({required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    final Color color =
        isActive ? AppColors.mobilePrimary : AppColors.mobileMutedDark;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(isActive ? item.activeIcon : item.icon, color: color, size: 24),
              if (item.badgeCount > 0)
                Positioned(
                  right: -8,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    constraints: const BoxConstraints(minWidth: 16),
                    decoration: BoxDecoration(
                      color: AppColors.mobileAccent,
                      borderRadius: BorderRadius.circular(10),
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
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
