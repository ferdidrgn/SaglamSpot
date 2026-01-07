import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failures.dart';
import '../entites/product.dart';
import '../repositories/product_repository.dart';

abstract class FilterProductUseCase {
  Future<Either<Failure, List<Product>>> call(
      {final String? condition,
      final double? minPrice,
      final double? maxPrice});
}

class FilterProductUseCaseImpl implements FilterProductUseCase {
  final ProductRepository repository;

  FilterProductUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
      {final String? condition,
      final double? minPrice,
      final double? maxPrice}) async {
    return repository.filterProducts(
        condition: condition, minPrice: minPrice, maxPrice: maxPrice);
  }
}
