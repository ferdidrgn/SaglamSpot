import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../util/responsive_utils.dart'; // Extension'lar için import
import 'custom_product_card.dart';

/// Responsive product grid with optimal performance
/// Uses SliverGrid for better performance with large lists
class ResponsiveProductGrid extends ConsumerWidget {
  final List<Product> products;
  final ScrollController? scrollController;
  final void Function(Product)? onProductTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveProductGrid({
    super.key,
    required this.products,
    this.scrollController,
    this.onProductTap,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (products.isEmpty) return _buildEmptyState(context);

    // Extension'lar kullanıldı
    final crossAxisCount = context.gridColumns();
    final spacing = context.gridSpacing;

    // getScreenPadding extension'da yok, bu yüzden responsive() kullandık
    final screenPadding = context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        desktop: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0));

    return GridView.builder(
      controller: scrollController,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: screenPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: context.cardAspectRatio(),
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: products.length,
      itemBuilder: (final context, final index) {
        final product = products[index];
        return CustomProductCard(product: product);
      },
    );
  }

  Widget _buildEmptyState(final BuildContext context) {
    final screenPadding = context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        desktop: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0));

    return Center(
      child: Padding(
        padding: screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: context.responsive(mobile: 64.0, desktop: 80.0),
              // Extension
              color: const Color(0xFF94A3B8),
            ),
            SizedBox(
              height:
                  context.responsive(mobile: 16.0, desktop: 24.0), // Extension
            ),
            Text(
              'Ürün bulunamadı',
              style: TextStyle(
                fontSize: context.responsive(
                    mobile: 18.0, tablet: 20.0, desktop: 22.0), // Extension
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(
              height:
                  context.responsive(mobile: 8.0, desktop: 12.0), // Extension
            ),
            Text(
              'Farklı filtreler deneyebilir veya arama teriminizi değiştirebilirsiniz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsive(
                    mobile: 14.0, desktop: 16.0), // Extension
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sliver variant for CustomScrollView
class ResponsiveProductSliverGrid extends ConsumerWidget {
  final List<Product> products;
  final void Function(Product)? onProductTap;

  const ResponsiveProductSliverGrid({
    super.key,
    required this.products,
    this.onProductTap,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (products.isEmpty)
      return SliverFillRemaining(
        child: _buildEmptyState(context),
      );

    final crossAxisCount = context.gridColumns();
    final spacing = context.gridSpacing;

    // --- DEĞİŞİKLİK BURADA ---
    // İki widget'ın da tutarlı olması için aynı oranlar girildi.
    final aspectRatio =
        context.responsive(mobile: 0.62, tablet: 0.75, desktop: 0.78);
    // --- DEĞİŞİKLİK SONU ---

    final screenPadding = context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        desktop: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0));

    return SliverPadding(
      padding: screenPadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: context.cardAspectRatio(),
          // Güncellenen değer kullanıldı
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            final product = products[index];
            return CustomProductCard(product: product);
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(final BuildContext context) {
    final screenPadding = context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        desktop: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0));

    return Center(
      child: Padding(
        padding: screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: context.responsive(mobile: 64.0, desktop: 80.0),
              // Extension
              color: const Color(0xFF94A3B8),
            ),
            SizedBox(
              height:
                  context.responsive(mobile: 16.0, desktop: 24.0), // Extension
            ),
            Text(
              'Ürün bulunamadı',
              style: TextStyle(
                fontSize: context.responsive(
                    mobile: 18.0, tablet: 20.0, desktop: 22.0), // Extension
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(
              height:
                  context.responsive(mobile: 8.0, desktop: 12.0), // Extension
            ),
            Text(
              'Farklı filtreler deneyebilir veya arama teriminizi değiştirebilirsiniz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsive(
                    mobile: 14.0, desktop: 16.0), // Extension
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
