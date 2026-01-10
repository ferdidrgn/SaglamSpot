// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchNotifier)
const searchProvider = SearchNotifierProvider._();

final class SearchNotifierProvider
    extends $NotifierProvider<SearchNotifier, SearchState> {
  const SearchNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchNotifierHash();

  @$internal
  @override
  SearchNotifier create() => SearchNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchState>(value),
    );
  }
}

String _$searchNotifierHash() => r'b70f65b413699d150f463efadebcdfc4f2e66070';

abstract class _$SearchNotifier extends $Notifier<SearchState> {
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
