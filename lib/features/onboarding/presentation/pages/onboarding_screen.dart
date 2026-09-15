import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// "Ev içi tanıtım" — sadece ilk açılışta, native mobilde gösterilir (bkz.
/// app_router.dart initialLocation + OnboardingCache). ALTINCI SÜRÜM:
/// bir önceki (tam ekran tek fotoğraf) sürüm kullanıcıya "durgun" geldi —
/// bu sefer "editoryal poster" dili: asimetrik köşeli (uygulamanın ürün
/// kartlarıyla AYNI köşe dili — bkz. custom_product_card.dart) ana bir
/// fotoğraf kartı hafifçe döndürülmüş halde, arkasında daha küçük bir
/// ikinci fotoğraf (katmanlı derinlik illüzyonu), markanın rengiyle
/// boyanmış yumuşak "radiant" gölgeler, sürekli yavaşça süzülen renkli
/// bulutlar ve dekoratif bir yay çizgisi. Sürüklemeye bağlı parallax
/// (ana/yan fotoğraf farklı hızda kayar) + sayfa yerleşince oynayan bir
/// "pop" animasyonu. Fotoğraflar sabit (kod içine gömülü) Unsplash
/// URL'leri — Firestore'a veya canlı veriye hâlâ bağlı değil.
class HouseWalkthroughOnboardingScreen extends StatefulWidget {
  const HouseWalkthroughOnboardingScreen({super.key});

  @override
  State<HouseWalkthroughOnboardingScreen> createState() =>
      _HouseWalkthroughOnboardingScreenState();
}

class _HouseWalkthroughOnboardingScreenState
    extends State<HouseWalkthroughOnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  static const int _pageCount = 3;

  /// Arka plandaki renkli bulutların sürekli, yavaş dolaşımı.
  late final AnimationController _ambientController =
      AnimationController(vsync: this, duration: const Duration(seconds: 16))..repeat();

  /// Sayfa yerleşince kartların/metnin oynadığı "pop" — sayfa her
  /// değiştiğinde baştan oynatılır.
  late final AnimationController _revealController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 750))..forward();

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
    _ambientController.dispose();
    _revealController.dispose();
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
        duration: const Duration(milliseconds: 550), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(final BuildContext context) {
    final pages = [
      (
        context.l10n.onboardingPage1Eyebrow,
        context.l10n.onboardingPage1Title,
        context.l10n.onboardingPage1Desc,
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=85',
        'https://images.unsplash.com/photo-1517705008128-361805f42e86?auto=format&fit=crop&w=700&q=80',
      ),
      (
        context.l10n.onboardingPage2Eyebrow,
        context.l10n.onboardingPage2Title,
        context.l10n.onboardingPage2Desc,
        'https://images.unsplash.com/photo-1530018607912-eff2daa1bac4?auto=format&fit=crop&w=1200&q=85',
        'https://images.unsplash.com/photo-1540932239986-30128078f3c5?auto=format&fit=crop&w=700&q=80',
      ),
      (
        context.l10n.onboardingPage3Eyebrow,
        context.l10n.onboardingPage3Title,
        context.l10n.onboardingPage3Desc,
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=1200&q=85',
        'https://images.unsplash.com/photo-1600166898405-da9535204843?auto=format&fit=crop&w=700&q=80',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _ambientController,
            builder: (final context, final _) =>
                _AmbientGlowBackground(t: _ambientController.value),
          ),
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: _pageCount,
            itemBuilder: (final context, final index) {
              final (eyebrow, title, desc, mainImage, accentImage) = pages[index];
              return AnimatedBuilder(
                animation: Listenable.merge([_pageController, _revealController]),
                builder: (final context, final _) {
                  final page = _pageController.hasClients
                      ? (_pageController.page ?? index.toDouble())
                      : index.toDouble();
                  final local = (page - index).clamp(-1.0, 1.0);
                  final isSettled = local.abs() < 0.02;
                  final reveal = isSettled
                      ? Curves.easeOutBack.transform(_revealController.value)
                      : 1.0;

                  return _OnboardingPageContent(
                    dragProximity: local,
                    reveal: reveal.clamp(0.0, 1.3),
                    eyebrow: eyebrow,
                    title: title,
                    desc: desc,
                    mainImage: mainImage,
                    accentImage: accentImage,
                    tilt: index.isEven ? -0.045 : 0.045,
                  );
                },
              );
            },
          ),

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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 26),
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
                              color: selected ? AppColors.mobilePrimary : AppColors.mobileBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
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
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))
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
}

/// Sürekli, yavaş dolaşan üç yumuşak gradyan lekesi — marka renklerinde
/// (sabit gri/mavi değil), "sinematik" bir arka plan dokusu.
class _AmbientGlowBackground extends StatelessWidget {
  final double t;
  const _AmbientGlowBackground({required this.t});

  @override
  Widget build(final BuildContext context) {
    final size = MediaQuery.of(context).size;
    Offset orbit(final double phase, final double radiusX, final double radiusY, final Offset center) {
      final angle = (t * 2 * math.pi) + phase;
      return Offset(center.dx + math.cos(angle) * radiusX, center.dy + math.sin(angle) * radiusY);
    }

    final p1 = orbit(0, size.width * 0.3, size.height * 0.1, Offset(size.width * 0.2, size.height * 0.22));
    final p2 = orbit(math.pi * 0.7, size.width * 0.24, size.height * 0.18,
        Offset(size.width * 0.82, size.height * 0.58));
    final p3 = orbit(math.pi * 1.4, size.width * 0.2, size.height * 0.16,
        Offset(size.width * 0.45, size.height * 0.9));

    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.mobileBackground),
        child: Stack(
          children: [
            _blob(p1, 280, AppColors.mobileAccent.withOpacity(0.22)),
            _blob(p2, 320, AppColors.mobilePrimary.withOpacity(0.14)),
            _blob(p3, 240, AppColors.mobileAccentDark.withOpacity(0.16)),
          ],
        ),
      ),
    );
  }

  Widget _blob(final Offset center, final double size, final Color color) => Positioned(
        left: center.dx - size / 2,
        top: center.dy - size / 2,
        child: IgnorePointer(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
            ),
          ),
        ),
      );
}

/// Tek bir sayfa: hafifçe döndürülmüş, asimetrik köşeli ana fotoğraf kartı
/// (uygulamanın ürün kartlarıyla aynı köşe dili) + arkasında kayan, daha
/// küçük bir ikinci fotoğraf (parallax'lı katman derinliği illüzyonu) +
/// dekoratif yay çizgisi + altta eyebrow/başlık/açıklama.
class _OnboardingPageContent extends StatelessWidget {
  final double dragProximity; // -1..1, 0 = tam ortalanmış
  final double reveal; // 0..~1.3
  final String eyebrow;
  final String title;
  final String desc;
  final String mainImage;
  final String accentImage;
  final double tilt;

  const _OnboardingPageContent({
    required this.dragProximity,
    required this.reveal,
    required this.eyebrow,
    required this.title,
    required this.desc,
    required this.mainImage,
    required this.accentImage,
    required this.tilt,
  });

  static const BorderRadius _mainShape = BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(46),
    bottomLeft: Radius.circular(46),
    bottomRight: Radius.circular(12),
  );

  @override
  Widget build(final BuildContext context) {
    final proximityFade = (1 - dragProximity.abs()).clamp(0.0, 1.0);
    final popScale = (0.85 + 0.15 * reveal).clamp(0.0, 1.3);
    final textReveal = reveal.clamp(0.0, 1.0);
    // Sürüklemeye bağlı parallax: yan fotoğraf ana fotoğraftan daha hızlı
    // kayar — bu fark, gözün iki katmanı ayrı derinlikte algılamasını
    // sağlayan basit ama etkili bir "görsel illüzyon".
    final parallaxDx = dragProximity * 34;

    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Opacity(
            opacity: proximityFade,
            child: Center(
              child: Transform.scale(
                scale: popScale,
                child: SizedBox(
                  width: 268,
                  height: 300,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Dekoratif yay — "modern sanatsal çizgi" dokunuşu.
                      Positioned(
                        right: -18,
                        top: 6,
                        child: Transform.translate(
                          offset: Offset(-parallaxDx * 0.4, 0),
                          child: CustomPaint(
                            size: const Size(120, 120),
                            painter: _ArcPainter(color: AppColors.mobileAccentDark),
                          ),
                        ),
                      ),
                      // Arkadaki küçük ikinci fotoğraf — katmanlı derinlik.
                      Positioned(
                        left: 46,
                        bottom: 6,
                        child: Transform.translate(
                          offset: Offset(parallaxDx, 0),
                          child: Transform.rotate(
                            angle: -tilt * 1.6,
                            child: Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.mobilePrimaryDark.withOpacity(0.28),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: OptimizedCachedImage(
                                  imageUrl: accentImage,
                                  fit: BoxFit.cover,
                                  borderRadius: 0,
                                  errorBuilder: (final c, final u, final e) =>
                                      DecoratedBox(
                                          decoration: BoxDecoration(
                                              gradient: AppColors.mobileAccentGradient)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Ana fotoğraf kartı — asimetrik köşe + hafif döndürme
                      // + marka renginde "radiant" gölge.
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Transform.translate(
                          offset: Offset(parallaxDx * 0.35, 0),
                          child: Transform.rotate(
                            angle: tilt,
                            child: Container(
                              width: 210,
                              height: 270,
                              decoration: BoxDecoration(
                                borderRadius: _mainShape,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.16),
                                    blurRadius: 22,
                                    offset: const Offset(0, 14),
                                  ),
                                  BoxShadow(
                                    color: AppColors.mobileAccent.withOpacity(0.35),
                                    blurRadius: 34,
                                    spreadRadius: -10,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: _mainShape,
                                child: OptimizedCachedImage(
                                  imageUrl: mainImage,
                                  fit: BoxFit.cover,
                                  borderRadius: 0,
                                  errorBuilder: (final c, final u, final e) =>
                                      DecoratedBox(
                                          decoration: BoxDecoration(
                                              gradient: AppColors.mobilePrimaryGradient)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Küçük yörüngedeki vurgu noktası — sanatsal detay.
                      Positioned(
                        right: 6,
                        bottom: 40,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.mobileAccentLight,
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.mobileAccent.withOpacity(0.5),
                                  blurRadius: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 4, 32, 0),
            child: Opacity(
              opacity: (proximityFade * (0.3 + 0.7 * textReveal)).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, (1 - textReveal) * 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
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
                        fontSize: 29,
                        fontWeight: FontWeight.w600,
                        height: 1.12,
                        color: AppColors.mobileTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      desc,
                      style: TextStyle(
                          fontSize: 14, height: 1.5, color: AppColors.mobileTextSecondary),
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

/// Ana fotoğrafın arkasında yarım kalan, ince bir dekoratif yay — "modern
/// sanatsal çizgi" dokunuşu, tamamen soyut, markanın aksan rengiyle.
class _ArcPainter extends CustomPainter {
  final Color color;
  const _ArcPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, math.pi * 1.1, math.pi * 0.9, false, paint);

    final dotPaint = Paint()..color = color.withOpacity(0.5);
    canvas.drawCircle(Offset(size.width * 0.06, size.height * 0.46), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant final _ArcPainter oldDelegate) =>
      oldDelegate.color != color;
}
