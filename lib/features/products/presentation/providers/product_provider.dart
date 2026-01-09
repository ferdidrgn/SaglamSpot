import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/features/products/presentation/providers/product_notifier.dart';
import 'package:saglamspot/features/products/presentation/providers/product_service.dart';
import '../../domain/entites/product.dart';
import '../../domain/repositories/product_repository_provider.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/filter_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import 'product_state.dart';

final productServiceProvider =
    Provider<ProductService>((final ref) => ProductService());

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
