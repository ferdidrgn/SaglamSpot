import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import '../../../../core/common/base_notifier.dart';
import '../../../../core/services/storage_provider.dart';
import '../../domain/entites/product.dart';
import 'product_state.dart';

class ProductNotifier extends BaseNotifier<ProductState> {
  @override
  ProductState initialState() {
    // Uygulama açıldığında verileri otomatik çekmeyi tetikle
    Future.microtask(() => loadProducts());
    return const ProductState();
  }

  void reloadData() => loadProducts();

  Future<void> loadProducts() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products));

  /// Yeni Ürün Ekleme: Başarılı olursa listeyi yeniler (invalidateSelf)
  Future<void> addProduct(final Product product, final List<dynamic> images) =>
      execute(() async {
        // Benzersiz bir ID oluştur (Firestore çakışmasını önler)
        final newId = DateTime.now().millisecondsSinceEpoch.toString();
        final productWithId = product.copyWith(id: newId);

        return ref.read(addProductUseCaseProvider).call(productWithId, images);
      }, onSuccess: (final _) => ref.invalidateSelf());

  /// Ürünü Silme: Önce Storage, sonra Firestore temizliği yapar
  Future<void> deleteProduct(final Product product) => execute(() async {
        // 1. Storage Temizliği: O ürüne ait tüm resim klasörünü siler
        final storageRef =
            ref.read(storageProvider).ref().child('products/${product.id}');
        final listResult = await storageRef.listAll();
        for (final item in listResult.items) await item.delete();

        // 2. Veritabanı Silme
        return ref.read(deleteProductUseCaseProvider).call(product.id);
      }, onSuccess: (final _) => ref.invalidateSelf());

  /// Güncelleme: Veri veya görsel değiştiğinde listeyi yeniler
  Future<void> updateProduct(final Product product,
          {final List<dynamic>? newImages}) =>
      execute(() async {
        if (newImages != null && newImages.isNotEmpty) {
          await ref
              .read(productServiceProvider)
              .uploadProduct(product, newImages);
        }
        return ref.read(updateProductUseCaseProvider).call(product);
      }, onSuccess: (final _) => ref.invalidateSelf());

  // --- Yardımcı Filtre Metodları ---
  void _setProductsState(final List<Product> products) => state =
      state.copyWith(dataList: products, isLoading: false, errorMessage: null);

  Future<void> loadAvailableProducts() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products.available));

  Future<void> loadSoldProducts() =>
      execute(() => ref.read(getProductsUseCaseProvider).call(),
          onSuccess: (final products) => _setProductsState(products.sold));
}

extension ProductFilters on List<Product> {
  List<Product> get available => where((final e) => !e.isSold).toList();

  List<Product> get sold => where((final e) => e.isSold).toList();

  List<Product> get spotDeals =>
      where((final e) => e.isSpotProduct && !e.isSold).toList();

  List<Product> get newDeals =>
      where((final e) => !e.isSpotProduct && !e.isSold).toList();

  List<Product> get newest {
    final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    return available.where((final e) {
      final createdDate = DateTime.tryParse(e.createdAt) ?? DateTime(2000);
      return createdDate.isAfter(tenDaysAgo);
    }).toList();
  }
}
