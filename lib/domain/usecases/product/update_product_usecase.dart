import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

abstract class UpdateProductUseCase {
  Future<Either<Failure, void>> call(Product product);
}

class UpdateProductUseCaseImpl implements UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(Product product) async {
    return await repository.updateProduct(product);
  }
} 