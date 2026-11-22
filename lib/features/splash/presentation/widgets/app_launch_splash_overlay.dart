import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Native açılıştan sonra kısa markalı geçiş — siyah/altın logoyu gösterir.
/// Router'a dokunmaz; sadece
/// görsel katman.
class AppLaunchSplashOverlay extends StatefulWidget {
  const AppLaunchSplashOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<AppLaunchSplashOverlay> createState() => _AppLaunchSplashOverlayState();
}

class _AppLaunchSplashOverlayState extends State<AppLaunchSplashOverlay>
    with TickerProviderStateMixin {
  static const Duration _entryDuration = Duration(milliseconds: 380);
  static const Duration _holdDuration = Duration(milliseconds: 220);
  static const Duration _exitDuration = Duration(milliseconds: 280);

  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: _entryDuration,
  )..forward();

  late final AnimationController _exitController = AnimationController(
    vsync: this,
    duration: _exitDuration,
  );

  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _entryController,
    curve: AppMotion.standard,
  );
  late final Animation<double> _logoScale =
      Tween<double>(begin: 0.9, end: 1.0).animate(
    CurvedAnimation(parent: _entryController, curve: AppMotion.standard),
  );
  late final Animation<double> _exitFade = CurvedAnimation(
    parent: _exitController,
    curve: AppMotion.standard,
  );

  Timer? _dismissTimer;
  bool _overlayVisible = true;

  @override
  void initState() {
    super.initState();
    _dismissTimer = Timer(_entryDuration + _holdDuration, () {
      if (!mounted) {
        return;
      }
      _exitController.forward().whenComplete(() {
        if (!mounted) {
          return;
        }
        setState(() => _overlayVisible = false);
      });
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _entryController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // Native splash (flutter_native_splash) işletim sisteminin kendi açık/
    // koyu ayarına göre renk seçer (Flutter henüz çalışmadığı için
    // uygulamanın KENDİ tema tercihini okuyamaz). Bu katman onun hemen
    // ardından geliyor — AppColors.background/textPrimary (uygulamanın
    // SEÇİLİ teması, varsayılan "açık") yerine AYNI işletim sistemi
    // parlaklığını kullanmalı; aksi halde cihaz koyu modda ama uygulama
    // teması hâlâ varsayılan "açık" iken native splash koyu, bu katman
    // açık renkte açılıp rahatsız edici bir renk sıçraması/"bozukluk"
    // hissi yaratıyordu.
    const bg = Color(0xFF191512);

    return Stack(
      children: [
        widget.child,
        if (_overlayVisible)
          Positioned.fill(
            child: IgnorePointer(
              child: FadeTransition(
                opacity: ReverseAnimation(_exitFade),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: bg),
                  child: Center(
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Image.asset(
                          'assets/images/saglam_spot_logo_luxe.png',
                          width: math.min(
                              MediaQuery.sizeOf(context).width -
                                  AppSpacing.xxxl,
                              360.0),
                          height: math.min(
                              MediaQuery.sizeOf(context).width -
                                  AppSpacing.xxxl,
                              360.0),
                          fit: BoxFit.contain,
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
