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

  static const List<Widget> _pages = [
    HomePage(),
    NewProductsPage(),
    SpotProductsPage(),
    InfoPage(),
    SSSPage(),
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
          AppHeader(
            selectedIndex: _selectedIndex,
            onItemSelected: _onItemSelected,
          ),
          Expanded(child: _pages[_selectedIndex])
        ],
      ),
    );
  }
}
