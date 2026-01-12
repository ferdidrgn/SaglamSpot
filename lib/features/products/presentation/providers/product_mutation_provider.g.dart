// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_mutation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductMutation)
const productMutationProvider = ProductMutationProvider._();

final class ProductMutationProvider
    extends $AsyncNotifierProvider<ProductMutation, void> {
  const ProductMutationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productMutationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productMutationHash();

  @$internal
  @override
  ProductMutation create() => ProductMutation();
}

String _$productMutationHash() => r'b12ccc57a2fa90e82208bacc8cedc5efee2a06d5';

abstract class _$ProductMutation extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleValue(ref, null);
  }
}
