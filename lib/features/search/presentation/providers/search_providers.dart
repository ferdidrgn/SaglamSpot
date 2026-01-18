import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/enum/enums.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_provider.dart';

part 'search_providers.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(final String query) => state = query;
}

@riverpod
class SearchFilters extends _$SearchFilters {
  @override
  ({
  ProductCategory? category,
  ProductCondition? condition,
  double minPrice,
  double maxPrice
  }) build() {
    return (
    category: null,
    condition: ProductCondition.all,
    minPrice: 0,
    maxPrice: 100000
    );
  }

  void setCategory(final ProductCategory? cat) {
    state = (
    category: cat,
    condition: state.condition,
    minPrice: state.minPrice,
    maxPrice: state.maxPrice,
    );
  }

  void setCondition(final ProductCondition? cond) {
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

@riverpod
AsyncValue<List<Product>> searchedProducts(final Ref ref) {
  final productsAsync = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final filters = ref.watch(searchFiltersProvider);

  return productsAsync.whenData((final allProducts) {
    final filtered = allProducts.where((final product) {
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.desc.toLowerCase().contains(query);

      final matchesCategory =
          filters.category == null || product.category == filters.category;

      final bool matchesCondition;
      switch (filters.condition) {
        case ProductCondition.newProduct:
          matchesCondition = !product.isSpotProduct;
          break;
        case ProductCondition.used:
          matchesCondition = product.isSpotProduct;
          break;
        default:
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
