import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/config/app_initializer.dart';
import 'core/config/app_router.dart';
import 'core/localization/locale_provider.dart';
import 'core/services/deeplink/deeplink_listener_service.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// Flutter web/masaüstünde varsayılan olarak fare ile "tıkla-sürükle" kaydırma
/// KAPALIDIR (sadece dokunmatik/touch destekleniyordu) — bu yüzden odalar,
/// küçük resimler, kategori şeritleri gibi yatay listeler masaüstünde fare
/// ile kaydırılamıyordu. Bu, tüm uygulama için tek seferde düzeltir.
class MouseDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
      };
}

void main() async {
  // 1. Flutter motorunun bağlayıcı kilit mekanizmasını güvenli bir şekilde başlat
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();

  // 2. İşletim sistemi arayüz düzen kurallarını (Edge-to-Edge) yarış durumuna düşmeden hemen işlet
  AppInitializer.configureSystemUIPreBoot();

  // 3. Arka plan servis ağını arayüz çizimini engellemeyecek şekilde asenkron olarak ayağa kaldır
  await AppInitializer.init(binding);

  runApp(
      const ProviderScope(observers: [], child: MyApp())
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _router = ref.read(appRouterProvider);

    // Uygulama genelinde derin link dinleme hattını tek seferlik güvenli modda başlat
    DeeplinkListener.init(_router);
  }

  @override
  void dispose() {
    DeeplinkListener.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    final localeAsync = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sağlam Spot',
      scrollBehavior: MouseDragScrollBehavior(),
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      themeMode: ThemeMode.light,
      // Editoryal lüks mimari tasarımı korumak adına açık renk şeması tabanlı tutulmuştur
      locale: localeAsync.value ?? const Locale('tr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
      builder: (final BuildContext context, final Widget? child) {
        return MediaQuery(
          // Editoryal tipografi sınırlarını tarayıcıların zoraki font büyütme manipülasyonlarından koru
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
