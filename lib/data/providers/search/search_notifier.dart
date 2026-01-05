import 'dart:async';
import 'package:saglamspot/core/common/base_notifier.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/repositories/product_repository_provider.dart';
import '../product/product_provider.dart';
import 'search_state.dart';

/// Search ve filter işlemlerini yöneten notifier
/// Clean Architecture ve SOLID prensipleriyle tasarlanmış
/// Performance optimized with debouncing
class SearchNotifier extends BaseNotifier<SearchState> {
  Timer? _debounce;
  late final ProductRepository _repository;

  @override
  SearchState initialState() => const SearchState();

  @override
  void reloadData() => loadProducts();

  @override
  SearchState build() {
    _repository = ref.read(productRepositoryProvider);
    loadProducts(); // Initial load
    return const SearchState();
  }

  /// İlk ürün yükleme - filtresiz
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);

    await execute(
      () => ref.read(getProductsUseCaseProvider).call(),
      onSuccess: (final products) {
        state = state.copyWith(
          products: products,
          filteredProducts: products,
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  /// Search query değiştiğinde - debounced
  void onQueryChanged(final String query) {
    // Önceki timer'ı iptal et
    _debounce?.cancel();

    // Yeni timer başlat
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        state = state.copyWith(query: query);
        _applyFilters();
      },
    );
  }

  /// Kategori filtreleme
  void filterByCategory(final String category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  /// Durum filtreleme (Sıfır/İkinci El)
  void setCondition(final String? condition) {
    // "Hepsi" seçilirse null yap
    final normalizedCondition = condition == 'Hepsi' ? null : condition;
    state = state.copyWith(condition: normalizedCondition);
    _applyFilters();
  }

  /// Fiyat aralığı filtreleme
  void setPriceRange(final double min, final double max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
    _applyFilters();
  }

  /// Tüm filtreleri temizle ve initial state'e dön
  Future<void> resetFilters() async {
    // Debounce timer'ı iptal et
    _debounce?.cancel();

    state = const SearchState();
    await loadProducts();
  }

  /// Tüm filtreleri uygula - CORE FILTER LOGIC
  void _applyFilters() {
    // Eğer hiç ürün yoksa filtreleme yapma
    if (state.products.isEmpty) {
      state = state.copyWith(filteredProducts: []);
      return;
    }

    // Filtreleme işlemi
    final filtered = state.products.where((final product) {
      // 1. Query filtreleme (isim, açıklama, kategori)
      final matchesQuery = _matchesQuery(product);

      // 2. Kategori filtreleme
      final matchesCategory = _matchesCategory(product);

      // 3. Durum filtreleme (Sıfır/İkinci El - Spot)
      final matchesCondition = _matchesCondition(product);

      // 4. Fiyat aralığı filtreleme
      final matchesPrice = _matchesPrice(product);

      // Tüm filtreler match etmeli
      return matchesQuery &&
          matchesCategory &&
          matchesCondition &&
          matchesPrice;
    }).toList();

    // Sonuçları sırala (önce stokta olanlar, sonra fiyata göre)
    filtered.sort((final a, final b) {
      // Önce satılmış olanları en sona gönder
      if (a.isSold != b.isSold) {
        return a.isSold ? 1 : -1;
      }
      // Sonra fiyata göre sırala
      return a.price.compareTo(b.price);
    });

    state = state.copyWith(filteredProducts: filtered);
  }

  /// Query match kontrolü
  bool _matchesQuery(final dynamic product) {
    if (state.query.isEmpty) return true;

    final query = state.query.toLowerCase().trim();
    final name = product.name.toLowerCase();
    final desc = product.desc.toLowerCase();
    final category = product.category.toLowerCase();

    return name.contains(query) ||
        desc.contains(query) ||
        category.contains(query);
  }

  /// Kategori match kontrolü
  bool _matchesCategory(final dynamic product) {
    if (state.selectedCategory == null || state.selectedCategory == 'Tümü') {
      return true;
    }
    return product.category == state.selectedCategory;
  }

  /// Durum match kontrolü (Sıfır/İkinci El)
  bool _matchesCondition(final dynamic product) {
    if (state.condition == null) return true;

    // "Sıfır" -> spot olmayan ürünler
    if (state.condition == 'Sıfır') {
      return !product.isSpotProduct;
    }

    // "İkinci El" -> spot ürünler
    if (state.condition == 'İkinci El') {
      return product.isSpotProduct;
    }

    return true;
  }

  /// Fiyat aralığı match kontrolü
  bool _matchesPrice(final dynamic product) {
    return product.price >= state.minPrice && product.price <= state.maxPrice;
  }

  /// Aktif filter sayısını döndür
  int getActiveFilterCount() {
    int count = 0;

    if (state.query.isNotEmpty) count++;
    if (state.selectedCategory != null && state.selectedCategory != 'Tümü')
      count++;
    if (state.condition != null) count++;
    if (state.minPrice > 0 || state.maxPrice < 50000) count++;

    return count;
  }

  /// Sonuç sayısını döndür
  int get resultCount => state.filteredProducts.length;

  /// Filtre aktif mi?
  bool get hasActiveFilters => getActiveFilterCount() > 0;
}
