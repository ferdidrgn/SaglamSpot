import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// İlk açılış onboarding — üstte yaşam alanı fotoğrafı (alt kenarı
/// yumuşak eğri), altta Sağlam Spot metni + segment ilerleme + İleri.
class HouseWalkthroughOnboardingScreen extends StatefulWidget {
  const HouseWalkthroughOnboardingScreen({super.key});

  @override
  State<HouseWalkthroughOnboardingScreen> createState() =>
      _HouseWalkthroughOnboardingScreenState();
}

class _HouseWalkthroughOnboardingScreenState
    extends State<HouseWalkthroughOnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  static const int _pageCount = 3;

  late final AnimationController _revealController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700))
    ..forward();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _pageIndex) {
        setState(() => _pageIndex = page);
        _revealController.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  Future<void> _finish(final BuildContext context) async {
    await OnboardingCache.markSeen();
    unawaited(NotificationService.init());
    if (context.mounted) {
      NavigationHandler.goToHome(context);
    }
  }

  void _next() {
    if (_pageIndex >= _pageCount - 1) {
      _finish(context);
      return;
    }
    _pageController.nextPage(
        duration: AppMotion.slow, curve: AppMotion.standard);
  }

  @override
  Widget build(final BuildContext context) {
    final pages = [
      (
        context.l10n.onboardingPage1Eyebrow,
        context.l10n.onboardingPage1Title,
        context.l10n.onboardingPage1Desc,
        'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=900&h=1400&q=85',
      ),
      (
        context.l10n.onboardingPage2Eyebrow,
        context.l10n.onboardingPage2Title,
        context.l10n.onboardingPage2Desc,
        'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=900&h=1400&q=85',
      ),
      (
        context.l10n.onboardingPage3Eyebrow,
        context.l10n.onboardingPage3Title,
        context.l10n.onboardingPage3Desc,
        'https://images.unsplash.com/photo-1631679706909-1844bbd07221?auto=format&fit=crop&w=900&h=1400&q=85',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.mobileSurface,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: _pageCount,
                itemBuilder: (final context, final index) {
                  final (eyebrow, title, desc, imageUrl) = pages[index];
                  return AnimatedBuilder(
                    animation: _revealController,
                    builder: (final context, final _) => _OnboardingPage(
                      imageUrl: imageUrl,
                      reveal: Curves.easeOutCubic
                          .transform(_revealController.value),
                      eyebrow: eyebrow,
                      title: title,
                      desc: desc,
                      onSkip: () => _finish(context),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl, AppSpacing.md, AppSpacing.xxl, AppSpacing.xxl),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(_pageCount, (final i) {
                        final selected = i == _pageIndex;
                        return Expanded(
                          flex: selected ? 3 : 1,
                          child: AnimatedContainer(
                            duration: AppMotion.normal,
                            curve: AppMotion.standard,
                            height: 5,
                            margin: EdgeInsets.only(
                                right: i == _pageCount - 1 ? 0 : 6),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.mobileAccent
                                  : AppColors.mobileMuted
                                      .withValues(alpha: 0.45),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.pill),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mobileAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        _pageIndex == _pageCount - 1
                            ? context.l10n.onboardingStart
                            : context.l10n.onboardingNext,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 14.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String imageUrl;
  final double reveal;
  final String eyebrow;
  final String title;
  final String desc;
  final VoidCallback onSkip;

  const _OnboardingPage({
    required this.imageUrl,
    required this.reveal,
    required this.eyebrow,
    required this.title,
    required this.desc,
    required this.onSkip,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 58,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipPath(
                clipper: const _WaveBottomClipper(),
                child: OptimizedCachedImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                  errorBuilder: (final c, final u, final e) => DecoratedBox(
                    decoration:
                        BoxDecoration(gradient: AppColors.mobilePrimaryGradient),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
                    child: TextButton(
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black.withValues(alpha: 0.22),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                      ),
                      child: Text(
                        '${context.l10n.onboardingSkip} →',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 42,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl, AppSpacing.sm, AppSpacing.xxl, 0),
            child: Opacity(
              opacity: reveal.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, (1 - reveal) * 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
                      style: AppTextStyles.microLabel(
                        fontSize: 11,
                        letterSpacing: 1.8,
                        color: AppColors.mobileAccent,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      title.replaceAll('\n', ' '),
                      style: AppTextStyles.serif(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        color: AppColors.mobileAccentDark,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.5,
                        color: AppColors.mobileTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveBottomClipper extends CustomClipper<Path> {
  const _WaveBottomClipper();

  @override
  Path getClip(final Size size) {
    final path = Path()
      ..lineTo(0, size.height - 36)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height + 10,
        size.width,
        size.height - 36,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant final CustomClipper<Path> oldClipper) => false;
}
