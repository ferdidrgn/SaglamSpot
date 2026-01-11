import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import '../../../core/theme/theme_context_extension.dart';

// --- 1. TEMEL PARLAMA EFEKTİ (Shimmer Box) ---
class ShimmerLoading extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final bool isCircular;

  const ShimmerLoading({
    super.key,
    this.height = 190.0,
    this.width = 130.0,
    this.borderRadius = 8.0,
    this.isCircular = false,
  });

  @override
  Widget build(final BuildContext context) => Shimmer.fromColors(
        baseColor: context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor:
            context.isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isCircular
                ? BorderRadius.circular(height / 2)
                : BorderRadius.circular(borderRadius),
          ),
        ),
      );
}

// --- 2. TEKİL ÜRÜN KARTI SHIMMER (Grid öğeleri için) ---
class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final int itemCount;
  final int? crossAxisCount;
  final bool showTextLine;

  const ShimmerCard({
    super.key,
    this.width = double.infinity,
    this.height = 300,
    this.itemCount = 5,
    this.crossAxisCount,
    this.showTextLine = true,
  });

  @override
  Widget build(final BuildContext context) {
    final effectiveCrossAxisCount = crossAxisCount ??
        context.responsive<int>(mobile: 3, tablet: 6, desktop: 10);

    return SliverGrid.builder(
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: effectiveCrossAxisCount,
        mainAxisSpacing: 15,
        crossAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (final context, final index) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Expanded(
              child: ShimmerLoading(
                height: double.infinity,
                width: double.infinity,
                borderRadius: 20,
              ),
            ),
            if (showTextLine)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(height: 12, width: 80, borderRadius: 4),
                    SizedBox(height: 8),
                    ShimmerLoading(
                        height: 16, width: double.infinity, borderRadius: 4),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- 3. KOMPLE SAYFA İSKELETİ (Skeleton Screen) ---
class FullPageShimmer extends StatelessWidget {
  const FullPageShimmer({super.key});

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header simülasyonu (Opsiyonel)
          const SizedBox(height: 40),

          // Hero Banner Shimmer
          Padding(
            padding: context.sectionPadding,
            child: ShimmerLoading(
              width: double.infinity,
              height: context.hp(45),
              borderRadius: 30,
            ),
          ),

          // Kategori Listesi Shimmer
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                  left: context.responsive(mobile: 24, desktop: 60)),
              itemCount: 6,
              itemBuilder: (final _, final __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: ShimmerLoading(height: 40, width: 120, borderRadius: 12),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Ürün Gridi Shimmer
          Padding(
            padding: context.sectionPadding,
            child: const ShimmerCard(itemCount: 8),
          ),
        ],
      ),
    );
  }
}
