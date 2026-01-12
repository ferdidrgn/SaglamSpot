// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_filters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$availableProductsHash() => r'057bb0a9e734bc4f75f124ee3ecfb40726e6f174';

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

String _$soldProductsHash() => r'a80c75d9d7381206a35e70778cf20817fb6bbe9d';

/// Stoktaki İKİNCİ EL (Spot) ürünler

@ProviderFor(spotDealsProducts)
const spotDealsProductsProvider = SpotDealsProductsProvider._();

/// Stoktaki İKİNCİ EL (Spot) ürünler

final class SpotDealsProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  /// Stoktaki İKİNCİ EL (Spot) ürünler
  const SpotDealsProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'spotDealsProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$spotDealsProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return spotDealsProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$spotDealsProductsHash() => r'9ca4f2a60f688a6c938927cc6bd663d1928e7878';

/// Stoktaki SIFIR ürünler

@ProviderFor(newDealsProducts)
const newDealsProductsProvider = NewDealsProductsProvider._();

/// Stoktaki SIFIR ürünler

final class NewDealsProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  /// Stoktaki SIFIR ürünler
  const NewDealsProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newDealsProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newDealsProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return newDealsProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$newDealsProductsHash() => r'7b187ba646d7082e8cd38a1ef1c6de18dc04809b';

/// Stoktaki YENİ GELENLER (Son 10 gün)

@ProviderFor(newArrivalsProducts)
const newArrivalsProductsProvider = NewArrivalsProductsProvider._();

/// Stoktaki YENİ GELENLER (Son 10 gün)

final class NewArrivalsProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  /// Stoktaki YENİ GELENLER (Son 10 gün)
  const NewArrivalsProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newArrivalsProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newArrivalsProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return newArrivalsProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$newArrivalsProductsHash() =>
    r'f54a70733cc7464f5ea128c2c2ce767d1e2a21bd';

/// Satılmış İKİNCİ EL ürünler

@ProviderFor(spotSoldProducts)
const spotSoldProductsProvider = SpotSoldProductsProvider._();

/// Satılmış İKİNCİ EL ürünler

final class SpotSoldProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  /// Satılmış İKİNCİ EL ürünler
  const SpotSoldProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'spotSoldProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$spotSoldProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return spotSoldProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$spotSoldProductsHash() => r'bb039ddd106da124a890dc11546e9ed7f962cecb';

/// Satılmış SIFIR ürünler

@ProviderFor(newSoldProducts)
const newSoldProductsProvider = NewSoldProductsProvider._();

/// Satılmış SIFIR ürünler

final class NewSoldProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  /// Satılmış SIFIR ürünler
  const NewSoldProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'newSoldProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$newSoldProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return newSoldProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$newSoldProductsHash() => r'24826ea963c243a4774f234984c8f2dffb6fd602';
