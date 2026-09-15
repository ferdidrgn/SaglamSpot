import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Native (Android/iOS) açılış ekranı kapanır kapanmaz — yani Flutter ilk
/// kareyi çizer çizmez — üstüne binen, kısa ömürlü, MARKALI bir geçiş
/// katmanı. Native splash statik bir görselken bu widget logoyu hafifçe
/// büyüterek/belirginleştirerek (fade + scale) ve altında ince bir "nabız"
/// (pulse) göstergesiyle uygulamanın canlandığını hissettirir; ardından
/// kendini eritip (fade-out) asıl arayüzü ortaya çıkarır.
///
/// BİLEREK router/redirect mantığına DOKUNMUYOR: [child] (go_router'ın
/// initialLocation'ı, main()'de AdminSessionCache/OnboardingCache senkron
/// okumalarıyla ZATEN belirlenmiş durumdaki gerçek uygulama ağacı) en
/// baştan beri arkada normal şekilde inşa edilir/canlıdır — bu widget
/// sadece üstüne kısa süreliğine binen SAF GÖRSEL bir katmandır, hiçbir
/// navigasyon kararını geciktirmez, engellemez ya da değiştirmez. Ekstra
/// paket eklenmeden yalnızca Flutter'ın kendi AnimationController/Tween
/// altyapısıyla yazılmıştır.
///
/// Yalnızca native mobilde (!kIsWeb) kullanılır — web zaten native splash
/// oynatmıyor (bkz. pubspec.yaml `flutter_native_splash.web: false`), bu
/// yüzden web'de bu katman hiç build edilmez.
class AppLaunchSplashOverlay extends StatefulWidget {
  const AppLaunchSplashOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<AppLaunchSplashOverlay> createState() =>
      _AppLaunchSplashOverlayState();
}

class _AppLaunchSplashOverlayState extends State<AppLaunchSplashOverlay>
    with TickerProviderStateMixin {
  static const Duration _entryDuration = Duration(milliseconds: 550);
  static const Duration _holdDuration = Duration(milliseconds: 450);
  static const Duration _exitDuration = Duration(milliseconds: 400);

  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: _entryDuration,
  )..forward();

  /// Alt kısımdaki üç noktalı "yükleniyor" göstergesini sürekli döndürür —
  /// overlay görünür kaldığı sürece durmadan tekrar eder.
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  late final AnimationController _exitController = AnimationController(
    vsync: this,
    duration: _exitDuration,
  );

  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _entryController,
    curve: Curves.easeOut,
  );
  late final Animation<double> _logoScale = Tween<double>(begin: 0.82, end: 1.0)
      .animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack));
  late final Animation<double> _exitFade = CurvedAnimation(
    parent: _exitController,
    curve: Curves.easeIn,
  );

  Timer? _dismissTimer;

  /// Fade-out tamamlanınca overlay ağaçtan tamamen çıkarılır — kalıcı
  /// olarak boşta duran bir Stack/AnimatedBuilder ile hiçbir build/paint
  /// maliyeti kalmaz.
  bool _overlayVisible = true;

  @override
  void initState() {
    super.initState();
    _dismissTimer = Timer(_entryDuration + _holdDuration, () {
      if (!mounted) return;
      _exitController.forward().whenComplete(() {
        if (!mounted) return;
        setState(() => _overlayVisible = false);
      });
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _entryController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (!_overlayVisible) return widget.child;

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            // Overlay her zaman opak başlar; altındaki gerçek arayüzle
            // dokunuşların çakışmaması için dokunma olayları hep yok sayılır.
            child: AnimatedBuilder(
              animation: _exitController,
              builder: (final context, final splashChild) => Opacity(
                opacity: 1.0 - _exitFade.value,
                child: splashChild,
              ),
              child: ColoredBox(
                color: AppColors.background,
                child: Center(
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/saglam_spot_logo_mark.png',
                            width: 116,
                            height: 116,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            context.l10n.brand,
                            style: AppTextStyles.microLabel(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _LaunchPulseDots(controller: _pulseController),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sağdan sola dalga şeklinde belirip-solan üç nokta — sade, tek renkli,
/// ekstra paket gerektirmeyen bir "yükleniyor" ipucu (shimmer/pulse ailesi).
class _LaunchPulseDots extends StatelessWidget {
  const _LaunchPulseDots({required this.controller});

  final AnimationController controller;

  static const int _dotCount = 3;
  static const double _dotSize = 7;
  static const double _dotGap = 6;

  @override
  Widget build(final BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (final context, final _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_dotCount, (final index) {
            // Her nokta aynı sinüs dalgasını, biraz faz kaydırmasıyla
            // izler — böylece dalga soldan sağa akıyormuş gibi görünür.
            final double phase = (controller.value + index * 0.22) % 1.0;
            final double wave = (math.sin(phase * 2 * math.pi) + 1) / 2;
            final double opacity = 0.3 + 0.7 * wave;
            final double scale = 0.75 + 0.25 * wave;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: _dotGap / 2),
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: _dotSize,
                    height: _dotSize,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
