import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/domain/entites/product.dart';
import '../ads/widgets/ad_grid_helper.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_product_card.dart';

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
    if (products.isEmpty) return _BuildEmptyState();

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
}

/// Sliver variant for CustomScrollView
class ResponsiveProductSliverGrid extends ConsumerWidget {
  final List<Product> products;
  final void Function(Product)? onProductTap;

  /// true ise, ürünlerin arasına ürün kartıyla aynı çerçeveye sahip
  /// "doğal" reklam kartları serpiştirilir (bkz. ad_grid_helper.dart):
  /// liste kısaysa her 5, uzunsa her 10 üründe bir.
  final bool insertAds;

  const ResponsiveProductSliverGrid({
    super.key,
    required this.products,
    this.onProductTap,
    this.insertAds = false,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (products.isEmpty) return SliverFillRemaining(child: _BuildEmptyState());

    final crossAxisCount = context.gridColumns();
    final spacing = context.gridSpacing;

    final screenPadding = context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        desktop: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0));

    return SliverPadding(
      padding: screenPadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: context.cardAspectRatio(),
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            if (!insertAds) return CustomProductCard(product: products[index]);
            if (isAdSlot(index, products.length)) return const NativeAdCard();
            final realIndex = realIndexForAdGrid(index, products.length);
            if (realIndex >= products.length) return const SizedBox.shrink();
            return CustomProductCard(product: products[realIndex]);
          },
          childCount:
              insertAds ? paddedItemCountForAds(products.length) : products.length,
        ),
      ),
    );
  }
}

class _BuildEmptyState extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
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
              color: AppColors.textTertiary,
            ),
            SizedBox(
              height:
                  context.responsive(mobile: 16.0, desktop: 24.0), // Extension
            ),
            Text(
              context.l10n.productNotFound,
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: context.responsive(
                    mobile: 18.0, tablet: 20.0, desktop: 22.0), // Extension
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
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
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
