import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saglamspot/features/products/domain/repositories/product_repository.dart';
import '../../data/datasources/product_remote_data_source_provider.dart';
import '../../data/repositories/product_repository_impl.dart';

part 'product_repository_provider.g.dart';

@riverpod
ProductRepository productRepository(final Ref ref) {
  // RemoteDataSource provider'ını izle
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);

  return ProductRepositoryImpl(remoteDataSource: remoteDataSource);
}
