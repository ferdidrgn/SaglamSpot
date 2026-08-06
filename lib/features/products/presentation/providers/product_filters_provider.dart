import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entites/product.dart';
import 'product_provider.dart';

part 'product_filters_provider.g.dart';

@riverpod
List<Product> similarProducts(final Ref ref,
    {required final String category, required final String currentProductId}) {
  final allProducts = ref.watch(productsProvider).value ?? [];
  final products = ref.watch(newDealsProductsProvider);

  return products
      .where((final p) => p.category.name == category && p.id != currentProductId)
      .toList();
}

// ═══════════════════════════════════════════════════════════
// 1. TEMEL GRUPLAR (Satılmış & Stokta Olanlar)
// ═══════════════════════════════════════════════════════════

@riverpod
List<Product> availableProducts(final Ref ref) {
  final asyncProducts = ref.watch(productsProvider);
  return asyncProducts.value?.where((final e) => !e.isSold).toList() ?? [];
}

@riverpod
List<Product> soldProducts(final Ref ref) {
  final asyncProducts = ref.watch(productsProvider);
  return asyncProducts.value?.where((final e) => e.isSold).toList() ?? [];
}

// ═══════════════════════════════════════════════════════════
// 2. STOKTA OLANLAR (Satılmamış Ürün Detayları)
// ═══════════════════════════════════════════════════════════

/// Stoktaki İKİNCİ EL (Spot) ürünler
@riverpod
List<Product> spotDealsProducts(final Ref ref) => ref
    .watch(availableProductsProvider)
    .where((final e) => e.isSpotProduct)
    .toList();

/// Stoktaki SIFIR ürünler
@riverpod
List<Product> newDealsProducts(final Ref ref) => ref
    .watch(availableProductsProvider)
    .where((final e) => !e.isSpotProduct)
    .toList();

/// Stoktaki YENİ GELENLER (Son 10 gün)
@riverpod
List<Product> newArrivalsProducts(final Ref ref) {
  final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
  return ref.watch(availableProductsProvider).where((final e) {
    final date = DateTime.tryParse(e.createdAt) ?? DateTime(2000);
    return date.isAfter(tenDaysAgo);
  }).toList();
}

// ═══════════════════════════════════════════════════════════
// 3. SATILMIŞ OLANLAR (Showroom / Arşiv)
// ═══════════════════════════════════════════════════════════

/// Satılmış İKİNCİ EL ürünler
@riverpod
List<Product> spotSoldProducts(final Ref ref) => ref
    .watch(soldProductsProvider)
    .where((final e) => e.isSpotProduct)
    .toList();

/// Satılmış SIFIR ürünler
@riverpod
List<Product> newSoldProducts(final Ref ref) => ref
    .watch(soldProductsProvider)
    .where((final e) => !e.isSpotProduct)
    .toList();
