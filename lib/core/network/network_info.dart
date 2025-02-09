import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Provider for InternetConnectionChecker
final internetConnectionCheckerProvider =
    Provider<InternetConnectionChecker>((ref) {
  return InternetConnectionChecker.instance; // Named constructor kullanıldı
});

// Provider for NetworkInfo
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectionChecker = ref.watch(internetConnectionCheckerProvider);
  return NetworkInfoImpl(connectionChecker);
});

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      // Web platformunda bağlantıyı kontrol et
      final bool isConnected = await InternetConnectionChecker.instance.hasConnection;
      if (isConnected) {
        print('Device is connected to the internet');
      } else {
        print('Device is not connected to the internet');
      }
      return isConnected; // Bağlantı durumunu döndür
    }

    try {
      return await connectionChecker.hasConnection;
    } catch (e) {
      // Hata durumunda false döndürüyoruz
      debugPrint('Error checking internet connection: $e');
      return false;
    }
  }
}

abstract class NetworkInfo {
  Future<bool> get isConnected;
}
