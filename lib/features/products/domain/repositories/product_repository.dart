import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failures.dart';
import '../entites/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();

  Future<Either<Failure, List<Product>>> searchProducts(
      {final String? searchQueryText});

  Future<Either<Failure, void>> addProduct(
      final Product product, final List<dynamic> images);

  Future<Either<Failure, void>> updateProduct(final Product product);

  Future<Either<Failure, void>> deleteProduct(final String productId);

  Future<Either<Failure, List<Product>>> filterProducts(
      {final String? condition,
      final double? minPrice,
      final double? maxPrice});
}
