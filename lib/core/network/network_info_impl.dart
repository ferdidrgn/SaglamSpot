import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker? connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      // Web platformunda her zaman bağlı kabul et
      return true;
    }
    return await connectionChecker?.hasConnection ?? true;
  }
}
