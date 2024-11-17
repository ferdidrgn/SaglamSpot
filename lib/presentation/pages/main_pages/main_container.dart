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

  final List<Widget> _pages = const [
HomeScreen(),    NewProductsScreen(),
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
          child: Row(
            children: [
              const Text(
                'SAĞLAM SPOT',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.red),
              ),
              const Spacer(), // Boşluk bırak
              _buildMenuItem(0, 'Anasayfa'),
              const SizedBox(width: 16), // Menü elemanları arasında boşluk
              _buildMenuItem(1, 'Yeni Ürünler'),
              const SizedBox(width: 16),
              _buildMenuItem(2, 'Spot Ürünler'),
              const SizedBox(width: 16),
              _buildMenuItem(3, 'Bilgiler'),
              const SizedBox(width: 16),
              _buildMenuItem(4, 'SSS'),
            ],
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
