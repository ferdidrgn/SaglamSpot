import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, List<Product>>> getFilteredProducts({
    String? condition,
    double? minPrice,
    double? maxPrice,
  });
  Future<Either<Failure, void>> addProduct(Product product, List<dynamic> images);
} 