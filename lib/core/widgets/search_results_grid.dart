import 'package:flutter/material.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import '../../../domain/entities/product.dart';
import '../../core/theme/app_colors.dart';

class SearchResultsGrid extends StatelessWidget {
  final List<Product> products;

  const SearchResultsGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(final BuildContext context) {
    final availableProducts = products.where((final p) => !p.isSold).toList();
    final soldProducts = products.where((final p) => p.isSold).toList();

    return CustomScrollView(
      slivers: [
        // Available Products
        if (availableProducts.isNotEmpty)
          _buildProductSection('Mevcut Ürünler', availableProducts),

        // Sold Products
        if (soldProducts.isNotEmpty)
          _buildProductSection('Satılmış Ürünler', soldProducts),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildProductSection(
      final String title, final List<Product> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Section Header
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      products.length.toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary),
                    )),
              ],
            ),
          ),

          // Products Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (final context, final index) {
              return CustomProductCard(product: products[index]);
            },
          ),

          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}
