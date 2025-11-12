import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_app_header.dart';
import '../pages/main_pages/home_page.dart';
import '../pages/main_pages/info_page.dart';
import '../pages/main_pages/new_products_page.dart';
import '../pages/main_pages/spot_products_page.dart';
import '../pages/main_pages/sss_page.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key});

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    NewProductsPage(),
    SpotProductsPage(),
    InfoPage(),
    SSSPage(),
  ];

  void _onItemSelected(final int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Bonus: Mobilde bir seçim yapıldığında çekmeceyi (drawer) kapatın
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false)
      Navigator.of(context).pop();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Modern App Header
            CustomAppHeader(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
              scaffoldKey: _scaffoldKey,
            ),
            // Page Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withOpacity(0.8),
                      AppColors.background.withOpacity(0.4),
                    ],
                  ),
                ),
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
            ),
          ],
        ),
      ),
      // 4. ADIM: Mobil menü butonunun açması için bir endDrawer tanımlayın
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary, // Veya logonuzu/renginizi kullanın
              ),
              child: Text(
                'Sağlam Spot',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Ana Sayfa'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemSelected(0),
            ),
            ListTile(
              leading: const Icon(Icons.new_releases_outlined),
              title: const Text('Sıfır Ürünler'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemSelected(1),
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('Spot Ürünler'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemSelected(2),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Hakkımızda'),
              selected: _selectedIndex == 3,
              onTap: () => _onItemSelected(3),
            ),
            ListTile(
              leading: const Icon(Icons.quiz_outlined),
              title: const Text('SSS'),
              selected: _selectedIndex == 4,
              onTap: () => _onItemSelected(4),
            ),
          ],
        ),
      ),
    );
  }
}
