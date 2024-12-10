import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // Features - Product
  // Bloc

  // Use Cases

  // Repository

  // Data Sources

  // Core

  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => SharedPreferences.getInstance());
}