import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// "Ev içi tanıtım" — sadece ilk açılışta, native mobilde gösterilir (bkz.
/// app_router.dart initialLocation + OnboardingCache). DOKUZUNCU SÜRÜM:
/// kullanıcı metin/renk/şekli en beğendiği hale (ilk fotoğraflı sürüm —
/// alt kenara yaslı eyebrow + büyük Fraunces başlık + açıklama, marka
/// renginde alttan karartma, tam genişlik CTA) GERİ DÖNDÜRDÜ; tek istek
/// fotoğrafların TAMAMEN değişmesiydi — bu yüzden üç sayfanın da fotoğrafı
/// daha önce hiç kullanılmamış, farklı gerçek mobilya/iç mekan fotoğraflarıyla
/// değiştirildi (dikey/portre kırpma korunuyor).
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

  /// Sayfa yerleşince metnin oynadığı "pop" — sayfa her değiştiğinde
  /// baştan oynatılır.
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
    // Fotoğraflar baştan aşağı yenilendi (önceki üç sürümde hep aynı
    // koltuk/masa/sandalye fotoğrafları kullanılmıştı) — dikey/portre
    // kırpma (h= parametresi) korunuyor.
    final pages = [
      (
        context.l10n.onboardingPage1Eyebrow,
        context.l10n.onboardingPage1Title,
        context.l10n.onboardingPage1Desc,
        // Sıcak, davetkâr yatak odası sahnesi.
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&h=1600&q=85',
      ),
      (
        context.l10n.onboardingPage2Eyebrow,
        context.l10n.onboardingPage2Title,
        context.l10n.onboardingPage2Desc,
        // Dolap/depolama — "her bütçeye uygun çeşitlilik" hissi.
        'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=900&h=1600&q=85',
      ),
      (
        context.l10n.onboardingPage3Eyebrow,
        context.l10n.onboardingPage3Title,
        context.l10n.onboardingPage3Desc,
        // Sıcak aydınlatma — "hemen yazın, konuşalım" davetkâr atmosferi.
        'https://images.unsplash.com/photo-1540932239986-30128078f3c5?auto=format&fit=crop&w=900&h=1600&q=85',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.mobilePrimaryDark,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: _pageCount,
            itemBuilder: (final context, final index) {
              final (eyebrow, title, desc, imageUrl) = pages[index];
              return AnimatedBuilder(
                animation: _revealController,
                builder: (final context, final _) => _OnboardingPage(
                  imageUrl: imageUrl,
                  reveal: Curves.easeOutCubic.transform(_revealController.value),
                  eyebrow: eyebrow,
                  title: title,
                  desc: desc,
                ),
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
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.22),
                        shape: const StadiumBorder(),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(context.l10n.onboardingSkip,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5)),
                    ),
                  ),
                ),
                const Spacer(),
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
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mobileAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: _pageIndex == _pageCount - 1
                              ? Text(context.l10n.onboardingStart,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800, fontSize: 15.5))
                              : const Icon(Icons.arrow_forward_rounded, size: 22),
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

/// Tek bir sayfa: tam ekran gerçek fotoğraf + marka renginde alttan yukarı
/// karartma + üstüne oturan eyebrow/başlık/açıklama (alt kenara yaslı).
/// Kullanıcının "en güzeliydi" dediği, ilk fotoğraflı sürümün metin/renk/
/// şekli — değişen tek şey fotoğrafların kendisi.
class _OnboardingPage extends StatelessWidget {
  final String imageUrl;
  final double reveal;
  final String eyebrow;
  final String title;
  final String desc;

  const _OnboardingPage({
    required this.imageUrl,
    required this.reveal,
    required this.eyebrow,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(final BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          OptimizedCachedImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            borderRadius: 0,
            errorBuilder: (final c, final u, final e) => DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.mobilePrimaryGradient),
            ),
          ),
          // Marka renginde (sabit siyah değil), alttan yukarı güçlü karartma.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.mobilePrimaryDark.withOpacity(0.92),
                  AppColors.mobilePrimaryDark.withOpacity(0.55),
                  AppColors.mobilePrimaryDark.withOpacity(0.05),
                ],
                stops: const [0.0, 0.45, 0.78],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 168),
              child: Opacity(
                opacity: reveal.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, (1 - reveal) * 16),
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
                          color: AppColors.mobileAccentLight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: GoogleFonts.fraunces(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        desc,
                        style: const TextStyle(
                            fontSize: 14, height: 1.5, color: Colors.white70),
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
