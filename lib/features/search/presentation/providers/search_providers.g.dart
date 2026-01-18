// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchQuery)
const searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
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

@ProviderFor(SearchFilters)
const searchFiltersProvider = SearchFiltersProvider._();

final class SearchFiltersProvider
    extends $NotifierProvider<SearchFilters, SearchFiltersState> {
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
  Override overrideWithValue(SearchFiltersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFiltersState>(value),
    );
  }
}

String _$searchFiltersHash() => r'94af276f221fe4eb3a3fc7bf5f39c219d4a0fab3';

abstract class _$SearchFilters extends $Notifier<SearchFiltersState> {
  SearchFiltersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchFiltersState, SearchFiltersState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SearchFiltersState, SearchFiltersState>,
        SearchFiltersState,
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

String _$searchedProductsHash() => r'b3835f875678e957fba35b1a950adfdc3d716708';
