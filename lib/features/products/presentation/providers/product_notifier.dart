import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import 'package:saglamspot/features/products/presentation/providers/product_state.dart';
import '../../../../core/common/base_result.dart';
import '../../domain/entites/product.dart';

part 'product_notifier.g.dart';

@riverpod
class ProductNotifier extends _$ProductNotifier with BaseResultHandler {
  @override
  ProductState build() {
    // Build döngüsünü bozmadan ilk yüklemeyi başlat
    Future.microtask(() => loadProducts());
    return const ProductState();
  }

  /// Merkezi veri çekme fonksiyonu
  Future<List<Product>?> _fetchRawProducts(final String tag) =>
      handleResult(() => ref.read(getProductsUseCaseProvider).call(),
          operationTag: tag);

  Future<void> loadProducts() async {
    final products = await _fetchRawProducts('LoadProducts');
    if (products != null) _setProductsState(products);
  }

  Future<void> loadAvailableProducts() async {
    final products = await _fetchRawProducts('LoadAvailable');
    if (products != null) _setProductsState(products.available);
  }

  Future<void> loadSpotProducts() async {
    final products = await _fetchRawProducts('LoadSpot');
    if (products != null) _setProductsState(products.spotDeals);
  }

  Future<void> loadNewProducts() async {
    final products = await _fetchRawProducts('LoadNew');
    if (products != null) _setProductsState(products.newDeals);
  }

  Future<void> loadNewArrivals() async {
    final products = await _fetchRawProducts('LoadNewArrivals');
    if (products != null) _setProductsState(products.newest);
  }

  Future<void> loadSoldProducts() async {
    final products = await _fetchRawProducts('LoadSold');
    if (products != null) _setProductsState(products.sold);
  }

  Future<void> addProduct(
      final Product product, final List<dynamic> images) async {
    await handleResult(
        () => ref.read(addProductUseCaseProvider).call(product, images),
        operationTag: 'AddProduct');
    ref.invalidateSelf();
  }

  Future<void> updateProduct(final Product product) async {
    await handleResult(
        () => ref.read(updateProductUseCaseProvider).call(product),
        operationTag: 'UpdateProduct');
    ref.invalidateSelf();
  }

  Future<void> deleteProduct(final String productId) async {
    await handleResult(
        () => ref.read(deleteProductUseCaseProvider).call(productId),
        operationTag: 'DeleteProduct');
    ref.invalidateSelf();
  }

  Future<void> searchProducts({required final String query}) async {
    final products = await _fetchRawProducts('SearchProducts');
    if (products != null) {
      final filtered = products
          .where((final p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.desc.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _setProductsState(filtered);
    }
  }

  void filterLocalBySpot() {
    if (state.dataList != null) _setProductsState(state.dataList!.spotDeals);
  }

  void _setProductsState(final List<Product> products) => state =
      state.copyWith(dataList: products, isLoading: false, errorMessage: null);
}

/// Performans odaklı Extension filtreler
extension ProductFilters on List<Product> {
  ///mixed
  List<Product> get available => where((final e) => !e.isSold).toList();
  List<Product> get sold => where((final e) => e.isSold).toList();

  ///sell
  List<Product> get spotDeals =>
      where((final e) => e.isSpotProduct && !e.isSold).toList();

  List<Product> get newDeals =>
      where((final e) => !e.isSpotProduct && !e.isSold).toList();

  /// Son 10 gün içinde eklenen mevcut ürünler
  List<Product> get newest {
    final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    return available.where((final e) {
      final createdDate = DateTime.tryParse(e.createdAt) ?? DateTime(2000);
      return createdDate.isAfter(tenDaysAgo);
    }).toList();
  }

  ///sold
  List<Product> get spotSold =>
      where((final e) => e.isSpotProduct && e.isSold).toList();

  List<Product> get newSold =>
      where((final e) => !e.isSpotProduct && e.isSold).toList();
}
