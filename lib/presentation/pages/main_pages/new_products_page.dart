import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../domain/entities/product.dart';

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends ConsumerState<NewProductsPage> {

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productState.isLoading
          ? _buildLoadingState(context)
          : productState.errorMessage != null
              ? _buildErrorState(context, productState.errorMessage!)
              : productState.dataList?.isEmpty ?? true
                  ? _buildEmptyState(context)
                  : _buildContentState(context, productState.dataList!),
    );
  }

  Widget _buildLoadingState(final BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 24),
          Text(
            'Yeni ürünler yükleniyor...',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildContentState(
      final BuildContext context, final List<Product> products) {
    final newProducts =
        products.where((p) => !p.isSold && !p.isSpotProduct).toList();

    if (newProducts.isEmpty) {
      return _buildEmptyState(context);
    }

    final spacing = context.gridSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(),
          childAspectRatio:
              context.responsive(mobile: 0.72, tablet: 0.78, desktop: 0.80),
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: newProducts.length,
        itemBuilder: (_, index) {
          return CustomProductCard(product: newProducts[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState(final BuildContext context) {
    return Center(
      child: Padding(
        padding: context.paddingHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz yeni ürün bulunmamaktadır',
              style: TextStyle(
                fontSize: context.responsive(mobile: 18, desktop: 20),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Yeni ürünler eklendiğinde burada listelenecektir.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(final BuildContext context, final String message) {
    return Center(
      child: Padding(
        padding: context.paddingHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppColors.error),
            const SizedBox(height: 24),
            Text(
              'Bir hata oluştu',
              style: TextStyle(
                fontSize: context.responsive(mobile: 18, desktop: 20),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
