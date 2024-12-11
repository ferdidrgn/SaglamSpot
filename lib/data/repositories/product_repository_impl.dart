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
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts();
        return Right(products.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getFilteredProducts({
    String? condition,
    double? minPrice,
    double? maxPrice,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getFilteredProducts(
          condition: condition,
          minPrice: minPrice,
          maxPrice: maxPrice,
        );
        return Right(products.map((model) => model.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('İnternet bağlantısı yok'));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(Product product, List<dynamic> images) async {
    if (await networkInfo.isConnected) {
      try {
        final productModel = ProductModel(
          id: product.id,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          soldAt: '',
          name: product.name,
          desc: product.desc,
          category: '',
          price: product.price,
          imageUrl: product.imageUrl,
          isSold: product.isSold,
          isSpotProduct: false,
        );
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