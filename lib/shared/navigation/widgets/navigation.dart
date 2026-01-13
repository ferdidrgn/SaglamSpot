import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/shared/navigation/providers/navigation_service.dart';
import '../../../core/theme/app_colors.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Mobilya odaklı navigasyon elemanları
  late final List<NavigationItem> _navItems = [
    NavigationItem(label: 'Ana Sayfa', icon: Icons.home_rounded, index: 0),
    NavigationItem(label: 'Sıfır Mobilya', icon: Icons.chair_rounded, index: 1),
    NavigationItem(label: 'İkinci El', icon: Icons.weekend_rounded, index: 2),
    NavigationItem(label: 'Hakkımızda', icon: Icons.store_rounded, index: 3),
    NavigationItem(label: 'SSS', icon: Icons.quiz_rounded, index: 4),
  ];

  void _onItemTapped(final int index) {
    if (MediaQuery.sizeOf(context).width < 1024) {
      _scaffoldKey.currentState?.closeDrawer();
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  // --- UI Bileşenleri ---

  Widget _buildLogo() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.chair_alt_rounded, color: AppColors.primary, size: 28),
        SizedBox(width: 8),
        Text(
          "SAĞLAM SPOT",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 1,
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
        icon: const Icon(Icons.search_rounded),
        color: AppColors.textPrimary,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: const Row(
          children: [
            Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Ürün Ara...',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500)),
            SizedBox(width: 16),
            _KbdShortcut(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 1024;
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar:
      isMobile ? _buildMobileAppBar() : _buildDesktopAppBar(currentIndex),
      drawer: isMobile
          ? _MobileDrawer(
        navItems: _navItems,
        currentIndex: currentIndex,
        onItemTapped: _onItemTapped,
        logo: _buildLogo(),
      )
          : null,
      body: widget.navigationShell,
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 1,
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        icon: const Icon(Icons.menu_rounded),
      ),
      title: InkWell(onTap: () => _onItemTapped(0), child: _buildLogo()),
      actions: [_buildSearchButton(true), const SizedBox(width: 8)],
    );
  }

  PreferredSizeWidget _buildDesktopAppBar(final int currentIndex) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 1,
      title: InkWell(onTap: () => _onItemTapped(0), child: _buildLogo()),
      actions: [
        ..._navItems.map((final item) => _DesktopNavItem(
          item: item,
          isActive: currentIndex == item.index,
          onTap: () => _onItemTapped(item.index),
        )),
        const SizedBox(width: 24),
        _buildSearchButton(false),
        const SizedBox(width: 24),
      ],
    );
  }
}

// --- Alt Bileşenler (Refactored to separate classes for clarity) ---

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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(
              bottom: BorderSide(color: AppColors.primary, width: 3))
              : null,
        ),
        child: Row(
          children: [
            Icon(item.icon,
                size: 18,
                color: isActive ? AppColors.primary : AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              item.label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
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

  const _MobileDrawer({
    required this.navItems,
    required this.currentIndex,
    required this.onItemTapped,
    required this.logo,
  });

  @override
  Widget build(final BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [logo, const Spacer(), const CloseButton()]),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: navItems
                  .map((final item) => ListTile(
                leading: Icon(item.icon,
                    color: currentIndex == item.index
                        ? AppColors.primary
                        : null),
                title: Text(item.label),
                selected: currentIndex == item.index,
                selectedTileColor: AppColors.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () => onItemTapped(item.index),
              ))
                  .toList(),
            ),
          ),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => context.go("/search"),
            icon: const Icon(Icons.search_rounded),
            label: const Text('Ürün Ara'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text('Kaliteli mobilyanın adresi Sağlam Spot',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _KbdShortcut extends StatelessWidget {
  const _KbdShortcut();

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
      child: const Text('Ctrl+K',
          style: TextStyle(color: Colors.white, fontSize: 10)),
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
