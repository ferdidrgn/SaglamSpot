import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/features/products/domain/repositories/product_repository.dart';
import '../../data/datasources/product_remote_data_source_provider.dart';
import '../../data/repositories/product_repository_impl.dart';

final productRepositoryProvider = Provider<ProductRepository>((final ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  //final internetService = ref.watch(internetServiceProvider);

  return ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
   // internetService: internetService,
  );
});
