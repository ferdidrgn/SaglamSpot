import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';
import 'package:saglamspot/presentation/bloc/product_bloc.dart';
import 'core/network/network_info.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // Features - Product
  // Bloc
  sl.registerFactory(
        () => ProductBloc(repository: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(
      firestore: sl(),
      storage: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(
      kIsWeb ? null : InternetConnectionChecker(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Ensure all async initialization is complete
  await sl.allReady();
}