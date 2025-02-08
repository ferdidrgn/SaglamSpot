import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/domain/entities/product.dart';
import '../../../domain/usecases/product/add_product_usecase.dart';
import '../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../domain/usecases/product/filter_product_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/update_product_usecase.dart';
import 'product_state.dart';

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final FilterProductUseCase filterProductUseCase;

  ProductNotifier(
    this.getProductsUseCase,
    this.addProductUseCase,
    this.updateProductUseCase,
    this.deleteProductUseCase,
    this.filterProductUseCase,
  ) : super(ProductState()) {
    loadProducts(); // Uygulama başladığında ürünleri yükle
  }

  Future<void> loadProducts() async {
    _setLoadingState(true);
    final result = await getProductsUseCase.call();

    result.fold(
      (final failure) => _setErrorState(failure.message),
      (final products) => _setProductsState(products),
    );
  }

  Future<void> addProduct(
      final Product product, final List<dynamic> images) async {
    _setLoadingState(true);
    final result = await addProductUseCase.call(product, images);

    result.fold(
      (final failure) => _setErrorState(failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> updateProduct(final Product product) async {
    _setLoadingState(true);
    final result = await updateProductUseCase.call(product);

    result.fold(
      (final failure) => _setErrorState(failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> deleteProduct(final String productId) async {
    _setLoadingState(true);
    final result = await deleteProductUseCase.call(productId);

    result.fold(
      (final failure) => _setErrorState(failure.message),
      (final _) => loadProducts(),
    );
  }

  Future<void> filterProducts(
      {final String? condition,
      final double? minPrice,
      final double? maxPrice}) async {
    _setLoadingState(true);
    final result = await filterProductUseCase.call(
        condition: condition, minPrice: minPrice, maxPrice: maxPrice);

    result.fold(
      (final failure) => _setErrorState(failure.message),
      (final products) => _setProductsState(products),
    );
  }

  Future<void> resetFilters() async {
    await loadProducts(); // Tüm ürünleri yükle
  }

  Future<void> searchProducts({required final String query}) async {
    _setLoadingState(true);
    final result = await getProductsUseCase.call(); // Tüm ürünleri al

    result.fold(
      (final failure) => _setErrorState(failure.message),
      (final products) {
        if (query.isEmpty) {
          _setProductsState(products);
          return;
        }
        final filteredProducts = _filterProductsByQuery(products, query);
        _setProductsState(filteredProducts);
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

  void _setLoadingState(final bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void _setErrorState(final String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage, isLoading: false);
  }

  void _setProductsState(final List<Product> products) {
    state = state.copyWith(products: products, isLoading: false);
  }
}
