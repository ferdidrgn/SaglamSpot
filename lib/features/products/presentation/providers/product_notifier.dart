import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/storage_provider.dart';
import '../../domain/entites/product.dart';
import 'product_provider.dart';
import 'product_state.dart';

part 'product_notifier.g.dart';

@riverpod
class ProductNotifier extends _$ProductNotifier {
  @override
  ProductState build() {
    // Uygulama açıldığında verileri çek
    Future.microtask(() => loadProducts());
    return const ProductState();
  }

  Future<void> loadProducts() async {
    final getProducts = ref.read(getProductsUseCaseProvider);
    final result = await getProducts.call();

    result.fold(
      (final l) =>
          state = state.copyWith(errorMessage: l.message, isLoading: false),
      (final r) => state =
          state.copyWith(dataList: r, isLoading: false, errorMessage: null),
    );
  }

  Future<void> addProduct(
      final Product product, final List<dynamic> images) async {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final productWithId = product.copyWith(id: newId);
    await ref.read(addProductUseCaseProvider).call(productWithId, images);
    ref.invalidateSelf();
  }

  Future<void> deleteProduct(final Product product) async {
    final storageRef =
        ref.read(storageProvider).ref().child('products/${product.id}');
    final listResult = await storageRef.listAll();
    for (final item in listResult.items) await item.delete();

    await ref.read(deleteProductUseCaseProvider).call(product.id);
    ref.invalidateSelf();
  }
}

// Extension filtreleri (Provider'lar bunları kullanacak)
extension ProductFilters on List<Product> {
  List<Product> get available => where((final e) => !e.isSold).toList();

  List<Product> get sold => where((final e) => e.isSold).toList();

  List<Product> get spotDeals =>
      where((final e) => e.isSpotProduct && !e.isSold).toList();

  List<Product> get newest {
    final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    return available.where((final e) {
      final createdDate = DateTime.tryParse(e.createdAt) ?? DateTime(2000);
      return createdDate.isAfter(tenDaysAgo);
    }).toList();
  }
}
