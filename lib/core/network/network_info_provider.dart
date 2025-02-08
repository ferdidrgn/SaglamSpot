import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info.dart';
import 'network_info_impl.dart';

// Provider for InternetConnectionChecker
final internetConnectionCheckerProvider =
    Provider<InternetConnectionChecker>((final ref) {
  return InternetConnectionChecker();
});

// Provider for NetworkInfo
final networkInfoProvider = Provider<NetworkInfo>((final ref) {
  final connectionChecker = ref.watch(internetConnectionCheckerProvider);
  return NetworkInfoImpl(connectionChecker);
});
