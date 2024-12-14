import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker? connectionChecker;

  NetworkInfoImpl(this.connectionChecker); // Burada nullable

  @override
  Future<bool> get isConnected async {
    if (connectionChecker == null) {
      return false; // veya uygun bir varsayılan değer
    }
    return await connectionChecker!.hasConnection; // Null kontrolü
  }
}