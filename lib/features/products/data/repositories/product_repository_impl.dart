import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../core/common/base_repo.dart';
import '../../domain/entites/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl extends BaseRepository
    implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    //required this.internetService,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() =>
      _getProducts(() => remoteDataSource.getProducts());

  @override
  Future<Either<Failure, List<Product>>> filterProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  }) =>
      _getProducts(() => remoteDataSource.filterProducts(
            condition: condition,
            minPrice: minPrice,
            maxPrice: maxPrice,
          ));

  Future<Either<Failure, List<Product>>> _getProducts(
          final Future<List<ProductModel>> Function() getProductsFromSource) =>
      execute(() async {
        final models = await getProductsFromSource();
        return models.map((e) => e.toEntity()).toList();
      });

  @override
  Future<Either<Failure, List<Product>>> searchProducts(
          {final String? searchQueryText}) =>
      _getProducts(
          () => remoteDataSource.searchProducts(searchQueryText ?? ''));

  @override
  Future<Either<Failure, void>> addProduct(
          final Product product, final List<dynamic> images) =>
      execute(() => remoteDataSource.addProduct(
          ProductModel.fromEntity(product), images));

  @override
  Future<Either<Failure, void>> updateProduct(final Product product) => execute(
      () => remoteDataSource.updateProduct(ProductModel.fromEntity(product)));

  @override
  Future<Either<Failure, void>> deleteProduct(final String productId) =>
      execute(() => remoteDataSource.deleteProduct(productId));
}
