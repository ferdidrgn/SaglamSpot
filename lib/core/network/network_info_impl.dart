import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      // Assume always connected on web platforms
      return true;
    }

    try {
      final hasConnection = await connectionChecker.hasConnection;
      return hasConnection; // Return the connection status
    } catch (error) {
      debugPrint('Error checking internet connection: $error');
      return false; // Consider not connected on error
    }
  }

  // Stream to listen for connectivity changes
  Stream<bool> get onConnectionChange {
    return connectionChecker.onStatusChange.map((status) {
      return status == InternetConnectionStatus.connected;
    });
  }
}
