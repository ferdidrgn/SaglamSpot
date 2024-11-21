import 'package:flutter/material.dart';
import 'package:saglamspot/presentation/pages/main_pages/home_screen.dart';
import 'package:saglamspot/presentation/pages/main_pages/spot_products_screen.dart';
import 'package:saglamspot/presentation/pages/main_pages/sss_screen.dart';
import 'info_screen.dart';
import 'new_products_screen.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  // Menü etiketlerini ve sayfalarını saklayan listeler
  final List<String> _menuItems = [
    'Anasayfa',
    'Yeni Ürünler',
    'Spot Ürünler',
    'Bilgiler',
    'SSS',
  ];

  final List<Widget> _pages = const [
    HomeScreen(),
    NewProductsScreen(),
    SpotProductsScreen(),
    InfoScreen(),
    SSSScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  const Text(
                    'SAĞLAM SPOT',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.red),
                  ),
                  const Spacer(),
                  // Menü öğelerini dinamik olarak oluştur
                  ..._menuItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    String label = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildMenuItem(index, label),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
    );
  }

  Widget _buildMenuItem(int index, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).indicatorColor
              : Theme.of(context).hintColor,
        ),
      ),
    );
  }
}