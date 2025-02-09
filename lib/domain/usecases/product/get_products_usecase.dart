import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

abstract class GetProductsUseCase {
  Future<Either<Failure, List<Product>>> call();
}

class GetProductsUseCaseImpl implements GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCaseImpl(this.repository);  // Yapıcı

  @override
  Future<Either<Failure, List<Product>>> call() async {
    return repository.getProducts(); // Repository'den ürünleri al
  }
}
