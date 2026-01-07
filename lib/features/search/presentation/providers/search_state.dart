import 'package:equatable/equatable.dart';
import '../../../../core/common/base_state.dart';
import '../../../products/domain/entites/product.dart';

/// Search state - Immutable ve type-safe
/// Equatable ile performance optimization
class SearchState extends BaseState with EquatableMixin {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String query;
  final String? selectedCategory;
  final String? condition;
  final double minPrice;
  final double maxPrice;

  const SearchState({
    this.products = const [],
    this.filteredProducts = const [],
    this.query = '',
    this.selectedCategory,
    this.condition,
    this.minPrice = 0,
    this.maxPrice = 50000,
    super.isLoading = false,
    super.errorMessage,
  });

  @override
  SearchState copyWith({
    final List<Product>? products,
    final List<Product>? filteredProducts,
    final String? query,
    final String? selectedCategory,
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
    final bool? isLoading,
    final String? errorMessage,
  }) {
    return SearchState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      condition: condition ?? this.condition,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Equatable props for performance
  @override
  List<Object?> get props => [
        products,
        filteredProducts,
        query,
        selectedCategory,
        condition,
        minPrice,
        maxPrice,
        isLoading,
        errorMessage,
      ];

  /// Computed properties
  bool get hasResults => filteredProducts.isNotEmpty;

  bool get isEmpty => filteredProducts.isEmpty && !isLoading;

  bool get hasQuery => query.isNotEmpty;

  bool get hasFilters =>
      selectedCategory != null ||
      condition != null ||
      minPrice > 0 ||
      maxPrice < 50000;

  int get resultCount => filteredProducts.length;

  int get totalCount => products.length;

  /// Helper methods
  bool get isFiltered => hasQuery || hasFilters;

  String get statusMessage {
    if (isLoading) return 'Yükleniyor...';
    if (isEmpty && isFiltered) return 'Sonuç bulunamadı';
    if (isEmpty) return 'Henüz ürün yok';
    return '$resultCount ürün bulundu';
  }
}
