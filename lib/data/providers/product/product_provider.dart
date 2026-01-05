import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/product_repository_provider.dart';
import '../../../domain/usecases/product/add_product_usecase.dart';
import '../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../domain/usecases/product/filter_product_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/update_product_usecase.dart';
import '../../../domain/entities/product.dart'; // Product entity importu
import 'product_notifier.dart';
import 'product_state.dart';

final productProvider =
    NotifierProvider<ProductNotifier, ProductState>(ProductNotifier.new);

// --- ProductsUseCase providers (Mevcut olanlar) ---
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((final ref) =>
    GetProductsUseCaseImpl(ref.watch(productRepositoryProvider)));

final addProductUseCaseProvider = Provider<AddProductUseCase>(
    (final ref) => AddProductUseCaseImpl(ref.watch(productRepositoryProvider)));

final updateProductUseCaseProvider = Provider<UpdateProductUseCase>(
    (final ref) =>
        UpdateProductUseCaseImpl(ref.watch(productRepositoryProvider)));

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>(
    (final ref) =>
        DeleteProductUseCaseImpl(ref.watch(productRepositoryProvider)));

final filterProductUseCaseProvider = Provider<FilterProductUseCase>(
    (final ref) =>
        FilterProductUseCaseImpl(ref.watch(productRepositoryProvider)));

// ===================================================================
// --- YENİ EKLENEN FİLTRELEYİCİ PROVIDER'LAR ---
// ===================================================================

/// Sadece aktif (satılmamış) stok listesini döner
final availableProductsProvider = Provider<List<Product>>((final ref) {
  final allProducts = ref.watch(productProvider).dataList ?? [];
  return allProducts.available; // Extension'dan geliyor
});

/// Sadece son 7 günde eklenen yeni ürünleri (New Collection) döner
final newArrivalsProvider = Provider<List<Product>>((final ref) {
  final allProducts = ref.watch(productProvider).dataList ?? [];
  return allProducts.newest; // Extension'dan geliyor
});

/// Sadece spot fırsat ürünlerini döner
final spotProductsProvider = Provider<List<Product>>((final ref) {
  final allProducts = ref.watch(productProvider).dataList ?? [];
  return allProducts.spotDeals; // Extension'dan geliyor
});

final newProductsProvider = Provider<List<Product>>((final ref) {
  final allProducts = ref.watch(productProvider).dataList ?? [];
  return allProducts.newDeals; // Extension'dan geliyor
});

/// Satılmış ürünlerin geçmişini döner
final soldProductsProvider = Provider<List<Product>>((final ref) {
  final allProducts = ref.watch(productProvider).dataList ?? [];
  return allProducts.sold; // Extension'dan geliyor
});
