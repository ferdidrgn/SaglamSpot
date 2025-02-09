import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'presentation/bloc/product_bloc.dart';
import 'core/network/network_info.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/add_product_usecase.dart';
import 'domain/usecases/update_product_usecase.dart';
import 'domain/usecases/delete_product_usecase.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // Registering dependencies
  _registerBlocs();
  _registerRepositories();
  _registerDataSources();
  _registerCore();
  _registerExternal();
  
  // Ensure all async initialization is complete
  await sl.allReady();
}

void _registerBlocs() {
  sl.registerFactory(() => ProductBloc(repository: sl()));
}

void _registerRepositories() {
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
}

void _registerDataSources() {
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      firestore: sl(),
      storage: sl(),
    ),
  );
}

void _registerCore() {
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(kIsWeb ? null : InternetConnectionChecker()),
  );
}

void _registerExternal() {
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  
  // Use Cases
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCaseImpl(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<AddProductUseCase>(
    () => AddProductUseCaseImpl(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCaseImpl(sl<ProductRepository>()),
  );

  sl.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCaseImpl(sl<ProductRepository>()),
  );
}