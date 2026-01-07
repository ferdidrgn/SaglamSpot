import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failures.dart';
import '../entites/product.dart';
import '../repositories/product_repository.dart';

abstract class UpdateProductUseCase {
  Future<Either<Failure, void>> call(final Product product);
}

class UpdateProductUseCaseImpl implements UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(final Product product) async {
    return repository.updateProduct(product);
  }
}
