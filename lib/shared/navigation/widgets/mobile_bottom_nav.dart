import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_design_tokens.dart';
import '../../../features/products/presentation/providers/favorites_provider.dart';

/// Native mobil uygulamanın kalıcı alt navigasyon çubuğu — Ana Sayfa /
/// Keşfet / Favoriler / Profil. Bir shell/route'a değil her sayfaya kendi
/// `Scaffold.bottomNavigationBar`'ı olarak gömülür (bkz. HomeStorePage,
/// DiscoverPage, FavoritesPage, SettingsPage) — aktif sekme o anki
/// GoRouter yoluna göre belirlenir. Yüzen, camsı bir "pill" olarak
/// tasarlandı: uygulamanın "Endüstriyel-Cam" tasarım diliyle (bkz.
/// AppGlassTokens) tutarlı, ama gerçek bir native app'te alışılmış
/// dokunuşu (basılı tutunca küçülme, haptic) taşıyor. Sepet (WhatsApp
/// istek listesi) artık bir sekme değil — ürün detay/favoriler gibi
/// yerlerden rozetli bir simgeyle erişiliyor (bkz. CartIconButton).
class MobileBottomNav extends ConsumerWidget {
  const MobileBottomNav({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final int favoritesCount = ref.watch(favoritesCountProvider);

    final items = <_NavItemData>[
      _NavItemData(
        path: '/',
        icon: Icons.home_rounded,
        label: context.l10n.home,
      ),
      _NavItemData(
        path: '/discover',
        icon: Icons.explore_rounded,
        label: context.l10n.navDiscover,
      ),
      _NavItemData(
        path: '/favorites',
        icon: Icons.favorite_rounded,
        label: context.l10n.navFavorites,
        badgeCount: favoritesCount,
      ),
      _NavItemData(
        path: '/settings',
        icon: Icons.person_rounded,
        label: context.l10n.navProfile,
      ),
    ];

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.glass.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: context.glass.blurLg, sigmaY: context.glass.blurLg),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: context.glass.glassTintStrong,
              borderRadius: BorderRadius.circular(context.glass.radiusXl),
              border: Border.all(color: context.glass.glassBorder),
              boxShadow: [
                BoxShadow(
                  color: context.glass.shadowColor,
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                for (final item in items)
                  Expanded(
                    child: _NavButton(
                      item: item,
                      isActive: _isActive(currentPath, item.path),
                      onTap: () {
                        if (_isActive(currentPath, item.path)) return;
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
    if (itemPath == '/') return currentPath == '/';
    return currentPath.startsWith(itemPath);
  }
}

class _NavItemData {
  final String path;
  final IconData icon;
  final String label;
  final int badgeCount;

  const _NavItemData({
    required this.path,
    required this.icon,
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
      borderRadius: BorderRadius.circular(context.glass.radiusXl),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.mobilePrimary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(context.glass.radiusLg),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(item.icon, color: color, size: isActive ? 24 : 22),
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
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                color: color,
              ),
              child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
