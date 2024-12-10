import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppHeader({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.headerHeight,
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.defaultPadding / 2,
      ),
      child: Row(
        children: [
          _buildLogo(),
          const SizedBox(width: 40),
          Expanded(child: _buildNavigation()),
          _buildContactButton(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return const Text(
      'LOGO',
      style: TextStyle(
        fontSize: AppConstants.headerFontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildNavigation() {
    return Row(
      children: [
        _buildNavItem('Ana Sayfa', 0),
        _buildNavItem('Sıfır Ürünler', 1),
        _buildNavItem('İkinci El', 2),
        _buildNavItem('Hakkında', 3),
        _buildNavItem('SSS', 4),
      ],
    );
  }

  Widget _buildNavItem(String title, int index) {
    bool isSelected = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: () => onItemSelected(index),
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.white70,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: AppConstants.navigationFontSize,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
      child: const Text('İletişim'),
    );
  }
} 