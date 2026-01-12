import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<void> addProduct(final ProductModel product, final List<dynamic> images);

  Future<List<ProductModel>> getProducts();

  Future<List<ProductModel>> filterProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  });

  Future<List<ProductModel>> searchProducts(final String productId);

  Future<void> updateProduct(final ProductModel product, final List<dynamic>? newImages);

  Future<void> deleteProduct(final String productId);
}
