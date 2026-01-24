import 'package:dartz/dartz.dart';
import '../../../../core/base/base_repo.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entites/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../mappers/product_mapper.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl extends BaseRepository
    implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() =>
      _executeProductList(remoteDataSource.getProducts);

  @override
  Future<Either<Failure, Product>> getProductById(final String id) =>
      execute(() async {
        final model = await remoteDataSource.getProductById(id);
        return model.toEntity();
      });

  @override
  Future<Either<Failure, List<Product>>> filterProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  }) =>
      _executeProductList(() => remoteDataSource.filterProducts(
          condition: condition, minPrice: minPrice, maxPrice: maxPrice));

  @override
  Future<Either<Failure, List<Product>>> searchProducts(
          {final String? searchQueryText}) =>
      _executeProductList(
          () => remoteDataSource.searchProducts(searchQueryText ?? ''));

  @override
  Future<Either<Failure, void>> addProduct(
          final Product product, final List<dynamic> images) =>
      execute(() => remoteDataSource.addProduct(product.toModel(), images));

  @override
  Future<Either<Failure, void>> updateProduct(
          final Product product, final List<dynamic>? newImages) =>
      execute(
          () => remoteDataSource.updateProduct(product.toModel(), newImages));

  @override
  Future<Either<Failure, void>> deleteProduct(final String productId) =>
      execute(() => remoteDataSource.deleteProduct(productId));

  // --- Merkezi Liste Dönüştürücü ---
  Future<Either<Failure, List<Product>>> _executeProductList(
          final Future<List<ProductModel>> Function() source) =>
      execute(() async {
        final models = await source();
        return models.map((final m) => m.toEntity()).toList();
      });
}
