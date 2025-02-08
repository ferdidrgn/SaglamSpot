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
}
