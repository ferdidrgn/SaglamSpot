import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import '../../../../core/common/base_notifier.dart';
import '../../../../core/services/storage_provider.dart';
import '../../domain/entites/product.dart';
import 'product_state.dart';

class ProductNotifier extends BaseNotifier<ProductState> {
  @override
  ProductState initialState() => const ProductState();

  void reloadData() => loadProducts();

  Future<void> loadProducts() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products));

  Future<void> addProduct(final Product product, final List<dynamic> images) =>
      execute(() => ref.read(addProductUseCaseProvider).call(product, images),
          onSuccess: (final _) => ref.invalidateSelf());

  // Listeyi yeniden çekmek yerine state'i invalidate edip
  // providers'ın kendini refresh etmesini sağlamak Riverpod 3 tarzıdır.

  // Ürünü silerken hem Firestore'dan hem Storage'dan temizlik yapar
  Future<void> deleteProduct(final Product product) => execute(() async {
        // 1. Storage Temizliği: O ürüne ait tüm resim klasörünü siler
        final storageRef =
            ref.read(storageProvider).ref().child('products/${product.id}');
        final listResult = await storageRef.listAll();
        for (final item in listResult.items) await item.delete();

        // 2. Veritabanı Silme
        return ref.read(deleteProductUseCaseProvider).call(product.id);
      }, onSuccess: (final _) => ref.invalidateSelf());

  // Güncelleme sırasında yeni görseller gelirse otomatik yükler
  Future<void> updateProduct(final Product product,
          {final List<dynamic>? newImages}) =>
      execute(() async {
        if (newImages != null && newImages.isNotEmpty) {
          // Yeni görselleri yükler (ProductService içindeki mantıkla)
          await ref
              .read(productServiceProvider)
              .uploadProduct(product, newImages);
        }
        return ref.read(updateProductUseCaseProvider).call(product);
      }, onSuccess: (final _) => ref.invalidateSelf());

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
      execute(() => ref.read(getProductsUseCaseProvider).call(),
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

  /// Sadece mevcut (satılmamış) ürünleri yükler
  Future<void> loadAvailableProducts() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products.available));

  /// Sadece spot (fırsat) ürünlerini yükler
  Future<void> loadSpotProducts() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products.spotDeals));

  /// Sadece Sıfır (fırsat) ürünlerini yükler
  Future<void> loadNewProducts() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products.newDeals));

  /// Yeni koleksiyon ürünlerini yükler (Son 10 gün)
  Future<void> loadNewArrivals() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products.newest));

  /// Satılmış ürünlerin geçmişini yükler
  Future<void> loadSoldProducts() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products.sold));

  // Not: Eğer veriyi sunucudan tekrar çekmeden sadece yerel listede
  // filtreleme yapmak istersen 'execute' kullanmadan state'i güncelleyebilirsin.
  void filterLocalBySpot() {
    if (state.dataList != null) _setProductsState(state.dataList!.spotDeals);
  }

  void _setProductsState(final List<Product> products) => state =
      state.copyWith(dataList: products, isLoading: false, errorMessage: null);
}

extension ProductFilters on List<Product> {
  /// Returns products that are currently in stock (not sold)
  List<Product> get available => where((final e) => !e.isSold).toList();

  /// Returns products that have already been sold
  List<Product> get sold => where((final e) => e.isSold).toList();

  /// Returns available products marked as spot deals
  List<Product> get spotDeals =>
      where((final e) => e.isSpotProduct && !e.isSold).toList();

  List<Product> get newDeals =>
      where((final e) => !e.isSpotProduct && !e.isSold).toList();

  /// Son 7 gün içinde eklenen mevcut ürünler (New Collection)
  List<Product> get newest {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    return available.where((final e) {
      // String tarihi DateTime'a parse ediyoruz
      final createdDate = DateTime.tryParse(e.createdAt) ?? DateTime(2000);
      return createdDate.isAfter(sevenDaysAgo);
    }).toList();
  }

  /// 7 günden daha eski mevcut ürünler
  List<Product> get older {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    return available.where((final e) {
      // String tarihi DateTime'a parse ediyoruz
      final createdDate = DateTime.tryParse(e.createdAt) ?? DateTime(2000);
      return createdDate.isBefore(sevenDaysAgo);
    }).toList();
  }

  /// Optional: Featured products for the hero section
// List<Product> get featured => where((final e) => e.isFeatured && !e.isSold).toList();
}
