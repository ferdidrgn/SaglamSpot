import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saglamspot/core/common/base_notifier.dart';
import '../../../products/presentation/providers/product_provider.dart';
import 'search_state.dart';

part 'search_notifier.g.dart';

@riverpod
class SearchNotifier extends _$SearchNotifier with BaseResultHandler {
  Timer? _debounce;

  @override
  SearchState build() {
    // Industrial: Build döngüsünü bozmadan ilk yüklemeyi başlat
    Future.microtask(() => loadProducts());
    return const SearchState();
  }

  /// İlk ürün yükleme - filtresiz
  Future<void> loadProducts() async {
    // execute metodu artık doğrudan veriyi döndürür
    final products = await handleResult(
      () => ref.read(getProductsUseCaseProvider).call(),
      operationTag: 'LoadSearchProducts',
    );

    if (products != null)
      state = state.copyWith(
        products: products,
        filteredProducts: products,
        isLoading: false,
        errorMessage: null,
      );
  }

  /// Search query değiştiğinde - debounced
  void onQueryChanged(final String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(query: query);
      _applyFilters();
    });
  }

  /// Kategori filtreleme
  void filterByCategory(final String category) {
    state =
        state.copyWith(selectedCategory: category == 'Tümü' ? null : category);
    _applyFilters();
  }

  /// Durum filtreleme (Sıfır/İkinci El)
  void setCondition(final String? condition) {
    state = state.copyWith(condition: condition == 'Hepsi' ? null : condition);
    _applyFilters();
  }

  /// Fiyat aralığı filtreleme
  void setPriceRange(final double min, final double max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
    _applyFilters();
  }

  /// Tüm filtreleri temizle
  Future<void> resetFilters() async {
    _debounce?.cancel();
    state = const SearchState();
    await loadProducts();
  }

  /// CORE FILTER LOGIC
  void _applyFilters() {
    if (state.products.isEmpty) {
      state = state.copyWith(filteredProducts: []);
      return;
    }

    final filtered = state.products.where((final product) {
      final matchesQuery = _matchesQuery(product);
      final matchesCategory = _matchesCategory(product);
      final matchesCondition = _matchesCondition(product);
      final matchesPrice = _matchesPrice(product);

      return matchesQuery &&
          matchesCategory &&
          matchesCondition &&
          matchesPrice;
    }).toList();

    // Endüstriyel Sıralama: Önce Stok, Sonra Fiyat
    filtered.sort((final a, final b) {
      if (a.isSold != b.isSold) return a.isSold ? 1 : -1;
      return a.price.compareTo(b.price);
    });

    state = state.copyWith(filteredProducts: filtered);
  }

  bool _matchesQuery(final dynamic product) {
    if (state.query.isEmpty) return true;
    final q = state.query.toLowerCase().trim();
    return product.name.toLowerCase().contains(q) ||
        product.desc.toLowerCase().contains(q);
  }

  bool _matchesCategory(final dynamic product) {
    if (state.selectedCategory == null) return true;
    return product.category == state.selectedCategory;
  }

  bool _matchesCondition(final dynamic product) {
    if (state.condition == null) return true;
    return state.condition == 'Sıfır'
        ? !product.isSpotProduct
        : product.isSpotProduct;
  }

  bool _matchesPrice(final dynamic product) =>
      product.price >= state.minPrice && product.price <= state.maxPrice;
}
