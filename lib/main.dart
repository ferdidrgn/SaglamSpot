import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/config/app_router.dart';
import 'core/config/web_config.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/util/platform_checker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 Web URL stratejisi (# işaretini kaldırır)
  if (PlatformChecker.isWeb) usePathUrlStrategy();

  await _initializeFirebase();
  await MobileAds.instance.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initializeFirebase() async {
  if (kIsWeb)
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: firebaseConfig['apiKey']!,
        appId: firebaseConfig['appId']!,
        messagingSenderId: firebaseConfig['messagingSenderId']!,
        projectId: firebaseConfig['projectId']!,
        storageBucket: firebaseConfig['storageBucket'],
      ),
    );
  else
    // Mobil platformlarda (Android/iOS) varsayılan yapılandırmayı kullanır.
    // Bu, android/app/ içindeki google-services.json dosyasını baz alır.
    await Firebase.initializeApp();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
