import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saglamspot/features/products/presentation/providers/product_notifier.dart';
import 'package:saglamspot/features/products/presentation/providers/product_service.dart';
import '../../domain/entites/product.dart';
import '../../domain/repositories/product_repository_provider.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';

part 'product_provider.g.dart';

@riverpod
ProductService productService(final Ref ref) => ProductService();

@riverpod
GetProductsUseCase getProductsUseCase(final Ref ref) =>
    GetProductsUseCaseImpl(ref.watch(productRepositoryProvider));

@riverpod
AddProductUseCase addProductUseCase(final Ref ref) =>
    AddProductUseCaseImpl(ref.watch(productRepositoryProvider));

@riverpod
UpdateProductUseCase updateProductUseCase(final Ref ref) =>
    UpdateProductUseCaseImpl(ref.watch(productRepositoryProvider));

@riverpod
DeleteProductUseCase deleteProductUseCase(final Ref ref) =>
    DeleteProductUseCaseImpl(ref.watch(productRepositoryProvider));

// --- FİLTRELEYİCİ PROVIDER'LAR ---

///mixed
@riverpod
List<Product> availableProducts(final Ref ref) {
  // Not: productNotifierProvider isminin çıkması için product_notifier.g.dart oluşmuş olmalı
  final state = ref.watch(productProvider);
  return (state.dataList ?? []).available;
}

@riverpod
List<Product> soldProducts(final Ref ref) {
  // Not: productNotifierProvider isminin çıkması için product_notifier.g.dart oluşmuş olmalı
  final state = ref.watch(productProvider);
  return (state.dataList ?? []).sold;
}

///sell
@riverpod
List<Product> newArrivals(final Ref ref) {
  final state = ref.watch(productProvider);
  return (state.dataList ?? []).newest;
}

@riverpod
List<Product> spotDealsProducts(final Ref ref) {
  final state = ref.watch(productProvider);
  return (state.dataList ?? []).spotDeals;
}

@riverpod
List<Product> newDealsProducts(final Ref ref) {
  final state = ref.watch(productProvider);
  return (state.dataList ?? []).newDeals;
}

///sold
@riverpod
List<Product> spotSoldProducts(final Ref ref) {
  final state = ref.watch(productProvider);
  return (state.dataList ?? []).spotSold;
}

@riverpod
List<Product> newSoldProducts(final Ref ref) {
  final state = ref.watch(productProvider);
  return (state.dataList ?? []).newSold;
}
