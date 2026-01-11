import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../util/responsive_utils.dart';

class ParallaxBreakdownSection extends StatelessWidget {
  const ParallaxBreakdownSection({super.key});

  @override
  Widget build(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 600,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text("MÜKEMMEL İÇ YAPI",
                style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.w900,
                    color: Colors.white10)),
            // CustomPainter ile parçaları buraya ekleyeceğiz (Parallax mantığıyla)
            _buildFloatingPart(
                context, "İskelet", "Masif Gürgen", 0.2, Icons.architecture),
            _buildFloatingPart(
                context, "Konfor", "35 DNS Sünger", 0.5, Icons.waves),
            _buildFloatingPart(
                context, "Doku", "İtalyan Kumaş", 0.8, Icons.texture),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingPart(final BuildContext context, final String title, final String desc,
      final double speed, final IconData icon) {
    // Scroll pozisyonuna göre offset değişecek (Logic eklenebilir)
    return Positioned(
      left: context.screenWidth * speed,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 40),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(desc,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}
