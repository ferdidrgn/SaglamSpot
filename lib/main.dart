import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_initializer.dart';
import 'core/config/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  await AppInitializer.init(); //Her şeyi tek bir yerden başlat
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sağlam Spotçu',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
