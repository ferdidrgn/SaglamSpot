import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/domain/repositories/product_repository.dart';
import '../../core/network/network_info_provider.dart';
import '../../data/datasources/product_remote_data_source_provider.dart';
import '../../data/repositories/product_repository_impl.dart';

final productRepositoryProvider = Provider<ProductRepository>((final ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});
