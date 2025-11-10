import 'dart:async';
import 'package:saglamspot/core/common/base_notifier_with_network_checker.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/repositories/product_repository_provider.dart';
import '../product/product_provider.dart';
import 'search_state.dart';

class SearchNotifier extends BaseNotifierWithNetworkChecker<SearchState> {
  Timer? _debounce;
  late final ProductRepository _repository;

  @override
  SearchState initialState() => const SearchState();

  @override
  void reloadData() {
    // TODO: implement reloadData
  }

  @override
  SearchState build() {
    _repository = ref.read(productRepositoryProvider);
    _loadInitialProducts();
    return const SearchState(isLoading: true);
  }

  Future<void> _loadInitialProducts() =>
      executeWithInternetCheck(() => _repository.getProducts(),
          onSuccess: (final products) =>
              state = state.copyWith(products: products, isLoading: false));

  Future<void> loadProducts() => executeWithInternetCheck(
      () => ref.read(getProductsUseCaseProvider).call(),
      onSuccess: (final products) =>
          state = state.copyWith(products: products, isLoading: false));

  void onQueryChanged(final String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      state = state.copyWith(query: query, isLoading: true);
      await _filterAndSearch();
    });
  }

  Future<void> _filterAndSearch() async {
    await executeWithInternetCheck(
      () => _repository.getProducts(),
      onSuccess: (final products) {
        final filtered = products.where((final p) {
          final matchesQuery = state.query.isEmpty ||
              p.name.toLowerCase().contains(state.query.toLowerCase());

          final matchesCondition = state.condition == null ||
              (state.condition == 'Sıfır' && !p.isSpotProduct) ||
              (state.condition == 'İkinci El' && p.isSpotProduct);

          final matchesPrice =
              p.price >= state.minPrice && p.price <= state.maxPrice;

          return matchesQuery && matchesCondition && matchesPrice;
        }).toList();

        state = state.copyWith(products: filtered, isLoading: false);
      },
    );
  }

  void setCondition(final String? condition) {
    state = state.copyWith(
        condition: condition == 'Hepsi' ? null : condition, isLoading: true);
    _filterAndSearch();
  }

  void setPriceRange(final double min, final double max) {
    state = state.copyWith(minPrice: min, maxPrice: max, isLoading: true);
    _filterAndSearch();
  }

  Future<void> resetFilters() async {
    state = state.copyWith(
      query: '',
      condition: null,
      minPrice: 0,
      maxPrice: 50000,
      isLoading: true,
    );
    await _loadInitialProducts();
  }
}
