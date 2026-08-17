import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// "Ev içi tanıtım" — sadece ilk açılışta, native mobilde gösterilir (bkz.
/// app_router.dart initialLocation + OnboardingCache). DÖRDÜNCÜ SÜRÜM:
/// Firestore'a (canlı ürün fotoğrafına) bilinçli olarak ARTIK BAĞLI DEĞİL
/// — hem ilk açılışta veri henüz gelmemiş/boş olabiliyordu, hem de bu
/// kritik ilk-izlenim ekranının ağ/veri durumuna bağımlı olması hiç
/// istenmiyor. Bunun yerine tamamen HAREKETLİ, sanatsal bir motion-design
/// dili: sürekli kayan/nefes alan gradyan bulutları, sayfa yerleşince
/// "pop" ile içeri sıçrayan elle kompoze edilmiş mobilya sahneleri,
/// sürekli hafif yüzen (idle) hareket, sürüklemeye bağlı sinematik
/// zoom+fade geçişi. Hepsi salt Flutter animasyon ilkel'leriyle — foto
/// veya harici görsel varlığı yok.
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

  /// Arka plandaki gradyan bulutlarının sürekli, yavaş dolaşımı — hiç
  /// durmaz, sayfadan bağımsız.
  late final AnimationController _ambientController =
      AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();

  /// O anki sayfanın mobilya sahnesi için "içeri sıçrama" (pop-in) —
  /// sayfa her değiştiğinde baştan oynatılır.
  late final AnimationController _revealController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 850))..forward();

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
    final copy = [
      (
        context.l10n.onboardingPage1Eyebrow,
        context.l10n.onboardingPage1Title,
        context.l10n.onboardingPage1Desc,
      ),
      (
        context.l10n.onboardingPage2Eyebrow,
        context.l10n.onboardingPage2Title,
        context.l10n.onboardingPage2Desc,
      ),
      (
        context.l10n.onboardingPage3Eyebrow,
        context.l10n.onboardingPage3Title,
        context.l10n.onboardingPage3Desc,
      ),
    ];
    const scenes = [_LivingRoomScene(), _DiningCornerScene(), _ReadingCornerScene()];

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: Stack(
        children: [
          // ── Sürekli hareket eden gradyan bulutları — hiç durmaz ──
          AnimatedBuilder(
            animation: _ambientController,
            builder: (final context, final _) =>
                _AmbientGlowBackground(t: _ambientController.value),
          ),

          // ── Sayfalar ──
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: _pageCount,
            itemBuilder: (final context, final index) {
              final (eyebrow, title, desc) = copy[index];
              return AnimatedBuilder(
                animation: Listenable.merge([_pageController, _revealController]),
                builder: (final context, final _) {
                  final page = _pageController.hasClients
                      ? (_pageController.page ?? index.toDouble())
                      : index.toDouble();
                  final local = (page - index).clamp(-1.0, 1.0);
                  final isSettled = local.abs() < 0.02;
                  final reveal = isSettled ? Curves.easeOutBack.transform(_revealController.value) : 1.0;

                  return _OnboardingPageContent(
                    dragProximity: local,
                    reveal: reveal.clamp(0.0, 1.3),
                    eyebrow: eyebrow,
                    title: title,
                    desc: desc,
                    scene: scenes[index],
                  );
                },
              );
            },
          ),

          // ── Sabit üst-alt kontrol katmanı ──
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

/// Sürekli, yavaş dolaşan üç yumuşak gradyan lekesi — "sinematik" bir
/// arka plan dokusu. `t` 0..1 arası döngüsel ilerleme; her leke farklı
/// faz/yarıçapta dairesel bir yörüngede süzülür.
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

    final p1 = orbit(0, size.width * 0.28, size.height * 0.12, Offset(size.width * 0.25, size.height * 0.28));
    final p2 = orbit(math.pi * 0.7, size.width * 0.22, size.height * 0.16,
        Offset(size.width * 0.75, size.height * 0.62));
    final p3 = orbit(math.pi * 1.4, size.width * 0.18, size.height * 0.14,
        Offset(size.width * 0.5, size.height * 0.85));

    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.mobileBackground),
        child: Stack(
          children: [
            _blob(p1, 260, AppColors.mobileAccent.withOpacity(0.20)),
            _blob(p2, 300, AppColors.mobilePrimary.withOpacity(0.16)),
            _blob(p3, 220, AppColors.mobileAccentDark.withOpacity(0.14)),
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

/// Tek bir sayfa: mobilya sahnesi (pop-in + sürüklemeye bağlı zoom/fade)
/// üstte, eyebrow/başlık/açıklama altta (kendi kademeli giriş animasyonuyla).
class _OnboardingPageContent extends StatelessWidget {
  final double dragProximity; // -1..1, 0 = tam ortalanmış
  final double reveal; // 0..~1.3, sayfa yerleşince oynayan "pop" eğrisi
  final String eyebrow;
  final String title;
  final String desc;
  final Widget scene;

  const _OnboardingPageContent({
    required this.dragProximity,
    required this.reveal,
    required this.eyebrow,
    required this.title,
    required this.desc,
    required this.scene,
  });

  @override
  Widget build(final BuildContext context) {
    final proximityFade = (1 - dragProximity.abs()).clamp(0.0, 1.0);
    final dragScale = 0.90 + 0.10 * proximityFade;
    final popScale = (0.82 + 0.18 * reveal).clamp(0.0, 1.4);
    final textReveal = reveal.clamp(0.0, 1.0);

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Opacity(
            opacity: proximityFade,
            child: Transform.scale(
              scale: dragScale * popScale,
              child: Center(child: scene),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
            child: Opacity(
              opacity: (proximityFade * (0.3 + 0.7 * textReveal)).clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, (1 - textReveal) * 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                        fontSize: 30,
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

// ════════════════════════════════════════════════════════════
// SAHNELER — düz-illüstrasyon dilinde, elle kompoze edilmiş, tam
// opak mobilya şekilleri (tek bir jenerik ikon DEĞİL). FittedBox ile
// her ekran genişliğine güvenle sığdırılır.
// ════════════════════════════════════════════════════════════

const double _kCanvasW = 300;
const double _kCanvasH = 260;

class _LivingRoomScene extends StatelessWidget {
  const _LivingRoomScene();

  @override
  Widget build(final BuildContext context) => const _SceneCanvas(
        background: [
          _WallArt(left: 20, top: 6, size: 70, color: null),
          _Window(left: 190, top: 0, width: 90, height: 120),
        ],
        midground: [
          Positioned(left: 20, top: 108, child: _Sofa()),
        ],
        foreground: [
          Positioned(left: 232, top: 128, child: _FloorLamp()),
          Positioned(left: 8, top: 176, child: _Plant(scale: 0.85)),
          Positioned(left: 4, top: 214, child: _Rug(width: 270)),
        ],
      );
}

class _DiningCornerScene extends StatelessWidget {
  const _DiningCornerScene();

  @override
  Widget build(final BuildContext context) => const _SceneCanvas(
        background: [
          _Window(left: 20, top: 0, width: 100, height: 112),
          _PendantLamp(left: 170, top: 0, height: 84),
        ],
        midground: [
          Positioned(left: 86, top: 126, child: _RoundTable()),
          Positioned(left: 52, top: 158, child: _DiningChair(flip: false)),
          Positioned(left: 210, top: 158, child: _DiningChair(flip: true)),
        ],
        foreground: [
          Positioned(left: 226, top: 92, child: _Plant(scale: 0.7)),
          Positioned(left: 2, top: 214, child: _Rug(width: 288)),
        ],
      );
}

class _ReadingCornerScene extends StatelessWidget {
  const _ReadingCornerScene();

  @override
  Widget build(final BuildContext context) => const _SceneCanvas(
        background: [
          _Window(left: 158, top: 0, width: 120, height: 140),
          _Bookshelf(left: 4, top: 8, width: 62, height: 132),
        ],
        midground: [
          Positioned(left: 134, top: 118, child: _ArmChair()),
        ],
        foreground: [
          Positioned(left: 266, top: 126, child: _FloorLamp()),
          Positioned(left: 50, top: 172, child: _Plant(scale: 0.95)),
          Positioned(left: 16, top: 214, child: _Rug(width: 250)),
        ],
      );
}

class _SceneCanvas extends StatelessWidget {
  final List<Widget> background;
  final List<Widget> midground;
  final List<Widget> foreground;

  const _SceneCanvas({
    required this.background,
    required this.midground,
    required this.foreground,
  });

  @override
  Widget build(final BuildContext context) => FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _kCanvasW,
          height: _kCanvasH,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ...background,
              ...midground,
              ...foreground,
            ],
          ),
        ),
      );
}

// ════════════════════════════════════════════════════════════
// MOBİLYA PARÇALARI — birden çok şekilden elle kompoze edilmiş.
// ════════════════════════════════════════════════════════════

class _Sofa extends StatelessWidget {
  const _Sofa();

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: 210,
        height: 100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 6,
              bottom: -4,
              child: Container(
                width: 198,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 6,
              child: Container(
                width: 210,
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.mobilePrimary, AppColors.mobilePrimaryDark],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 0,
              child: Container(
                width: 182,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.mobilePrimaryDark,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            Positioned(
              left: -8,
              top: 14,
              child: Container(
                width: 32,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.mobilePrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              right: -8,
              top: 14,
              child: Container(
                width: 32,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.mobilePrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(left: 34, top: 36, child: _Cushion(color: AppColors.mobileAccent)),
            Positioned(left: 90, top: 36, child: _Cushion(color: AppColors.mobileAccentLight)),
            Positioned(left: 146, top: 36, child: _Cushion(color: AppColors.mobileAccent)),
            Positioned(left: 18, bottom: 0, child: _Leg()),
            Positioned(right: 18, bottom: 0, child: _Leg()),
          ],
        ),
      );
}

class _ArmChair extends StatelessWidget {
  const _ArmChair();

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: 110,
        height: 100,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 4,
              bottom: -4,
              child: Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 6,
              child: Container(
                width: 110,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.mobileAccentDark,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 0,
              child: Container(
                width: 90,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.mobileAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              left: -6,
              top: 12,
              child: Container(
                width: 24,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.mobileAccentDark,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(
              right: -6,
              top: 12,
              child: Container(
                width: 24,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.mobileAccentDark,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(left: 32, top: 30, child: _Cushion(color: AppColors.mobilePrimaryLight)),
            Positioned(left: 12, bottom: 0, child: _Leg()),
            Positioned(right: 12, bottom: 0, child: _Leg()),
          ],
        ),
      );
}

class _Cushion extends StatelessWidget {
  final Color color;
  const _Cushion({required this.color});

  @override
  Widget build(final BuildContext context) => Container(
        width: 40,
        height: 34,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      );
}

class _Leg extends StatelessWidget {
  const _Leg();

  @override
  Widget build(final BuildContext context) => Container(
        width: 8,
        height: 14,
        decoration: BoxDecoration(
          color: AppColors.mobileTextTertiary,
          borderRadius: BorderRadius.circular(3),
        ),
      );
}

class _RoundTable extends StatelessWidget {
  const _RoundTable();

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          Container(
            width: 140,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.mobileAccentDark,
              borderRadius: BorderRadius.circular(70),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
          ),
          Container(width: 10, height: 46, color: AppColors.mobileTextTertiary),
          Container(
            width: 60,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.mobileTextTertiary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      );
}

class _DiningChair extends StatelessWidget {
  final bool flip;
  const _DiningChair({required this.flip});

  @override
  Widget build(final BuildContext context) => Transform.flip(
        flipX: flip,
        child: SizedBox(
          width: 46,
          height: 70,
          child: Stack(
            children: [
              Positioned(
                left: 4,
                top: 0,
                child: Container(
                  width: 8,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.mobilePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 40,
                child: Container(
                  width: 40,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.mobilePrimaryDark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              Positioned(left: 2, bottom: 0, child: _Leg()),
              Positioned(right: 2, bottom: 0, child: _Leg()),
            ],
          ),
        ),
      );
}

class _FloorLamp extends StatelessWidget {
  const _FloorLamp();

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          ClipPath(
            clipper: _TrapezoidClipper(),
            child: Container(
              width: 54,
              height: 34,
              color: AppColors.mobileAccentLight,
            ),
          ),
          Container(width: 6, height: 70, color: AppColors.mobileTextTertiary),
          Container(
            width: 40,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.mobileTextTertiary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      );
}

class _PendantLamp extends StatelessWidget {
  final double left;
  final double top;
  final double height;

  const _PendantLamp({required this.left, required this.top, required this.height});

  @override
  Widget build(final BuildContext context) => Positioned(
        left: left,
        top: top,
        child: Column(
          children: [
            Container(width: 2, height: height, color: AppColors.mobileBorder),
            ClipPath(
              clipper: _TrapezoidClipper(),
              child: Container(width: 50, height: 30, color: AppColors.mobileAccent),
            ),
          ],
        ),
      );
}

class _TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(final Size size) => Path()
    ..moveTo(size.width * 0.22, 0)
    ..lineTo(size.width * 0.78, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(final CustomClipper<Path> oldClipper) => false;
}

class _Plant extends StatelessWidget {
  final double scale;
  const _Plant({this.scale = 1});

  @override
  Widget build(final BuildContext context) => Transform.scale(
        scale: scale,
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 60,
          height: 84,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 0,
                child: ClipPath(
                  clipper: _TrapezoidClipper(),
                  child: Container(width: 44, height: 30, color: AppColors.mobileAccentDark),
                ),
              ),
              Positioned(bottom: 26, child: _leaf(-18, 0)),
              Positioned(bottom: 30, child: _leaf(18, 0.3)),
              Positioned(bottom: 20, child: _leaf(0, -0.15)),
            ],
          ),
        ),
      );

  Widget _leaf(final double dx, final double angle) => Transform.translate(
        offset: Offset(dx, 0),
        child: Transform.rotate(
          angle: angle,
          child: Container(
            width: 16,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.mobilePrimaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
}

class _Window extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final double height;

  const _Window({required this.left, required this.top, required this.width, required this.height});

  @override
  Widget build(final BuildContext context) => Positioned(
        left: left,
        top: top,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.mobileBorder, width: 5),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.mobileAccentLight.withOpacity(0.55), AppColors.mobileAccent.withOpacity(0.25)],
            ),
          ),
          child: Column(
            children: [
              const Spacer(),
              Container(height: 3, color: AppColors.mobileBorder),
              const Spacer(),
            ],
          ),
        ),
      );
}

class _WallArt extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color? color;

  const _WallArt({required this.left, required this.top, required this.size, required this.color});

  @override
  Widget build(final BuildContext context) => Positioned(
        left: left,
        top: top,
        child: Container(
          width: size,
          height: size * 0.78,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.mobileSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.mobileBorder, width: 3),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: (color ?? AppColors.mobileAccent).withOpacity(0.6), shape: BoxShape.circle),
          ),
        ),
      );
}

class _Bookshelf extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final double height;

  const _Bookshelf({required this.left, required this.top, required this.width, required this.height});

  static const _bookColors = [
    Color(0xFFB4543A),
    Color(0xFF7C8B6F),
    Color(0xFFC98A4B),
    Color(0xFF6E7D8F),
  ];

  @override
  Widget build(final BuildContext context) => Positioned(
        left: left,
        top: top,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.mobileTextTertiary.withOpacity(0.85),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: List.generate(3, (final row) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.mobileSurface,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  child: Row(
                    children: List.generate(4, (final i) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          color: _bookColors[(row + i) % _bookColors.length],
                        ),
                      );
                    }),
                  ),
                ),
              );
            }),
          ),
        ),
      );
}

class _Rug extends StatelessWidget {
  final double width;

  const _Rug({required this.width});

  @override
  Widget build(final BuildContext context) => Container(
        width: width,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.mobileAccentLight.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.mobileAccentLight.withOpacity(0.85), width: 2),
        ),
      );
}
