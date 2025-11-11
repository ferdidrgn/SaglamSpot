import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../util/responsive_utils.dart';
import 'custom_search_product_card.dart';

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
    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    final crossAxisCount = ResponsiveUtils.getGridCrossAxisCount(context);
    final spacing = ResponsiveUtils.getGridSpacing(context);
    final aspectRatio = ResponsiveUtils.getCardAspectRatio(context);

    return GridView.builder(
      controller: scrollController,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: ResponsiveUtils.getScreenPadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: products.length,
      itemBuilder: (final context, final index) {
        final product = products[index];
        return ModernProductCard(
          product: product,
          onTap: onProductTap != null ? () => onProductTap!(product) : null,
        );
      },
    );
  }

  Widget _buildEmptyState(final BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getScreenPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 64.0,
                desktop: 80.0,
              ),
              color: const Color(0xFF94A3B8),
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 16.0,
                desktop: 24.0,
              ),
            ),
            Text(
              'Ürün bulunamadı',
              style: TextStyle(
                fontSize: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 18.0,
                  tablet: 20.0,
                  desktop: 22.0,
                ),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 8.0,
                desktop: 12.0,
              ),
            ),
            Text(
              'Farklı filtreler deneyebilir veya arama teriminizi değiştirebilirsiniz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 14.0,
                  desktop: 16.0,
                ),
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
    if (products.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(context),
      );
    }

    final crossAxisCount = ResponsiveUtils.getGridCrossAxisCount(context);
    final spacing = ResponsiveUtils.getGridSpacing(context);
    final aspectRatio = ResponsiveUtils.getCardAspectRatio(context);

    return SliverPadding(
      padding: ResponsiveUtils.getScreenPadding(context),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: aspectRatio,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            final product = products[index];
            return ModernProductCard(
              product: product,
              onTap: onProductTap != null ? () => onProductTap!(product) : null,
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(final BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getScreenPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 64.0,
                desktop: 80.0,
              ),
              color: const Color(0xFF94A3B8),
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 16.0,
                desktop: 24.0,
              ),
            ),
            Text(
              'Ürün bulunamadı',
              style: TextStyle(
                fontSize: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 18.0,
                  tablet: 20.0,
                  desktop: 22.0,
                ),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 8.0,
                desktop: 12.0,
              ),
            ),
            Text(
              'Farklı filtreler deneyebilir veya arama teriminizi değiştirebilirsiniz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 14.0,
                  desktop: 16.0,
                ),
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
