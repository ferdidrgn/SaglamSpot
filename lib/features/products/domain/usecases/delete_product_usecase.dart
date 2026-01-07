import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failures.dart';
import '../repositories/product_repository.dart';

abstract class DeleteProductUseCase {
  Future<Either<Failure, void>> call(final String productId);
}

class DeleteProductUseCaseImpl implements DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(final String productId) async {
    return repository.deleteProduct(productId);
  }
}
