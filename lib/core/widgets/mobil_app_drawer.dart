import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    const navItems = [
      'Ana Sayfa',
      'Sıfır Ürünler',
      'Spot Ürünler',
      'Hakkımızda',
      'SSS'
    ];

    return Drawer(
      backgroundColor: const Color(0xFFF3F7F6),
      // Ana sayfa ile uyumlu mint beyazı
      child: Column(
        children: [
          // 1. MODERN DRAWER HEADER (Logo Odaklı)
          _buildModernHeader(context),

          const SizedBox(height: 20),

          // 2. NAVİGASYON LİSTESİ
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: navItems.length,
              itemBuilder: (final context, final index) {
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    leading: Icon(
                      _getIconForIndex(index),
                      color: isSelected ? Colors.black : Colors.black45,
                      size: 22,
                    ),
                    title: Text(
                      navItems[index],
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    tileColor: isSelected ? Colors.white : Colors.transparent,
                    // Seçili olduğunda hafif bir gölge ekleyerek derinlik kazandırıyoruz
                    onTap: () {
                      Navigator.pop(context); // Menü tıklandığında kapanır
                      onItemSelected(index);
                    },
                  ),
                );
              },
            ),
          ),

          // 3. ALT KISIM (Sosyal Medya veya Versiyon Bilgisi)
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildModernHeader(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LOGO ALANI
          GestureDetector(
            onTap: () => context.go('/'), // Logoya basınca ana sayfaya döner
            child: Row(
              children: [
                Image.asset(
                  'assets/images/saglam_spot_logo.png',
                  height: 40,
                  // Yüksekliği header'a göre ayarla
                  fit: BoxFit.contain,
                  // Yüklenirken veya hata oluşursa boş görünmemesi için hata kontrolü
                  errorBuilder:
                      (final context, final error, final stackTrace) =>
                          const Icon(Icons.weekend_rounded,
                              color: Color(0xFF1E293B), size: 32),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Sağlam Spot',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.8, // Daha modern bir duruş için
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Mobilyada güven ve kalitenin adresi.',
            style: TextStyle(color: Colors.black45, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialSmallIcon(Icons.facebook),
              const SizedBox(width: 20),
              _socialSmallIcon(Icons.camera_alt),
            ],
          ),
          const SizedBox(height: 12),
          const Text('v1.0.4',
              style: TextStyle(color: Colors.black26, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _socialSmallIcon(final IconData icon) =>
      Icon(icon, color: Colors.black26, size: 20);

  IconData _getIconForIndex(final int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.new_releases_outlined;
      case 2:
        return Icons.local_offer_outlined;
      case 3:
        return Icons.info_outline_rounded;
      case 4:
        return Icons.help_outline_rounded;
      default:
        return Icons.circle;
    }
  }
}
