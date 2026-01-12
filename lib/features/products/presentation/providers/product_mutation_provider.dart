import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entites/product.dart';
import 'product_provider.dart';

part 'product_mutation_provider.g.dart';

@riverpod
class ProductMutation extends _$ProductMutation {
  @override
  FutureOr<void> build() {}

  // ÜRÜN EKLEME
  Future<void> add(final Product product, final List<dynamic> images) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // UseCase çağrısı ve otomatik hata fırlatma
      await ref.read(addProductUseCaseProvider).call(product, images);
      ref.invalidate(productsProvider);
    });
  }

  // ÜRÜN GÜNCELLEME
  Future<void> updateProduct(
      final Product product, final List<dynamic>? newImages) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateProductUseCaseProvider).call(product, newImages);
      ref.invalidate(productsProvider);
    });
  }

  // ÜRÜN SİLME
  Future<void> delete(final String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(deleteProductUseCaseProvider).call(id);
      ref.invalidate(productsProvider);
    });
  }
}
