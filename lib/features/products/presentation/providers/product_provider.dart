import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entites/product.dart';
import '../../domain/repositories/product_repository_provider.dart';
import '../../domain/usecases/add_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';

part 'product_provider.g.dart';

// --- UseCase Provider'ları (Hataları çözen kısım) ---
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

// --- Ana Veri Kaynağı ---
@riverpod
Future<List<Product>> products(final Ref ref) async {
  final useCase = ref.watch(getProductsUseCaseProvider);
  final result = await useCase.call();

  return ref.watch(getProductsUseCaseProvider).call().getOrThrow();
}
