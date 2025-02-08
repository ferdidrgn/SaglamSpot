import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/product_repository_provider.dart';
import '../../../domain/usecases/product/add_product_usecase.dart';
import '../../../domain/usecases/product/delete_product_usecase.dart';
import '../../../domain/usecases/product/filter_product_usecase.dart';
import '../../../domain/usecases/product/get_products_usecase.dart';
import '../../../domain/usecases/product/update_product_usecase.dart';
import 'product_notifier.dart';
import 'product_state.dart';

final productProvider =
    StateNotifierProvider<ProductNotifier, ProductState>((final ref) {
  final getProductsUseCase = ref.watch(getProductsUseCaseProvider);
  final addProductUseCase = ref.watch(addProductUseCaseProvider);
  final updateProductUseCase = ref.watch(updateProductUseCaseProvider);
  final deleteProductUseCase = ref.watch(deleteProductUseCaseProvider);
  final filterProductUseCase = ref.watch(filterProductUseCaseProvider);

  return ProductNotifier(
      getProductsUseCase,
      addProductUseCase,
      updateProductUseCase,
      deleteProductUseCase,
      filterProductUseCase
  );
});

// ProductsUseCase providers

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((final ref) {
  final repository = ref.watch(
      productRepositoryProvider); // ProductRepository provider'ını kullan
  return GetProductsUseCaseImpl(repository); // Use case'i döndür
});

final addProductUseCaseProvider = Provider<AddProductUseCase>((final ref) {
  final repository = ref.watch(productRepositoryProvider);
  return AddProductUseCaseImpl(repository);
});

final updateProductUseCaseProvider =
    Provider<UpdateProductUseCase>((final ref) {
  final repository = ref.watch(productRepositoryProvider);
  return UpdateProductUseCaseImpl(repository);
});

final deleteProductUseCaseProvider =
    Provider<DeleteProductUseCase>((final ref) {
  final repository = ref.watch(productRepositoryProvider);
  return DeleteProductUseCaseImpl(repository);
});

final filterProductUseCaseProvider =
    Provider<FilterProductUseCase>((final ref) {
  final repository = ref.watch(productRepositoryProvider);
  return FilterProductUseCaseImpl(repository);
});
