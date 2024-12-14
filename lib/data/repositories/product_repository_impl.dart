import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    return await _getProducts(() => remoteDataSource.getProducts());
  }

  @override
  Future<Either<Failure, List<Product>>> getFilteredProducts({
    String? condition,
    double? minPrice,
    double? maxPrice,
  }) async {
    return await _getProducts(() => remoteDataSource.getFilteredProducts(
      condition: condition,
      minPrice: minPrice,
      maxPrice: maxPrice,
    ));
  }

  Future<Either<Failure, List<Product>>> _getProducts(
    Future<List<ProductModel>> Function() getProductsFromSource,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await getProductsFromSource();
        return Right(products.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(Product product, List<String> images) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel.fromEntity(product);
        await remoteDataSource.addProduct(productModel, images);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }
  }
}