// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productService)
const productServiceProvider = ProductServiceProvider._();

final class ProductServiceProvider
    extends $FunctionalProvider<ProductService, ProductService, ProductService>
    with $Provider<ProductService> {
  const ProductServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productServiceHash();

  @$internal
  @override
  $ProviderElement<ProductService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProductService create(Ref ref) {
    return productService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductService>(value),
    );
  }
}

String _$productServiceHash() => r'f0498c38bbb726f1ccad65b4d85d8410d44b095d';

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

@ProviderFor(availableProducts)
const availableProductsProvider = AvailableProductsProvider._();

final class AvailableProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  const AvailableProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'availableProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$availableProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return availableProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$availableProductsHash() => r'a65b3ea10d715e2b51dbe3e39257e672116903c4';

@ProviderFor(newArrivals)
const newArrivalsProvider = NewArrivalsProvider._();

final class NewArrivalsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  const NewArrivalsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newArrivalsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newArrivalsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return newArrivals(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$newArrivalsHash() => r'7a59e54c011ed142695adaaabbb7acdc6270e949';

@ProviderFor(spotProducts)
const spotProductsProvider = SpotProductsProvider._();

final class SpotProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  const SpotProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'spotProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$spotProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return spotProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$spotProductsHash() => r'2436dd3c7fd845f4d97deb47dbe30c1291d8632c';

@ProviderFor(soldProducts)
const soldProductsProvider = SoldProductsProvider._();

final class SoldProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  const SoldProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'soldProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$soldProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return soldProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$soldProductsHash() => r'02e718af62252af0fa81e760a622045e489bcbd5';
