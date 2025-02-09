import 'package:flutter/material.dart';
import '../../../core/widgets/app_header.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'new_products_page.dart';
import 'spot_products_page.dart';
import 'sss_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    const HomePage(),
    const NewProductsPage(),
    const SpotProductsPage(),
    const InfoPage(),
    const SSSPage(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Header
          AppHeader(
            selectedIndex: _selectedIndex,
            onItemSelected: _onItemSelected,
          ),
          // Page content starts below the App Header
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
