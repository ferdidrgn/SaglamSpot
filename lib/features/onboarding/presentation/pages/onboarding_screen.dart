import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// "Ev içi tanıtım" — sadece ilk açılışta, native mobilde gösterilir (bkz.
/// app_router.dart initialLocation + OnboardingCache). KÖKLÜ İKİNCİ SÜRÜM:
/// önceki versiyon çok soluk/küçük ikonlardan ibaretti ve "sadece metin"
/// gibi algılanıyordu. Şimdi her sayfa, düz-illüstrasyon dilinde ELLE
/// KOMPOZE EDİLMİŞ, tam opak, ekranın büyük kısmını kaplayan bir "oda
/// köşesi" sahnesi (kanepe/masa/koltuk + halı + lamba + pencere/duvar
/// panosu) içeriyor — jenerik tek bir ikon değil, birden çok şekilden
/// kurulmuş gerçek mobilya siluetleri. Gerçek bir 3D motor yok; "odadan
/// odaya yürüme" hissi iki şeyden geliyor: (1) sayfa geçişinde tüm sahne
/// kayarak değişiyor, (2) her sahnenin İÇİNDE, sürükleme ilerlemesine göre
/// arka plan/orta plan/ön plan öğeleri FARKLI HIZLARDA kayıyor (parallax).
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
    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: SafeArea(
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
                  _RoomPage(
                    sceneIndex: 0,
                    controller: _pageController,
                    eyebrow: context.l10n.onboardingPage1Eyebrow,
                    title: context.l10n.onboardingPage1Title,
                    desc: context.l10n.onboardingPage1Desc,
                    sceneBuilder: (final p) => _LivingRoomScene(parallax: p),
                  ),
                  _RoomPage(
                    sceneIndex: 1,
                    controller: _pageController,
                    eyebrow: context.l10n.onboardingPage2Eyebrow,
                    title: context.l10n.onboardingPage2Title,
                    desc: context.l10n.onboardingPage2Desc,
                    sceneBuilder: (final p) => _DiningCornerScene(parallax: p),
                  ),
                  _RoomPage(
                    sceneIndex: 2,
                    controller: _pageController,
                    eyebrow: context.l10n.onboardingPage3Eyebrow,
                    title: context.l10n.onboardingPage3Title,
                    desc: context.l10n.onboardingPage3Desc,
                    sceneBuilder: (final p) => _ReadingCornerScene(parallax: p),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
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
    );
  }
}

/// Tek bir sayfa: üstte illüstrasyon sahnesi (kendi iç parallax'ıyla),
/// altında eyebrow/başlık/açıklama.
class _RoomPage extends StatelessWidget {
  final int sceneIndex;
  final PageController controller;
  final String eyebrow;
  final String title;
  final String desc;
  final Widget Function(double parallax) sceneBuilder;

  const _RoomPage({
    required this.sceneIndex,
    required this.controller,
    required this.eyebrow,
    required this.title,
    required this.desc,
    required this.sceneBuilder,
  });

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          SizedBox(
            height: 280,
            child: AnimatedBuilder(
              animation: controller,
              builder: (final context, final _) {
                final page =
                    controller.hasClients ? (controller.page ?? sceneIndex.toDouble()) : sceneIndex.toDouble();
                final local = (page - sceneIndex).clamp(-1.0, 1.0);
                return sceneBuilder(local);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eyebrow,
                      style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w800,
                          color: AppColors.mobileAccentDark)),
                  const SizedBox(height: 10),
                  Text(title,
                      style: GoogleFonts.fraunces(
                          fontSize: 27,
                          fontWeight: FontWeight.w600,
                          height: 1.14,
                          color: AppColors.mobileTextPrimary)),
                  const SizedBox(height: 12),
                  Text(desc,
                      style: TextStyle(
                          fontSize: 14, height: 1.5, color: AppColors.mobileTextSecondary)),
                ],
              ),
            ),
          ),
        ],
      );
}

// ════════════════════════════════════════════════════════════
// SAHNELER — her biri sabit boyutlu bir "tuval" üzerinde elle
// kompoze edilmiş, tam opak mobilya şekilleri. FittedBox ile her
// ekran genişliğine güvenle sığdırılıyor (taşma riski yok).
// ════════════════════════════════════════════════════════════

const double _kCanvasW = 340;
const double _kCanvasH = 260;

class _LivingRoomScene extends StatelessWidget {
  final double parallax;
  const _LivingRoomScene({required this.parallax});

  @override
  Widget build(final BuildContext context) => _SceneCanvas(
        parallax: parallax,
        background: [
          _WallArt(left: 40, top: 6, size: 74, color: AppColors.mobileAccent),
          _Window(left: 214, top: 0, width: 96, height: 128),
        ],
        midground: [
          Positioned(left: 30, top: 108, child: _Sofa()),
        ],
        foreground: [
          Positioned(left: 246, top: 128, child: _FloorLamp()),
          Positioned(left: 18, top: 176, child: _Plant(scale: 0.85)),
          Positioned(
              left: 10,
              top: 214,
              child: _Rug(width: 300, color: AppColors.mobileAccentLight)),
        ],
      );
}

class _DiningCornerScene extends StatelessWidget {
  final double parallax;
  const _DiningCornerScene({required this.parallax});

  @override
  Widget build(final BuildContext context) => _SceneCanvas(
        parallax: parallax,
        background: [
          _Window(left: 30, top: 0, width: 110, height: 120),
          _PendantLamp(left: 190, top: 0, height: 90),
        ],
        midground: [
          Positioned(left: 96, top: 128, child: _RoundTable()),
          Positioned(left: 60, top: 160, child: _DiningChair(flip: false)),
          Positioned(left: 232, top: 160, child: _DiningChair(flip: true)),
        ],
        foreground: [
          Positioned(left: 250, top: 96, child: _Plant(scale: 0.7)),
          Positioned(
              left: 6, top: 214, child: _Rug(width: 320, color: AppColors.mobileSecondaryBg)),
        ],
      );
}

class _ReadingCornerScene extends StatelessWidget {
  final double parallax;
  const _ReadingCornerScene({required this.parallax});

  @override
  Widget build(final BuildContext context) => _SceneCanvas(
        parallax: parallax,
        background: [
          _Window(left: 178, top: 0, width: 130, height: 150),
          _Bookshelf(left: 6, top: 10, width: 66, height: 140),
        ],
        midground: [
          Positioned(left: 150, top: 122, child: _ArmChair()),
        ],
        foreground: [
          Positioned(left: 300, top: 130, child: _FloorLamp()),
          Positioned(left: 60, top: 176, child: _Plant(scale: 0.95)),
          Positioned(
              left: 20, top: 214, child: _Rug(width: 280, color: AppColors.mobileAccentLight)),
        ],
      );
}

/// Ortak sahne iskeleti: sabit `_kCanvasW x _kCanvasH` tuvali her ekrana
/// FittedBox ile sığdırır; üç katmanı (arka/orta/ön plan) `parallax`
/// değerine göre farklı hızlarda yatay kaydırır.
class _SceneCanvas extends StatelessWidget {
  final double parallax;
  final List<Widget> background;
  final List<Widget> midground;
  final List<Widget> foreground;

  const _SceneCanvas({
    required this.parallax,
    required this.background,
    required this.midground,
    required this.foreground,
  });

  @override
  Widget build(final BuildContext context) => Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: _kCanvasW,
            height: _kCanvasH,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                color: AppColors.mobileSecondaryBg,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Transform.translate(
                      offset: Offset(parallax * 10, 0),
                      child: Stack(clipBehavior: Clip.none, children: background),
                    ),
                    Transform.translate(
                      offset: Offset(parallax * 24, 0),
                      child: Stack(clipBehavior: Clip.none, children: midground),
                    ),
                    Transform.translate(
                      offset: Offset(parallax * 42, 0),
                      child: Stack(clipBehavior: Clip.none, children: foreground),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

// ════════════════════════════════════════════════════════════
// MOBİLYA PARÇALARI — düz-illüstrasyon dilinde, birden çok
// şekilden elle kompoze edilmiş (tek bir ikon glifi DEĞİL).
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
            // gölge
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
            // koltuk gövdesi
            Positioned(
              left: 0,
              bottom: 6,
              child: Container(
                width: 210,
                height: 62,
                decoration: BoxDecoration(
                  color: AppColors.mobilePrimary,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            // sırt
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
            // kolçaklar
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
            // minderler
            Positioned(left: 34, top: 36, child: _Cushion(color: AppColors.mobileAccent)),
            Positioned(left: 90, top: 36, child: _Cushion(color: AppColors.mobileAccentLight)),
            Positioned(left: 146, top: 36, child: _Cushion(color: AppColors.mobileAccent)),
            // ayaklar
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
  final Color color;

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
            decoration: BoxDecoration(color: color.withOpacity(0.6), shape: BoxShape.circle),
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
  final Color color;

  const _Rug({required this.width, required this.color});

  @override
  Widget build(final BuildContext context) => Container(
        width: width,
        height: 30,
        decoration: BoxDecoration(
          color: color.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.85), width: 2),
        ),
      );
}
