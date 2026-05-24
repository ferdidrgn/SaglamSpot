import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/config/app_initializer.dart';
import 'core/config/app_router.dart';
import 'core/localization/locale_provider.dart';
import 'core/services/deeplink/deeplink_listener_service.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  await AppInitializer.init(); //Her şeyi tek bir yerden başlat
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = ref.read(appRouterProvider);

    // 🔗 Deeplink listener (1 kere)
    DeeplinkListener.init(_router);
  }

  @override
  void dispose() {
    DeeplinkListener.stop();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    final localeAsync = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sağlam Spot',
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      themeMode: ThemeMode.light,
      locale: localeAsync.value ?? const Locale('tr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
