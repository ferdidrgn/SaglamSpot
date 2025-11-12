import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MobileAppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const MobileAppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(final BuildContext context) {
    // Header'daki aynı navigasyon listesi
    const navItems = [
      'Ana Sayfa',
      'Sıfır Ürünler',
      'Spot Ürünler',
      'Hakkımızda',
      'SSS'
    ];

    return Drawer(
      child: Container(
        color: AppColors.surface, // Arka plan rengi
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Başlığı
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.weekend_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Sağlam Spot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Navigasyon Elemanları
            ...List.generate(navItems.length, (final index) {
              final isSelected = selectedIndex == index;
              return ListTile(
                leading: Icon(
                  _getIconForIndex(index), // İkonlar için yardımcı metot
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                title: Text(
                  navItems[index],
                  style: TextStyle(
                    color:
                        isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                tileColor:
                    isSelected ? AppColors.primary.withOpacity(0.1) : null,
                onTap: () => onItemSelected(index),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Menü ikonlarını belirleyen yardımcı metot
  IconData _getIconForIndex(final int index) {
    switch (index) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.check_box_outline_blank_outlined;
      case 2:
        return Icons.local_offer_outlined;
      case 3:
        return Icons.info_outline;
      case 4:
        return Icons.quiz_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
