import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';

/// Native açılıştan sonra kısa markalı geçiş — sıcak marka rengi zemin,
/// ortada logo mark + "Sağlam Spot" tipografi. Router'a dokunmaz; sadece
/// görsel katman.
class AppLaunchSplashOverlay extends StatefulWidget {
  const AppLaunchSplashOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<AppLaunchSplashOverlay> createState() =>
      _AppLaunchSplashOverlayState();
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
        _pulseController.stop();
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
    return Stack(
      children: [
        widget.child,
        if (_overlayVisible)
          Positioned.fill(
            child: IgnorePointer(
              child: FadeTransition(
                opacity: ReverseAnimation(_exitFade),
                child: ColoredBox(
                  color: AppColors.accent,
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
                              width: 108,
                              height: 108,
                              fit: BoxFit.contain,
                              color: Colors.white,
                              colorBlendMode: BlendMode.srcIn,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            Text(
                              context.l10n.loginBrand,
                              style: AppTextStyles.serif(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              context.l10n.homeWelcomeTagline,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.35,
                                color: Colors.white.withValues(alpha: 0.88),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxxl),
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
            final double phase = (controller.value + index * 0.22) % 1.0;
            final double wave = (math.sin(phase * 2 * math.pi) + 1) / 2;
            final double opacity = 0.35 + 0.65 * wave;
            final double scale = 0.78 + 0.22 * wave;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: _dotGap / 2),
              child: Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: _dotSize,
                    height: _dotSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
