// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sadece arama metnini tutar

@ProviderFor(SearchQuery)
const searchQueryProvider = SearchQueryProvider._();

/// Sadece arama metnini tutar
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// Sadece arama metnini tutar
  const SearchQueryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchQueryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'1255a1cce2d67e66f98d54fea6445539e28dc0d9';

/// Sadece arama metnini tutar

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// Sadece aktif filtreleri tutar (Record kullanarak state sınıfı yazmaktan kurtulduk)

@ProviderFor(SearchFilters)
const searchFiltersProvider = SearchFiltersProvider._();

/// Sadece aktif filtreleri tutar (Record kullanarak state sınıfı yazmaktan kurtulduk)
final class SearchFiltersProvider extends $NotifierProvider<
    SearchFilters,
    ({
      ProductCategory? category,
      String? condition,
      double maxPrice,
      double minPrice,
    })> {
  /// Sadece aktif filtreleri tutar (Record kullanarak state sınıfı yazmaktan kurtulduk)
  const SearchFiltersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchFiltersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchFiltersHash();

  @$internal
  @override
  SearchFilters create() => SearchFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
      ({
        ProductCategory? category,
        String? condition,
        double maxPrice,
        double minPrice,
      }) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<
          ({
            ProductCategory? category,
            String? condition,
            double maxPrice,
            double minPrice,
          })>(value),
    );
  }
}

String _$searchFiltersHash() => r'e2a8d4acc5a40f3f562d039f224607d581c4aaff';

/// Sadece aktif filtreleri tutar (Record kullanarak state sınıfı yazmaktan kurtulduk)

abstract class _$SearchFilters extends $Notifier<
    ({
      ProductCategory? category,
      String? condition,
      double maxPrice,
      double minPrice,
    })> {
  ({
    ProductCategory? category,
    String? condition,
    double maxPrice,
    double minPrice,
  }) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<
        ({
          ProductCategory? category,
          String? condition,
          double maxPrice,
          double minPrice,
        }),
        ({
          ProductCategory? category,
          String? condition,
          double maxPrice,
          double minPrice,
        })>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<
            ({
              ProductCategory? category,
              String? condition,
              double maxPrice,
              double minPrice,
            }),
            ({
              ProductCategory? category,
              String? condition,
              double maxPrice,
              double minPrice,
            })>,
        ({
          ProductCategory? category,
          String? condition,
          double maxPrice,
          double minPrice,
        }),
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(searchedProducts)
const searchedProductsProvider = SearchedProductsProvider._();

final class SearchedProductsProvider extends $FunctionalProvider<
    AsyncValue<List<Product>>,
    AsyncValue<List<Product>>,
    AsyncValue<List<Product>>> with $Provider<AsyncValue<List<Product>>> {
  const SearchedProductsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchedProductsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchedProductsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Product>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<List<Product>> create(Ref ref) {
    return searchedProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Product>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Product>>>(value),
    );
  }
}

String _$searchedProductsHash() => r'9698244ef1de53e80f76bea9b4da6829a8c3fbc6';
