import 'package:flutter/material.dart';
import 'package:saglamspot/presentation/pages/main_pages/spot_products_screen.dart';
import 'package:saglamspot/presentation/pages/main_pages/sss_screen.dart';
import '../../../core/custom_views/custom_bottom_navigation_bar.dart';
import 'info_screen.dart';
import 'new_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Anasayfa', style: TextStyle(fontSize: 24))),
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
        title: const Text('Mobilya Dükkânı'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
