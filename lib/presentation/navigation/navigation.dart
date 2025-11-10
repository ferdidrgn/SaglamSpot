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
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
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
                selectedIndex: _selectedIndex, onItemSelected: _onItemSelected),
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
    );
  }
}
