import '../../../core/common/base_state.dart';
import '../../../domain/entities/product.dart';

class SearchState extends BaseState {
  final List<Product> products;
  final String query;
  final String? condition;
  final double minPrice;
  final double maxPrice;

  const SearchState({
    this.products = const [],
    this.query = '',
    this.condition,
    this.minPrice = 0,
    this.maxPrice = 50000,
    super.isLoading,
    super.errorMessage,
  });

  @override
  SearchState copyWith({
    final List<Product>? products,
    final String? query,
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
    final bool? isLoading,
    final String? errorMessage,
  }) =>
      SearchState(
        products: products ?? this.products,
        query: query ?? this.query,
        condition: condition ?? this.condition,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        products,
        isLoading,
        errorMessage,
        query,
        condition,
        minPrice,
        maxPrice,
      ];
}
