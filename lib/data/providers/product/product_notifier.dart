import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/domain/usecases/product/add_product_usecase.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../domain/usecases/product/filter_product_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/search_product_usecase.dart';
import '../../../domain/usecases/product/update_product_usecase.dart';
import 'product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final FilterProductUseCase filterProductUseCase;
  final SearchProductUseCase searchProductUseCase;

  ProductNotifier(
      this.getProductsUseCase,
      this.addProductUseCase,
      this.updateProductUseCase,
      this.deleteProductUseCase,
      this.filterProductUseCase,
      this.searchProductUseCase)
      : super(ProductState());

  Future<void> loadProducts() async {
    state = ProductState(isLoading: true);
    final result = await getProductsUseCase.call();

    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final products) => state = ProductState(products: products),
    );
  }

  Future<void> addProduct(
      final Product product, final List<dynamic> images) async {
    state = ProductState(isLoading: true);
    final result = await addProductUseCase.call(product, images);
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> updateProduct(final Product product) async {
    state = ProductState(isLoading: true);
    final result = await updateProductUseCase.call(product);
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> deleteProduct(final String productId) async {
    state = ProductState(isLoading: true);
    final result = await deleteProductUseCase.call(productId);
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> filterProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  }) async {
    state = ProductState(isLoading: true);
    final result = await filterProductUseCase.call(
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
    final result = await getProductsUseCase.call(); // Tüm ürünleri yükle
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final products) => state = ProductState(products: products),
    );
  }

  Future<void> searchProducts({required final String query}) async {
    state = ProductState(isLoading: true);
    final result = await getProductsUseCase.call(); // Tüm ürünleri al
    result.fold(
      (final failure) => state = ProductState(errorMessage: failure.message),
      (final products) {
        if (query.isEmpty) {
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
