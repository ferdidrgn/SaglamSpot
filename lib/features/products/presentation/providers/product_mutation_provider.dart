import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entites/product.dart';
import 'product_provider.dart';

part 'product_mutation_provider.g.dart';

@riverpod
class ProductMutation extends _$ProductMutation {
  @override
  FutureOr<void> build() {}

  Future<void> add(final Product product, final List<dynamic> images) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      await ref.read(addProductUseCaseProvider).call(product, images);
    });

    if (!ref.mounted) return;

    state = result;
    ref.invalidate(productsProvider);
  }

  Future<void> updateProduct(
      final Product product, final List<dynamic>? newImages) async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      await ref.read(updateProductUseCaseProvider).call(product, newImages);
    });

    if (!ref.mounted) return;

    state = result;
    ref.invalidate(productsProvider);
  }

  Future<void> delete(final String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(deleteProductUseCaseProvider).call(id));
  }
}
