import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/data/datasources/product_remote_data_source.dart';
import 'package:saglamspot/data/datasources/product_remote_data_source_impl.dart';
import '../../core/services/firestore_provider.dart';
import '../../core/services/storage_provider.dart';

final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((final ref) {
  final firestore = ref.watch(firestoreProvider); // Firestore sağlayıcınız
  final storage = ref.watch(storageProvider); // Firebase Storage sağlayıcınız

  return ProductRemoteDataSourceImpl(
    firestore: firestore,
    storage: storage,
  );
});
