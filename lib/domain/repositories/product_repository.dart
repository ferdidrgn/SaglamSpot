import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  /// Get a list of products.
  Future<Either<Failure, List<Product>>> getProducts();

  /// Get a list of products filtered by optional parameters.
  Future<Either<Failure, List<Product>>> getFilteredProducts({
    String? condition,
    double? minPrice,
    double? maxPrice,
  });

  /// Add a new product with associated images.
  Future<Either<Failure, void>> addProduct(Product product, List<String> images);
}