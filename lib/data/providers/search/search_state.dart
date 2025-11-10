import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

class SearchState extends Equatable {
  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;
  final String query;
  final String? condition;
  final double minPrice;
  final double maxPrice;

  const SearchState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
    this.query = '',
    this.condition,
    this.minPrice = 0,
    this.maxPrice = 50000,
  });

  SearchState copyWith({
    final List<Product>? products,
    final bool? isLoading,
    final String? errorMessage,
    final String? query,
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  }) {
    return SearchState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      query: query ?? this.query,
      condition: condition ?? this.condition,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

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
