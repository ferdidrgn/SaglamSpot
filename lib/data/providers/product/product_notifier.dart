import 'package:saglamspot/data/providers/product/product_provider.dart';
import '../../../core/common/base_notifier_with_network_checker.dart';
import '../../../domain/entities/product.dart';
import 'product_state.dart';

class ProductNotifier extends BaseNotifier<ProductState> {
  @override
  ProductState initialState() => const ProductState();

  @override
  void reloadData() => loadProducts();

  Future<void> loadProducts() => execute(
      () => ref.read(getProductsUseCaseProvider).call(),
      onSuccess: (final products) => _setProductsState(products));

  Future<void> addProduct(final Product product, final List<dynamic> images) =>
      execute(
          () => ref.read(addProductUseCaseProvider).call(product, images),
          onSuccess: (final _) => loadProducts());

  Future<void> updateProduct(final Product product) => execute(
      () => ref.read(updateProductUseCaseProvider).call(product),
      onSuccess: (final _) => loadProducts());

  Future<void> deleteProduct(final String productId) =>
      execute(
          () => ref.read(deleteProductUseCaseProvider).call(productId),
          onSuccess: (final _) => loadProducts());

  Future<void> filterProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  }) =>
      execute(
          () => ref.read(filterProductUseCaseProvider).call(
              condition: condition, minPrice: minPrice, maxPrice: maxPrice),
          onSuccess: (final products) => _setProductsState(products));

  Future<void> resetFilters() => loadProducts();

  Future<void> searchProducts({required final String query}) =>
      execute(
          () => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) {
        final filteredProducts = _filterProductsByQuery(products, query);
        _setProductsState(filteredProducts);
      });

  List<Product> _filterProductsByQuery(
      final List<Product> products, final String query) {
    final lowerCaseQuery = query.toLowerCase();
    return products.where((final product) {
      return product.name.toLowerCase().contains(lowerCaseQuery) ||
          product.desc.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  void _setProductsState(final List<Product> products) {
    state = state.copyWith(
        dataList: products, isLoading: false, errorMessage: null);
  }
}

extension ProductFilters on List<Product> {
  List<Product> get available => where((e) => !e.isSold).toList();

  List<Product> get sold => where((e) => e.isSold).toList();

  List<Product> get spot => where((e) => e.isSpotProduct && !e.isSold).toList();

  //List<Product> get featured => where((e) => e.isFeatured && !e.isSold).toList();
}
