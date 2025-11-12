import 'package:flutter/material.dart';

import '../../presentation/pages/search_page.dart';
import '../theme/app_colors.dart';
import '../util/responsive_utils.dart';

class CustomAppHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppHeader({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.scaffoldKey, // Bu anahtar mobil menü için zorunludur
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
              offset: const Offset(0, 4)),
        ],
        border: Border(
            bottom: BorderSide(color: AppColors.border.withOpacity(0.3))),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            // Düzeltme: 'getValueForDevice' yerine 'context.responsive'
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: context.responsive(mobile: 12.0, desktop: 16.0),
          ),
          // Düzeltme: 'ResponsiveUtils.isMobile' yerine 'context.isMobile'
          child: context.isMobile
              ? _buildMobileLayout(context) // Mobil düzen
              : _buildDesktopLayout(context), // Desktop düzen
        ),
      ),
    );
  }

  // --- DESKTOP DÜZENİ ---
  Widget _buildDesktopLayout(final BuildContext context) {
    return Row(
      children: [
        _buildLogo(context),
        const Spacer(),
        _buildDesktopNavigation(context),
        const Spacer(),
        _buildUserActions(context),
      ],
    );
  }

  // --- MOBİL DÜZENİ ---
  Widget _buildMobileLayout(final BuildContext context) {
    return Row(
      children: [
        // Mobil Logo (Daha küçük)
        _buildLogo(context),
        const Spacer(),
        // Mobil Arama Butonu
        _buildActionButton(
          context: context,
          icon: Icons.search_outlined,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (final context) => const SearchPage()),
            );
          },
        ),
        const SizedBox(width: 8),
        // Mobil Menü Butonu (Drawer'ı açmak için)
        _buildActionButton(
          context: context,
          icon: Icons.menu,
          onPressed: () {
            // Anahtarın (scaffoldKey) asıl kullanım amacı budur.
            // Eğer 'null' gelirse burada uygulama çöker.
            scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
    );
  }

  Widget _buildLogo(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onItemSelected(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // Düzeltme: 'getValueForDevice' yerine 'context.responsive'
              width: context.responsive(mobile: 32.0, desktop: 40.0),
              height: context.responsive(mobile: 32.0, desktop: 40.0),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(
                    context.responsive(mobile: 8.0, desktop: 12.0)),
              ),
              child: Icon(
                Icons.weekend_outlined,
                color: Colors.white,
                size: context.responsive(mobile: 18.0, desktop: 24.0),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Sağlam Spot',
              style: TextStyle(
                fontSize: context.responsive(mobile: 20.0, desktop: 24.0),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavigation(final BuildContext context) {
    // Bu başlıkların index'leri (0, 1, 2, 3, 4)
    // _onItemSelected'a giden index'ler ile eşleşmelidir.
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
        // Desktop'taki arama çubuğu (görsel)
        _buildSearchBar(context),
        const SizedBox(width: 16),
        // Desktop'taki profil/giriş butonu
        _buildActionButton(
          context: context,
          icon: Icons.person_outline,
          onPressed: () {
            // TODO: Profil veya Giriş sayfasına yönlendir
          },
        ),
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
          width: context.responsive(mobile: 150.0, desktop: 200.0),
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
    required final BuildContext context,
    required final IconData icon,
    required final VoidCallback onPressed,
  }) {
    final double size = context.responsive(mobile: 40.0, desktop: 40.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 10.0, desktop: 12.0)),
          border: Border.all(color: AppColors.border)),
      child: IconButton(
          icon:
              Icon(icon, size: context.responsive(mobile: 20.0, desktop: 20.0)),
          onPressed: onPressed,
          color: AppColors.textSecondary,
          padding: EdgeInsets.zero),
    );
  }
}

/// Header için gezinme butonu (Navigation Item)
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
          padding: EdgeInsets.symmetric(
            // Düzeltme: 'getValueForDevice' yerine 'context.responsive'
            horizontal: context.responsive(mobile: 12.0, desktop: 20.0),
            vertical: context.responsive(mobile: 8.0, desktop: 12.0),
          ),
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
                fontSize: context.responsive(mobile: 14.0, desktop: 15.0)),
          ),
        ),
      ),
    );
  }
}
