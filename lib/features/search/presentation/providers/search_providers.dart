import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/enum/enums.dart';
import '../../../../core/extentions/product_category_ex.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_provider.dart';

part 'search_providers.g.dart';

// ═══════════════════════════════════════════════════════════
// 1. UI INPUT PROVIDERS (Basit Girdiler)
// ═══════════════════════════════════════════════════════════

/// Sadece arama metnini tutar
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(final String query) => state = query;
}

/// Sadece aktif filtreleri tutar (Record kullanarak state sınıfı yazmaktan kurtulduk)
@riverpod
class SearchFilters extends _$SearchFilters {
  @override
  ({
    ProductCategory? category,
    String? condition,
    double minPrice,
    double maxPrice
  }) build() {
    return (category: null, condition: null, minPrice: 0, maxPrice: 100000);
  }

  void setCategory(final ProductCategory? cat) {
    state = (
      category: cat,
      condition: state.condition,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
    );
  }

  void setCondition(final String? cond) {
    state = (
      category: state.category,
      condition: cond,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
    );
  }

  void setPriceRange(final double min, final double max) {
    state = (
      category: state.category,
      condition: state.condition,
      minPrice: min,
      maxPrice: max
    );
  }

  void reset() => ref.invalidateSelf();
}

// ═══════════════════════════════════════════════════════════
// 2. SEARCH LOGIC PROVIDER (Reactive Pipeline)
// ═══════════════════════════════════════════════════════════

@riverpod
AsyncValue<List<Product>> searchedProducts(final Ref ref) {
  final productsAsync = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final filters = ref.watch(searchFiltersProvider);

  return productsAsync.whenData((final allProducts) {
    final filtered = allProducts.where((final product) {
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.desc.toLowerCase().contains(query) ||
          product.category.searchKeywords.any((final k) => k.contains(query));

      final matchesCategory =
          filters.category == null || product.category == filters.category;

      final bool matchesCondition;
      if (filters.condition == null) {
        matchesCondition = true;
      } else if (filters.condition == 'Sıfır') {
        matchesCondition = !product.isSpotProduct;
      } else if (filters.condition == 'İkinci El') {
        matchesCondition = product.isSpotProduct;
      } else {
        matchesCondition = true;
      }

      final matchesPrice = product.price >= filters.minPrice &&
          product.price <= filters.maxPrice;

      return matchesQuery &&
          matchesCategory &&
          matchesCondition &&
          matchesPrice;
    }).toList();

    return filtered
      ..sort((final a, final b) {
        if (a.isSold != b.isSold) return a.isSold ? 1 : -1;
        return a.price.compareTo(b.price);
      });
  });
}
