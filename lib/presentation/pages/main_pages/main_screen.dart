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
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FA),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // İçerik alanı
                    _pages[_selectedIndex],
                    // Footer
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF2C3E50),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterSection(
                'Hakkımızda',
                ['Şirket Bilgileri', 'Kariyer', 'İletişim'],
              ),
              const SizedBox(width: 64),
              _buildFooterSection(
                'Yardım',
                ['SSS', 'Kargo Takip', 'İade Şartları'],
              ),
              const SizedBox(width: 64),
              _buildFooterSection(
                'Sosyal Medya',
                ['Instagram', 'Twitter', 'Facebook'],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            '© 2024 Tüm hakları saklıdır.',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  item,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
              ),
            )),
      ],
    );
  }
}
