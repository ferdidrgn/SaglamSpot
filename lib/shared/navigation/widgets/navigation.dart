import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/util/platform_checker.dart';
import 'package:saglamspot/core/widgets/ad_mobile_banner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/util/responsive_utils.dart';
import '../../../core/widgets/ad_sense_banner.dart';

class SearchIntent extends Intent {
  const SearchIntent();
}

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late final List<NavigationItem> _navItems = [
    NavigationItem(label: 'Ana Sayfa', icon: Icons.home_rounded, index: 0),
    NavigationItem(label: 'Sıfır Mobilya', icon: Icons.chair_rounded, index: 1),
    NavigationItem(label: 'İkinci El', icon: Icons.weekend_rounded, index: 2),
    NavigationItem(label: 'Hakkımızda', icon: Icons.store_rounded, index: 3),
    NavigationItem(label: 'SSS', icon: Icons.quiz_rounded, index: 4),
  ];

  void _onItemTapped(final int index) {
    if (MediaQuery.sizeOf(context).width < 1024)
      _scaffoldKey.currentState?.closeDrawer();

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/saglam_spot_logo.png',
          width: context.responsive(
            mobile: 40,
            tablet: 45,
            desktop: 50,
          ),
          height: context.responsive(
            mobile: 40,
            tablet: 45,
            desktop: 50,
          ),
          fit: BoxFit.contain,
        ),
        SizedBox(width: context.responsive(mobile: 4, tablet: 6, desktop: 8)),
        Text(
          "SAĞLAM SPOT",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: context.responsive(
              mobile: 14,
              tablet: 18,
              desktop: 20,
            ),
            letterSpacing: context.responsive(
              mobile: 1,
              tablet: 1.5,
              desktop: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton(final bool isMobile) {
    void onTap() => context.go("/search");

    if (isMobile) {
      return IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.search_rounded,
          size: context.responsive(mobile: 22, tablet: 24, desktop: 26),
        ),
        color: AppColors.textPrimary,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.borderRadius()),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 12, tablet: 14, desktop: 16),
          vertical: context.responsive(mobile: 6, tablet: 7, desktop: 8),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(context.borderRadius(0.8)),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: context.responsive(mobile: 18, tablet: 19, desktop: 20),
              color: AppColors.primary,
            ),
            SizedBox(
                width: context.responsive(mobile: 4, tablet: 6, desktop: 8)),
            Text(
              'Ürün Ara...',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: context.responsive(
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
            ),
            SizedBox(
                width: context.responsive(mobile: 8, tablet: 12, desktop: 16)),
            const _KbdShortcut(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 1,
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        icon: Icon(
          Icons.menu_rounded,
          size: context.responsive(mobile: 24, tablet: 26, desktop: 28),
        ),
      ),
      title: InkWell(onTap: () => _onItemTapped(0), child: _buildLogo()),
      actions: [_buildSearchButton(true), const SizedBox(width: 8)],
      toolbarHeight: context.responsive(
        mobile: 60,
        tablet: 70,
        desktop: 80,
      ),
    );
  }

  PreferredSizeWidget _buildDesktopAppBar(final int currentIndex) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 1,
      title: Row(
        children: [
          // Logo solda
          InkWell(onTap: () => _onItemTapped(0), child: _buildLogo()),

          // Spacer ile diğer item'ları sağa itiyoruz
          const Spacer(),

          // Nav item'ları
          ..._navItems.map((final item) => _DesktopNavItem(
                item: item,
                isActive: currentIndex == item.index,
                onTap: () => _onItemTapped(item.index),
              )),

          SizedBox(
              width: context.responsive(mobile: 16, tablet: 20, desktop: 24)),

          // Arama butonu
          _buildSearchButton(false),

          SizedBox(
              width: context.responsive(mobile: 16, tablet: 20, desktop: 24)),
        ],
      ),
      toolbarHeight: context.responsive(
        mobile: 60,
        tablet: 70,
        desktop: 80,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 1024;
    final currentIndex = widget.navigationShell.currentIndex;

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK):
            const SearchIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK):
            const SearchIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SearchIntent: CallbackAction<SearchIntent>(
            onInvoke: (final intent) => context.go("/search"),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            appBar: isMobile
                ? _buildMobileAppBar()
                : _buildDesktopAppBar(currentIndex),
            drawer: isMobile
                ? _MobileDrawer(
                    navItems: _navItems,
                    currentIndex: currentIndex,
                    onItemTapped: _onItemTapped,
                    logo: _buildLogo(),
                  )
                : null,
            body: widget.navigationShell,
          ),
        ),
      ),
    );
  }
}

class _DesktopNavItem extends StatelessWidget {
  final NavigationItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _DesktopNavItem(
      {required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.borderRadius()),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 12, tablet: 14, desktop: 16),
          vertical: context.responsive(mobile: 8, tablet: 10, desktop: 12),
        ),
        decoration: BoxDecoration(
          border: isActive
              ? Border(
                  bottom: BorderSide(
                      color: AppColors.primary,
                      width: context.responsive(
                          mobile: 2, tablet: 2.5, desktop: 3)))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: context.responsive(mobile: 16, tablet: 17, desktop: 18),
              color: isActive ? AppColors.primary : AppColors.textPrimary,
            ),
            SizedBox(
                width: context.responsive(mobile: 4, tablet: 6, desktop: 8)),
            Text(
              item.label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                fontSize: context.responsive(
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  final List<NavigationItem> navItems;
  final int currentIndex;
  final Function(int) onItemTapped;
  final Widget logo;

  const _MobileDrawer(
      {required this.navItems,
      required this.currentIndex,
      required this.onItemTapped,
      required this.logo});

  @override
  Widget build(final BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(context.responsive(
                mobile: 16,
                tablet: 20,
                desktop: 24,
              )),
              child: Row(children: [
                logo,
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size:
                        context.responsive(mobile: 24, tablet: 28, desktop: 32),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ]),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(context.responsive(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              )),
              children: navItems
                  .map((final item) => ListTile(
                        leading: Icon(
                          item.icon,
                          size: context.responsive(
                              mobile: 22, tablet: 24, desktop: 26),
                          color: currentIndex == item.index
                              ? AppColors.primary
                              : null,
                        ),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: context.responsive(
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                          ),
                        ),
                        selected: currentIndex == item.index,
                        selectedTileColor: AppColors.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(context.borderRadius())),
                        onTap: () => onItemTapped(item.index),
                      ))
                  .toList(),
            ),
          ),
          if (PlatformChecker.isMobile)
            const AdBannerWidget()
          else
            const AdsenseBanner(height: 250),
          _DrawerFooter(),
        ],
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.responsive(
        mobile: 16,
        tablet: 20,
        desktop: 24,
      )),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => context.go("/search"),
            icon: Icon(
              Icons.search_rounded,
              size: context.responsive(mobile: 20, tablet: 22, desktop: 24),
            ),
            label: Text(
              'Ürün Ara',
              style: TextStyle(
                fontSize: context.responsive(
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                double.infinity,
                context.responsive(mobile: 45, tablet: 50, desktop: 55),
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(
              height: context.responsive(mobile: 8, tablet: 10, desktop: 12)),
          Text(
            'Kaliteli mobilyanın adresi Sağlam Spot',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.responsive(
                mobile: 11,
                tablet: 12,
                desktop: 13,
              ),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _KbdShortcut extends StatelessWidget {
  const _KbdShortcut();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 4, tablet: 5, desktop: 6),
        vertical: context.responsive(mobile: 1, tablet: 1.5, desktop: 2),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.borderRadius(0.5)),
      ),
      child: Text(
        'Ctrl+K',
        style: TextStyle(
          color: Colors.white,
          fontSize: context.responsive(
            mobile: 9,
            tablet: 10,
            desktop: 11,
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final int index;

  NavigationItem(
      {required this.label, required this.icon, required this.index});
}
