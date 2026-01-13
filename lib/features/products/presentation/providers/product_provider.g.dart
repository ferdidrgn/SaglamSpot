// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getProductsUseCase)
const getProductsUseCaseProvider = GetProductsUseCaseProvider._();

final class GetProductsUseCaseProvider extends $FunctionalProvider<
    GetProductsUseCase,
    GetProductsUseCase,
    GetProductsUseCase> with $Provider<GetProductsUseCase> {
  const GetProductsUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getProductsUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getProductsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetProductsUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetProductsUseCase create(Ref ref) {
    return getProductsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetProductsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetProductsUseCase>(value),
    );
  }
}

String _$getProductsUseCaseHash() =>
    r'f06417a1b9ee367e6f0f8eca4dc2ffe47756e226';

@ProviderFor(addProductUseCase)
const addProductUseCaseProvider = AddProductUseCaseProvider._();

final class AddProductUseCaseProvider extends $FunctionalProvider<
    AddProductUseCase,
    AddProductUseCase,
    AddProductUseCase> with $Provider<AddProductUseCase> {
  const AddProductUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'addProductUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$addProductUseCaseHash();

  @$internal
  @override
  $ProviderElement<AddProductUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddProductUseCase create(Ref ref) {
    return addProductUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddProductUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddProductUseCase>(value),
    );
  }
}

String _$addProductUseCaseHash() => r'e7d2abc9e0f92594883e97b1f2d1e2fbe8a2d51d';

@ProviderFor(updateProductUseCase)
const updateProductUseCaseProvider = UpdateProductUseCaseProvider._();

final class UpdateProductUseCaseProvider extends $FunctionalProvider<
    UpdateProductUseCase,
    UpdateProductUseCase,
    UpdateProductUseCase> with $Provider<UpdateProductUseCase> {
  const UpdateProductUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updateProductUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updateProductUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateProductUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateProductUseCase create(Ref ref) {
    return updateProductUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProductUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProductUseCase>(value),
    );
  }
}

String _$updateProductUseCaseHash() =>
    r'5799aff3f2c663c575fe607a2dabd08da1dbd786';

@ProviderFor(deleteProductUseCase)
const deleteProductUseCaseProvider = DeleteProductUseCaseProvider._();

final class DeleteProductUseCaseProvider extends $FunctionalProvider<
    DeleteProductUseCase,
    DeleteProductUseCase,
    DeleteProductUseCase> with $Provider<DeleteProductUseCase> {
  const DeleteProductUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deleteProductUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deleteProductUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteProductUseCase> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteProductUseCase create(Ref ref) {
    return deleteProductUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteProductUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteProductUseCase>(value),
    );
  }
}

String _$deleteProductUseCaseHash() =>
    r'56dbec5d4cc513cae4602b2e2d816bc0a9fa724d';

@ProviderFor(products)
const productsProvider = ProductsProvider._();

final class ProductsProvider extends $FunctionalProvider<
        AsyncValue<List<Product>>, List<Product>, FutureOr<List<Product>>>
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return products(ref);
  }
}

String _$productsHash() => r'e890b2361e73575935ab5ec397871d5993de7fc6';
