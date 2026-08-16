import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// "Ev içi tanıtım" — sadece ilk açılışta, native mobilde gösterilir
/// (bkz. app_router.dart initialLocation + OnboardingCache). Gerçek bir 3D
/// motor/model yok; bunun yerine üç KATMANLI PARALLAX ile "aynı evin
/// içinde, odadan odaya yürüyormuş gibi" bir his yaratılıyor: uzaktaki
/// duvar/pencere katmanı yavaş, ortadaki mobilya silüetleri orta hızda,
/// ön plandaki metin/CTA sayfa hızında kayıyor. Sağa-sola SÜRÜKLEYEREK
/// bu üç katman arasındaki hız farkı, gerçek bir mekânda yürüme hissi
/// veriyor — hepsi salt Flutter widget'larıyla, foto/3D varlık olmadan.
class HouseWalkthroughOnboardingScreen extends StatefulWidget {
  const HouseWalkthroughOnboardingScreen({super.key});

  @override
  State<HouseWalkthroughOnboardingScreen> createState() =>
      _HouseWalkthroughOnboardingScreenState();
}

class _HouseWalkthroughOnboardingScreenState
    extends State<HouseWalkthroughOnboardingScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  static const int _pageCount = 3;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _pageIndex) setState(() => _pageIndex = page);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish(final BuildContext context) async {
    await OnboardingCache.markSeen();
    if (context.mounted) NavigationHandler.goToHome(context);
  }

  void _next() {
    if (_pageIndex >= _pageCount - 1) {
      _finish(context);
      return;
    }
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(final BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: Stack(
        children: [
          // ── Katman 1: uzak duvar/pencere gradyanı (en yavaş) ──
          AnimatedBuilder(
            animation: _pageController,
            builder: (final context, final _) {
              final page = _currentPage();
              return _ParallaxLayer(
                page: page,
                factor: 0.32,
                screenWidth: screenWidth,
                canvasWidth: screenWidth * 2.3,
                child: const _FarWallLayer(),
              );
            },
          ),
          // ── Katman 2: mobilya silüetleri (orta hız) ──
          AnimatedBuilder(
            animation: _pageController,
            builder: (final context, final _) {
              final page = _currentPage();
              return _ParallaxLayer(
                page: page,
                factor: 0.6,
                screenWidth: screenWidth,
                canvasWidth: screenWidth * 2.9,
                child: const _FurnitureSilhouetteLayer(),
              );
            },
          ),
          // ── Katman 3: zemin şeridi (en hızlı arka plan katmanı) ──
          AnimatedBuilder(
            animation: _pageController,
            builder: (final context, final _) {
              final page = _currentPage();
              return _ParallaxLayer(
                page: page,
                factor: 0.85,
                screenWidth: screenWidth,
                canvasWidth: screenWidth * 3.4,
                child: const _FloorStripLayer(),
              );
            },
          ),

          // ── Ön plan: gerçek sayfa içeriği ──
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: TextButton(
                      onPressed: () => _finish(context),
                      child: Text(context.l10n.onboardingSkip,
                          style: TextStyle(
                              color: AppColors.mobileTextSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5)),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _OnboardingPageContent(
                        eyebrow: context.l10n.onboardingPage1Eyebrow,
                        title: context.l10n.onboardingPage1Title,
                        desc: context.l10n.onboardingPage1Desc,
                      ),
                      _OnboardingPageContent(
                        eyebrow: context.l10n.onboardingPage2Eyebrow,
                        title: context.l10n.onboardingPage2Title,
                        desc: context.l10n.onboardingPage2Desc,
                      ),
                      _OnboardingPageContent(
                        eyebrow: context.l10n.onboardingPage3Eyebrow,
                        title: context.l10n.onboardingPage3Title,
                        desc: context.l10n.onboardingPage3Desc,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pageCount, (final i) {
                          final selected = i == _pageIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: selected ? 26 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.mobilePrimary
                                  : AppColors.mobileBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mobilePrimary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: _pageIndex == _pageCount - 1
                              ? Text(context.l10n.onboardingStart,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800, fontSize: 15))
                              : const Icon(Icons.arrow_forward_rounded, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _currentPage() =>
      _pageController.hasClients ? (_pageController.page ?? 0.0) : 0.0;
}

/// Bir arka plan katmanını, PageView'un o anki kayma pozisyonuna göre
/// KENDİ hızında (factor < 1 => daha yavaş) kaydırır — parallax'ın özü.
class _ParallaxLayer extends StatelessWidget {
  final double page;
  final double factor;
  final double screenWidth;
  final double canvasWidth;
  final Widget child;

  const _ParallaxLayer({
    required this.page,
    required this.factor,
    required this.screenWidth,
    required this.canvasWidth,
    required this.child,
  });

  @override
  Widget build(final BuildContext context) => Positioned(
        top: 0,
        bottom: 0,
        left: -page * screenWidth * factor,
        width: canvasWidth,
        child: child,
      );
}

class _FarWallLayer extends StatelessWidget {
  const _FarWallLayer();

  @override
  Widget build(final BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.mobileSecondaryBg,
              AppColors.mobileBackground,
              AppColors.mobileSecondaryBg,
            ],
          ),
        ),
        child: Stack(
          children: [
            _softGlow(left: 40, top: 60, size: 220, color: AppColors.mobileAccent),
            _softGlow(left: 420, top: 120, size: 300, color: AppColors.mobilePrimary),
            _softGlow(left: 780, top: 40, size: 260, color: AppColors.mobileAccent),
            // "Pencere" — ikinci köşede sıcak bir ışık lekesi.
            Positioned(
              left: 520,
              top: 90,
              child: Container(
                width: 130,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.mobileAccentLight.withOpacity(0.35),
                      AppColors.mobileAccent.withOpacity(0.12),
                    ],
                  ),
                  border: Border.all(color: AppColors.mobileBorder, width: 2),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _softGlow(
          {required final double left,
          required final double top,
          required final double size,
          required final Color color}) =>
      Positioned(
        left: left,
        top: top,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withOpacity(0.14), Colors.transparent],
            ),
          ),
        ),
      );
}

class _FurnitureSilhouetteLayer extends StatelessWidget {
  const _FurnitureSilhouetteLayer();

  static const _motifs = <(IconData, double, double, double, double)>[
    // (icon, left, top, size, opacity)
    (Icons.weekend_rounded, 30, 320, 170, 0.16),
    (Icons.local_florist_rounded, 260, 260, 90, 0.18),
    (Icons.table_bar_rounded, 430, 340, 120, 0.14),
    (Icons.light_rounded, 620, 200, 70, 0.16),
    (Icons.chair_rounded, 760, 330, 110, 0.15),
    (Icons.bed_rounded, 960, 300, 150, 0.14),
    (Icons.local_florist_rounded, 1180, 280, 80, 0.16),
    (Icons.chair_alt_rounded, 1340, 260, 100, 0.13),
  ];

  @override
  Widget build(final BuildContext context) => Stack(
        children: _motifs
            .map((final m) => Positioned(
                  left: m.$2,
                  top: m.$3,
                  child: Icon(m.$1, size: m.$4, color: AppColors.mobileTextPrimary.withOpacity(m.$5)),
                ))
            .toList(),
      );
}

class _FloorStripLayer extends StatelessWidget {
  const _FloorStripLayer();

  @override
  Widget build(final BuildContext context) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.mobileCardBg.withOpacity(0.6)],
            ),
          ),
        ),
      );
}

class _OnboardingPageContent extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String desc;

  const _OnboardingPageContent(
      {required this.eyebrow, required this.title, required this.desc});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 3,
                fontWeight: FontWeight.w800,
                color: AppColors.mobileAccentDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.fraunces(
                fontSize: 34,
                fontWeight: FontWeight.w600,
                height: 1.12,
                color: AppColors.mobileTextPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              desc,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.55,
                color: AppColors.mobileTextSecondary,
              ),
            ),
          ],
        ),
      );
}
