import 'package:flutter/foundation.dart';
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
  // Başlatıcıyı çalıştır ve cihazın güvenli olup olmadığını yakala
  final bool isDeviceSecure = await AppInitializer.init();

  runApp(
    ProviderScope(child: MyApp(isDeviceSecure: isDeviceSecure)),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final bool isDeviceSecure;

  const MyApp({super.key, required this.isDeviceSecure});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();

    // 🛡️ Sadece cihaz güvenliyse router ve deeplink servislerini ayağa kaldır
    if (widget.isDeviceSecure) {
      _router = ref.read(appRouterProvider);

      // 🔗 Deeplink listener (Web'de veya emülatörde patlamaması için güvenli çağrı)
      if (!kIsWeb) DeeplinkListener.init(_router!);
    }
  }

  @override
  void dispose() {
    if (widget.isDeviceSecure && !kIsWeb) DeeplinkListener.stop();

    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    final localeAsync = ref.watch(localeControllerProvider);

    // 🛡️ GÜVENLİK BARİYERİ: Cihaz rootlu veya güvensizse uygulamayı açma, uyarı ekranı göster
    if (!widget.isDeviceSecure)
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme.lightTheme,
        home: const Scaffold(
          backgroundColor: Color(0xA1628000),
          // Uygulamanın koyu mavi rengi (isteğe bağlı)
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security_update_warning_rounded,
                      color: Colors.redAccent, size: 84),
                  SizedBox(height: 24),
                  Text(
                    'Güvenlik Uyarısı',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Uygulamamızın ve kişisel verilerinizin güvenliği nedeniyle; root uygulanmış, jailbreak yapılmış veya sahte konum (mock location) kullanan cihazlarda Sağlam Spot çalıştırılamaz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: Colors.white24, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

    // Cihaz tamamen güvenliyse normal uygulama akışı devam eder
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
