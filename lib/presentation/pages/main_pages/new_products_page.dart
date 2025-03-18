import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../domain/entities/product.dart';

class NewProductsPage extends ConsumerWidget {
  const NewProductsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final productState = ref.watch(productProvider);

    return Scaffold(
        body: productState.isLoading
            ? _buildLoadingState()
            : productState.errorMessage != null
                ? _buildErrorState(productState.errorMessage!)
                : _buildContentState(productState.products));
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 24),
          Text('Yeni ürünler yükleniyor...'),
        ],
      ),
    );
  }

  Widget _buildContentState(final List<Product> products) {
    final newProducts =
        products.where((final p) => !p.isSold && !p.isSpotProduct).toList();

    if (newProducts.isEmpty) {
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
        itemCount: newProducts.length,
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
              child: ProductCard(product: newProducts[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Henüz yeni ürün bulunmamaktadır.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
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
