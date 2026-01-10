import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import 'package:saglamspot/features/products/presentation/providers/product_state.dart';
import '../../../../core/common/base_notifier.dart';

part 'product_notifier.g.dart';

/// @riverpod Notifier
@riverpod
class ProductNotifier extends _$ProductNotifier
    with BaseNotifier<ProductState> {
  @override
  ProductState build() {
    loadProducts();
    return const ProductState();
  }

  /// Tüm ürünleri yükle
  Future<void> loadProducts() async {
    final products = await execute(
      () => ref.read(getProductsUseCaseProvider).call(),
    );
    if (products != null) _setProductsState(products);
  }

  /// Sadece mevcut (satılmamış) ürünleri yükle
  Future<void> loadAvailableProducts() async {
    final products = await execute(
      () => ref.read(getProductsUseCaseProvider).call(),
    );
    if (products != null) _setProductsState(products.available);
  }

  /// Spot ürünleri yükle
  Future<void> loadSpotProducts() async {
    final products = await execute(
      () => ref.read(getProductsUseCaseProvider).call(),
    );
    if (products != null) _setProductsState(products.spotDeals);
  }

  /// Yeni ürünler (non-spot)
  Future<void> loadNewProducts() async {
    final products = await execute(
      () => ref.read(getProductsUseCaseProvider).call(),
    );
    if (products != null) _setProductsState(products.newDeals);
  }

  /// Yeni koleksiyon ürünleri (son 10 gün)
  Future<void> loadNewArrivals() async {
    final products = await execute(
      () => ref.read(getProductsUseCaseProvider).call(),
    );
    if (products != null) _setProductsState(products.newest);
  }

  /// Satılmış ürünleri yükle
  Future<void> loadSoldProducts() async {
    final products = await execute(
      () => ref.read(getProductsUseCaseProvider).call(),
    );
    if (products != null) _setProductsState(products.sold);
  }

  /// Ürün ekle
  Future<void> addProduct(
      final Product product, final List<dynamic> images) async {
    await execute(
      () => ref.read(addProductUseCaseProvider).call(product, images),
      onSuccess: (final _) => ref.invalidateSelf(),
    );
  }

  /// Ürün güncelle
  Future<void> updateProduct(final Product product) async {
    await execute(
      () => ref.read(updateProductUseCaseProvider).call(product),
      onSuccess: (final _) => ref.invalidateSelf(),
    );
  }

  /// Ürün sil
  Future<void> deleteProduct(final String productId) async {
    await execute(
      () => ref.read(deleteProductUseCaseProvider).call(productId),
      onSuccess: (final _) => ref.invalidateSelf(),
    );
  }

  /// Sunucudan filtreli ürün çek
  Future<void> filterProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  }) async {
    final products = await execute(
      () => ref.read(filterProductUseCaseProvider).call(
            condition: condition,
            minPrice: minPrice,
            maxPrice: maxPrice,
          ),
    );
    if (products != null) _setProductsState(products);
  }

  /// Filtreleri sıfırla
  Future<void> resetFilters() => loadProducts();

  /// Arama yap
  Future<void> searchProducts({required final String query}) async {
    final products = await execute(
      () => ref.read(getProductsUseCaseProvider).call(),
    );
    if (products != null) {
      final filtered = _filterProductsByQuery(products, query);
      _setProductsState(filtered);
    }
  }

  /// Local state üzerinden spot filtre
  void filterLocalBySpot() {
    if (state.dataList != null) _setProductsState(state.dataList!.spotDeals);
  }

  /// Local state üzerinden custom filtre
  void filterLocal({
    final bool? isSpotProduct,
    final bool? isSold,
  }) {
    if (state.dataList != null) {
      var filtered = state.dataList!;
      if (isSpotProduct != null) {
        filtered = filtered
            .where((final e) => e.isSpotProduct == isSpotProduct)
            .toList();
      }
      if (isSold != null) {
        filtered = filtered.where((final e) => e.isSold == isSold).toList();
      }
      _setProductsState(filtered);
    }
  }

  /// Private: state güncelleme
  void _setProductsState(final List<Product> products) {
    state = state.copyWith(
      dataList: products,
      isLoading: false,
      errorMessage: null,
    );
  }

  /// Private: query filtreleme
  List<Product> _filterProductsByQuery(
      final List<Product> products, final String query) {
    final lowerQuery = query.toLowerCase();
    return products.where((final p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
          p.desc.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

/// Extension filtreler
extension ProductFilters on List<Product> {
  List<Product> get available => where((final e) => !e.isSold).toList();

  List<Product> get sold => where((final e) => e.isSold).toList();

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

  /// 10 günden eski ürünler
  List<Product> get older {
    final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    return available.where((final e) {
      final createdDate = DateTime.tryParse(e.createdAt) ?? DateTime(2000);
      return createdDate.isBefore(tenDaysAgo);
    }).toList();
  }
}
