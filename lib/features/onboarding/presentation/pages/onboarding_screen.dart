import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// "Ev içi tanıtım" — sadece ilk açılışta, native mobilde gösterilir (bkz.
/// app_router.dart initialLocation + OnboardingCache). SEKİZİNCİ SÜRÜM:
/// kullanıcının paylaştığı referansa ("Sitora") BİREBİR göre — tam ekran,
/// DİKEY formatlı gerçek fotoğraf, markanın kendi renginde tek-tonlu bir
/// renk grafiği (ColorFiltered, BlendMode.color) ile boyanmış, üstte küçük
/// logo rozeti + "Hoş Geldiniz" satırı, ortada büyük başlık + kısa
/// açıklama, altta yüzen beyaz "Başla" hapı. Önceki iki sürüm (soyut
/// dekoratif öğeler / bölünmüş fotoğraf+kart) reddedildi — bu sürüm hiçbir
/// ekstra süsleme eklemiyor, sadece referanstaki net, tek fotoğraflı dili
/// birebir uyguluyor.
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
        duration: const Duration(milliseconds: 550), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(final BuildContext context) {
    // Dikey (portre) kadraj için Unsplash'e h= parametresiyle 9:16'ya
    // yakın bir kırpma isteniyor — tam ekran fotoğraf hiçbir zaman yatay
    // görünmesin diye.
    final pages = [
      (
        context.l10n.onboardingPage1Eyebrow,
        context.l10n.onboardingPage1Title,
        context.l10n.onboardingPage1Desc,
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=900&h=1600&q=85',
      ),
      (
        context.l10n.onboardingPage2Eyebrow,
        context.l10n.onboardingPage2Title,
        context.l10n.onboardingPage2Desc,
        'https://images.unsplash.com/photo-1530018607912-eff2daa1bac4?auto=format&fit=crop&w=900&h=1600&q=85',
      ),
      (
        context.l10n.onboardingPage3Eyebrow,
        context.l10n.onboardingPage3Title,
        context.l10n.onboardingPage3Desc,
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=900&h=1600&q=85',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.mobilePrimaryDark,
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: _pageCount,
        itemBuilder: (final context, final index) {
          final (eyebrow, title, desc, imageUrl) = pages[index];
          return _OnboardingPage(
            eyebrow: eyebrow,
            title: title,
            desc: desc,
            imageUrl: imageUrl,
            pageIndex: _pageIndex,
            pageCount: _pageCount,
            isLast: _pageIndex == _pageCount - 1,
            onSkip: () => _finish(context),
            onNext: _next,
          );
        },
      ),
    );
  }
}

/// Tek bir sayfa — referanstaki gibi TAM EKRAN dikey fotoğraf, markanın
/// rengiyle tek-tonlu boyanmış (ColorFiltered), üstte logo+eyebrow, ortada
/// büyük başlık+açıklama, altta yüzen beyaz CTA hapı + sayfa noktaları.
class _OnboardingPage extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String desc;
  final String imageUrl;
  final int pageIndex;
  final int pageCount;
  final bool isLast;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const _OnboardingPage({
    required this.eyebrow,
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.pageIndex,
    required this.pageCount,
    required this.isLast,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(final BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          // Tam ekran fotoğraf — markanın aksan rengiyle tek-tonlu boyanmış
          // (referanstaki turuncu "duoton" grafik efektinin karşılığı).
          ColorFiltered(
            colorFilter: ColorFilter.mode(AppColors.mobileAccent, BlendMode.color),
            child: OptimizedCachedImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              borderRadius: 0,
              errorBuilder: (final c, final u, final e) => DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.mobilePrimaryGradient),
              ),
            ),
          ),
          // Okunurluk için üstten ve alttan hafif karartma.
          const Positioned.fill(
            child: IgnorePointer(child: _EdgeScrim()),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/saglam_spot_logo_mark.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: onSkip,
                        child: Text(context.l10n.onboardingSkip,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    eyebrow,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(flex: 3),
                  Text(
                    title,
                    style: GoogleFonts.fraunces(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      height: 1.06,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(flex: 4),
                  Row(
                    children: [
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: onNext,
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(24, 15, 18, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isLast
                                      ? context.l10n.onboardingStart
                                      : context.l10n.onboardingNext,
                                  style: TextStyle(
                                    color: AppColors.mobilePrimaryDark,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.5,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded,
                                    size: 18, color: AppColors.mobilePrimaryDark),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(pageCount, (final i) {
                          final selected = i == pageIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.only(left: 5),
                            width: selected ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(selected ? 0.95 : 0.4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class _EdgeScrim extends StatelessWidget {
  const _EdgeScrim();

  @override
  Widget build(final BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.38),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.55),
            ],
            stops: const [0.0, 0.28, 0.55, 1.0],
          ),
        ),
      );
}
