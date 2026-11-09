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

  /// Admin paneldeki toplu "Satıldı işaretle" aksiyonu — galeri/fotoğraf
  /// değişmez (`newImages: null`), sadece `isSold` güncellenir.
  Future<void> markSold(final List<Product> products) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(updateProductUseCaseProvider);
      for (final product in products) {
        await useCase.call(product.copyWith(isSold: true), null);
      }
    });
    if (!ref.mounted) return;
    ref.invalidate(productsProvider);
  }

  /// Toplu "Satıldı işaretle"nin SnackBar'daki "Geri al"ı — `markSold`
  /// sadece önceden stokta olan ürünlere uygulandığı için burası da
  /// güvenle hepsini stoğa geri döndürebilir.
  Future<void> markAvailable(final List<Product> products) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(updateProductUseCaseProvider);
      for (final product in products) {
        await useCase.call(product.copyWith(isSold: false), null);
      }
    });
    if (!ref.mounted) return;
    ref.invalidate(productsProvider);
  }

  /// Admin paneldeki toplu "Sil" aksiyonu — tek tek `deleteProductUseCase`
  /// çağırır (TicketApp'in silme öncesi bilet kontrolü gibi bir bağımlılık
  /// SaglamSpot'ta yok, bu yüzden ek bir sunucu kontrolüne gerek kalmadan
  /// doğrudan silinir; UI tarafında onay zaten zorunlu).
  Future<void> deleteMany(final List<String> ids) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(deleteProductUseCaseProvider);
      for (final id in ids) {
        await useCase.call(id);
      }
    });
    if (!ref.mounted) return;
    ref.invalidate(productsProvider);
  }
}
