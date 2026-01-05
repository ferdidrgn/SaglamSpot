import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'core/config/app_router.dart';
import 'core/config/web_config.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/util/platform_checker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 Web URL stratejisi (# kaldırır)
  if (PlatformChecker.isWeb) usePathUrlStrategy();

  await _initializeFirebase();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      appId: firebaseConfig['appId']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket'],
    ),
  );
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

      // 🔥 ROUTER ENTEGRASYONU
      routerConfig: router,
    );
  }
}
