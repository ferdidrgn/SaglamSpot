import '../../../domain/entities/product.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;

  ProductState({
    this.isLoading = false,
    this.errorMessage,
    final List<Product>? products,
  }) : products = products ?? [];

  ProductState copyWith({
    final List<Product>? products,
    final bool? isLoading,
    final String? errorMessage,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}