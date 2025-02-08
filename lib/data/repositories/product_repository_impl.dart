import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
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
    return _getProducts(() => remoteDataSource.getProducts());
  }

  @override
  Future<Either<Failure, List<Product>>> getFilteredProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  }) async {
    return _getProducts(() => remoteDataSource.getFilteredProducts(
          condition: condition,
          minPrice: minPrice,
          maxPrice: maxPrice,
        ));
  }

  Future<Either<Failure, List<Product>>> _getProducts(
    final Future<List<ProductModel>> Function() getProductsFromSource,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await getProductsFromSource();
        return Right(products.map((final model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(
      final Product product, final List<dynamic> images) async {
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

  @override
  Future<Either<Failure, void>> updateProduct(final Product product) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel.fromEntity(product);
        await remoteDataSource.updateProduct(productModel);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(final String productId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteProduct(productId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }
  }
}
