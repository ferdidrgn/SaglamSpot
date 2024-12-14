import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

abstract class GetProductsUseCase {
  Future<Either<Failure, List<Product>>> call();
}

class GetProductsUseCaseImpl implements GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}