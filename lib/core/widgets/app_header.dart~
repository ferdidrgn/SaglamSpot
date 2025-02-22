import 'package:flutter/material.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Container(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
          padding: const EdgeInsets.symmetric(vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildNavButton(0, Icons.home, 'Ana Sayfa'),
              const Spacer(),
              _buildNavButton(1, Icons.new_releases, 'Yeni Ürünler'),
              const SizedBox(width: 16),
              _buildNavButton(2, Icons.shopping_bag, 'Spot Ürünler'),
              const SizedBox(width: 16),
              _buildNavButton(3, Icons.info, 'Hakkımızda'),
              const SizedBox(width: 16),
              _buildNavButton(4, Icons.question_answer, 'SSS'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;

    return TextButton.icon(
      onPressed: () => onItemSelected(index),
      icon: Icon(
        icon,
        color: Colors.white,
        size: isSelected ? 24 : 20,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: isSelected ? 16 : 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor:
            isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
      ),
    );
  }
}
