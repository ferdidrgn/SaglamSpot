import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entites/product.dart';
import '../repositories/product_repository.dart';

abstract class GetProductByIdUseCase {
  Future<Either<Failure, Product>> call(final String id);
}

class GetProductByIdUseCaseImpl implements GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, Product>> call(final String id) =>
      repository.getProductById(id);
}
