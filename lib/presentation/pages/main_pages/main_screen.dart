import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_header.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'new_products_page.dart';
import 'spot_products_page.dart';
import 'sss_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
