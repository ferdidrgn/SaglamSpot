import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

abstract class AddProductUseCase {
  Future<Either<Failure, void>> call(final Product product, final List<dynamic> images);
}

class AddProductUseCaseImpl implements AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, void>> call(final Product product, final List<dynamic> images) async {
    return repository.addProduct(product, images);
  }
}
