import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import 'product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductNotifier(this.repository) : super(ProductState());

  Future<void> loadProducts() async {
    state = ProductState(isLoading: true);
    final result = await repository.getProducts();
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final products) => state = ProductState(products: products),
    );
  }

  Future<void> addProduct(
      final Product product, final List<dynamic> images) async {
    state = ProductState(isLoading: true);
    final result = await repository.addProduct(product, images);
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> updateProduct(final Product product) async {
    state = ProductState(isLoading: true);
    final result = await repository.updateProduct(product);
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> deleteProduct(final String productId) async {
    state = ProductState(isLoading: true);
    final result = await repository.deleteProduct(productId);
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> filterProducts(
      {final String? condition,
      final double? minPrice,
      final double? maxPrice}) async {
    state = ProductState(isLoading: true);
    final result = await repository.getFilteredProducts(
      condition: condition,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final products) => state = ProductState(products: products),
    );
  }

  Future<void> resetFilters() async {
    state = ProductState(isLoading: true);
    final result = await repository.getProducts(); // Tüm ürünleri yükle
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final products) => state = ProductState(products: products),
    );
  }

  Future<void> searchProducts({final String? query}) async {
    state = ProductState(isLoading: true);
    final result = await repository.getProducts();
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final products) {
        if (query == null || query.isEmpty) {
          state = ProductState(products: products);
          return;
        }
        final filteredProducts = _filterProductsByQuery(products, query);
        state = ProductState(products: filteredProducts);
      },
    );
  }

  List<Product> _filterProductsByQuery(
      final List<Product> products, final String query) {
    final lowerCaseQuery = query.toLowerCase();
    return products.where((final product) {
      return product.name.toLowerCase().contains(lowerCaseQuery) ||
          product.desc.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }
}
