import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entites/product.dart';
import 'product_provider.dart';

part 'product_mutation_provider.g.dart';

@riverpod
class ProductMutation extends _$ProductMutation {
  @override
  FutureOr<void> build() {}

  Future<void> add(final Product product, final List<dynamic> images) async {
    await ref.read(addProductUseCaseProvider).call(product, images);
    ref.invalidate(productsProvider);
  }

  // Hata Çözümü: 'update' ismini 'updateProduct' yaptık (AsyncNotifier ile çakışıyordu)
  Future<void> updateProduct(final Product product) async {
    await ref.read(updateProductUseCaseProvider).call(product);
    ref.invalidate(productsProvider);
  }

  Future<void> delete(final String id) async {
    await ref.read(deleteProductUseCaseProvider).call(id);
    ref.invalidate(productsProvider);
  }
}
