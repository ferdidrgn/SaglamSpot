// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filters_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchFiltersNotifier)
const searchFiltersProvider = SearchFiltersNotifierProvider._();

final class SearchFiltersNotifierProvider
    extends $NotifierProvider<SearchFiltersNotifier, SearchState> {
  const SearchFiltersNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$searchFiltersNotifierHash();

  @$internal
  @override
  SearchFiltersNotifier create() => SearchFiltersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchState>(value),
    );
  }
}

String _$searchFiltersNotifierHash() =>
    r'dff2d3e596b9dcf3e1b0bbd31998365165c34d82';

abstract class _$SearchFiltersNotifier extends $Notifier<SearchState> {
  SearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchState, SearchState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SearchState, SearchState>, SearchState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
