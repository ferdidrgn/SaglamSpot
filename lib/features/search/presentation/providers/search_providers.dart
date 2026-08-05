import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/util/date_formatter.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_provider.dart';

part 'search_providers.g.dart';

enum SortOption { featured, priceAsc, priceDesc, newest }

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.featured:
        return 'Öne Çıkanlar';
      case SortOption.priceAsc:
        return 'Fiyat: Artan';
      case SortOption.priceDesc:
        return 'Fiyat: Azalan';
      case SortOption.newest:
        return 'En Yeni';
    }
  }
}

/// Kullanıcının arama sonuçları için seçtiği sıralama tercihi.
/// (Riverpod 3'te StateProvider kaldırıldığı için Notifier deseni kullanıyoruz.)
class SortOptionNotifier extends Notifier<SortOption> {
  @override
  SortOption build() => SortOption.featured;

  void set(final SortOption option) => state = option;
}

final sortOptionProvider =
    NotifierProvider<SortOptionNotifier, SortOption>(SortOptionNotifier.new);

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(final String query) => state = query;
}

typedef SearchFiltersState = ({
  ProductCategory? category,
  ProductCondition? condition,
  double minPrice,
  double maxPrice
});

@riverpod
class SearchFilters extends _$SearchFilters {
  @override
  SearchFiltersState build() {
    return (
      category: null, // null = Tümü
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
  final sortOption = ref.watch(sortOptionProvider);

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

    switch (sortOption) {
      case SortOption.priceAsc:
        filtered.sort((final a, final b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        filtered.sort((final a, final b) => b.price.compareTo(a.price));
        break;
      case SortOption.newest:
        filtered.sort((final a, final b) {
          final da = DateFormatter.parseDateString(a.createdAt);
          final db = DateFormatter.parseDateString(b.createdAt);
          if (da == null || db == null) return 0;
          return db.compareTo(da); // en yeni önce
        });
        break;
      case SortOption.featured:
        filtered.sort((final a, final b) {
          if (a.isSold != b.isSold) return a.isSold ? 1 : -1;
          return a.price.compareTo(b.price);
        });
        break;
    }

    return filtered;
  });
}
