import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  ({String? category, String? condition, double minPrice, double maxPrice})
      build() {
    return (category: null, condition: null, minPrice: 0, maxPrice: 100000);
  }

  void setCategory(final String? cat) {
    state = (
      category: cat == 'Tümü' ? null : cat,
      condition: state.condition,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice
    );
  }

  void setCondition(final String? cond) {
    state = (
      category: state.category,
      condition: cond == 'Tümü' || cond == 'Hepsi' ? null : cond,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice
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
  // Bağımlılıkları izle (Herhangi biri değişirse burası otomatik tekrar çalışır)
  final productsAsync = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final filters = ref.watch(searchFiltersProvider);

  // Veri gelene kadar loading/error durumunu koru
  return productsAsync.whenData((final allProducts) {
    // 1. Filtreleme İşlemi
    final filtered = allProducts.where((final product) {
      // Arama query'si kontrolü
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.desc.toLowerCase().contains(query) ||
          (product.category?.toLowerCase().contains(query) ?? false);

      // Kategori filtresi - null ise tüm kategoriler dahil
      final matchesCategory =
          filters.category == null || product.category == filters.category;

      // Durum filtresi - DÜZELTİLDİ
      // condition null ise -> tüm durumlar (sıfır + ikinci el)
      // condition "Sıfır" ise -> sadece isSpotProduct == false olanlar
      // condition "İkinci El" ise -> sadece isSpotProduct == true olanlar
      final bool matchesCondition;
      if (filters.condition == null) {
        // Tümü seçili - hem sıfır hem ikinci el göster
        matchesCondition = true;
      } else if (filters.condition == 'Sıfır') {
        // Sadece sıfır ürünler (isSpotProduct == false olan ürünler)
        matchesCondition = !product.isSpotProduct;
      } else if (filters.condition == 'İkinci El') {
        // Sadece ikinci el ürünler (isSpotProduct == true olan ürünler)
        matchesCondition = product.isSpotProduct;
      } else {
        matchesCondition = true;
      }

      // Fiyat aralığı filtresi
      final matchesPrice = product.price >= filters.minPrice &&
          product.price <= filters.maxPrice;

      return matchesQuery &&
          matchesCategory &&
          matchesCondition &&
          matchesPrice;
    }).toList();

    // 2. Endüstriyel Sıralama (Önce Stoktakiler, Sonra Fiyat)
    return filtered
      ..sort((final a, final b) {
        // İlk önce satılan/satılmayan ayrımı
        if (a.isSold != b.isSold) return a.isSold ? 1 : -1;
        // Aynı durumdaysa fiyata göre sırala
        return a.price.compareTo(b.price);
      });
  });
}
