import '../../../domain/entities/product.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;

  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
  });
}
