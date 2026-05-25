import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Edge-to-Edge yönetimi için eklendi
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/config/app_initializer.dart';
import 'core/config/app_router.dart';
import 'core/localization/locale_provider.dart';
import 'core/services/deeplink/deeplink_listener_service.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // Flutter binding mimarisinin başlatıldığından emin olunur
  WidgetsFlutterBinding.ensureInitialized();

  // Modern Edge-to-Edge Yapılandırması (ÖNERİLEN İŞLEM 1)
  // Desteği sonlandırılmış tüm eski parametreler temizlendi.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Sistem çubuklarının arka planlarını şeffaf yaparak tam uyumluluk sağlanır
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    // Light tema uyumu için varsayılan
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  await AppInitializer.init(); // Her şeyi tek bir yerden başlat
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
    _router = ref.read(appRouterProvider); //
    DeeplinkListener.init(_router); // 🔗 Deeplink listener (1 kere)
  }

  @override
  void dispose() {
    DeeplinkListener.stop(); //
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final appTheme = ref.watch(appThemeProvider); //
    final localeAsync = ref.watch(localeControllerProvider); //

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sağlam Spot',
      //
      theme: appTheme.lightTheme,
      //
      darkTheme: appTheme.darkTheme,
      //
      themeMode: ThemeMode.light,
      //
      locale: localeAsync.value ?? const Locale('tr'),
      //
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      //
      supportedLocales: AppLocalizations.supportedLocales,
      //
      routerConfig: _router,
      //

      // Uygulama genelinde Safe Area kontrolü alt katmanlara bırakılacaktır.
      builder: (context, child) {
        return MediaQuery(
          // Cihazın safe inset'lerini tüm alt sayfalara doğru şekilde izole eder
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}