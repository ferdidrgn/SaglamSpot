import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/custom_product_card.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../domain/entities/product.dart';

class SpotProductsPage extends ConsumerWidget {
  const SpotProductsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final productState = ref.watch(productProvider);

    if (productState.isLoading) {
      return _buildLoadingState();
    } else if (productState.errorMessage != null) {
      return _buildErrorState(productState.errorMessage!);
    } else {
      return _buildLoadedState(productState.products);
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadedState(final List<Product> products) {
    final spotProducts =
        products.where((final p) => p.isSpotProduct && !p.isSold).toList();

    if (spotProducts.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: spotProducts.length,
        itemBuilder: (final context, final index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ProductCard(product: spotProducts[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Henüz yeni ürün bulunmamaktadır.',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildErrorState(final String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Hata: $message'),
        ],
      ),
    );
  }
}
