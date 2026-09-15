import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// "Ev içi tanıtım" — sadece ilk açılışta, native mobilde gösterilir (bkz.
/// app_router.dart initialLocation + OnboardingCache). YEDİNCİ SÜRÜM:
/// bir önceki (asimetrik köşeli, geniş boşluklu "editoryal poster") sürüm
/// "boş/iğrenç" bulundu. Bu sefer kullanıcının paylaştığı referanstaki
/// (Mobileri Rexhepi) YOĞUN, dolu-dizgin tek ekran dili: üstte büyük,
/// tam genişlik gerçek fotoğraf + marka rozeti, hemen altında fotoğrafın
/// üstüne binen, doldurulmuş bir içerik kartı — başlık, açıklama, ÜÇ
/// gerçek güven rozeti (esnaf tecrübesi/onaylı satıcı/yerinde teslim gibi
/// — uydurma değil, uygulamanın başka yerlerinde de kullanılan gerçek
/// metinler), sayfa noktaları ve büyük bir CTA butonu. Ekranda boş alan
/// bırakmayan, tamamen dolu bir kompozisyon.
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
    final pages = [
      (
        context.l10n.onboardingPage1Eyebrow,
        context.l10n.onboardingPage1Title,
        context.l10n.onboardingPage1Desc,
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=85',
        [
          (Icons.workspace_premium_rounded, context.l10n.usp1Title),
          (Icons.verified_rounded, context.l10n.productTrustBadgeVerified),
          (Icons.local_shipping_rounded, context.l10n.productTrustBadgeDelivery),
        ],
      ),
      (
        context.l10n.onboardingPage2Eyebrow,
        context.l10n.onboardingPage2Title,
        context.l10n.onboardingPage2Desc,
        'https://images.unsplash.com/photo-1530018607912-eff2daa1bac4?auto=format&fit=crop&w=1200&q=85',
        [
          (Icons.chair_rounded, context.l10n.conditionNew),
          (Icons.local_offer_rounded, context.l10n.conditionUsed),
          (Icons.category_rounded, context.l10n.onboardingCategoriesChip),
        ],
      ),
      (
        context.l10n.onboardingPage3Eyebrow,
        context.l10n.onboardingPage3Title,
        context.l10n.onboardingPage3Desc,
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=1200&q=85',
        [
          (Icons.chat_bubble_rounded, context.l10n.productTrustBadgeNegotiate),
          (Icons.handshake_rounded, context.l10n.onboardingBargainChip),
          (Icons.bolt_rounded, context.l10n.onboardingFastReplyChip),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: _pageCount,
        itemBuilder: (final context, final index) {
          final (eyebrow, title, desc, imageUrl, chips) = pages[index];
          return _OnboardingPage(
            eyebrow: eyebrow,
            title: title,
            desc: desc,
            imageUrl: imageUrl,
            chips: chips,
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

/// Tek bir sayfa: üstte büyük gerçek fotoğraf + marka rozeti, altında
/// fotoğrafın üstüne binen dolu bir içerik kartı (başlık + açıklama + 3
/// güven rozeti + sayfa noktaları + CTA). Ekranda boşluk bırakmayan,
/// referanstaki "Mobileri Rexhepi" showroom ekranıyla aynı yoğunlukta.
class _OnboardingPage extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String desc;
  final String imageUrl;
  final List<(IconData, String)> chips;
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
    required this.chips,
    required this.pageIndex,
    required this.pageCount,
    required this.isLast,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          // ── Üst fotoğraf bloğu ──
          Expanded(
            flex: 5,
            child: Stack(
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
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.mobilePrimaryDark.withOpacity(0.55),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5],
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 16, 0),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.storefront_rounded,
                                  size: 14, color: AppColors.mobilePrimaryDark),
                              const SizedBox(width: 6),
                              Text(
                                eyebrow,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                  color: AppColors.mobilePrimaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: onSkip,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.24),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                          ),
                          child: Text(context.l10n.onboardingSkip,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Dolu içerik kartı — fotoğrafın üstüne biner ──
          Expanded(
            flex: 6,
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(26, 26, 26, 18),
                decoration: BoxDecoration(
                  color: AppColors.mobileBackground,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.fraunces(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        color: AppColors.mobileTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: TextStyle(
                          fontSize: 13.5, height: 1.45, color: AppColors.mobileTextSecondary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        for (int i = 0; i < chips.length; i++) ...[
                          if (i != 0) const SizedBox(width: 8),
                          Expanded(child: _TrustChip(icon: chips[i].$1, label: chips[i].$2)),
                        ],
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(pageCount, (final i) {
                        final selected = i == pageIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: selected ? 24 : 7,
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
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mobilePrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: isLast
                            ? Text(context.l10n.onboardingStart,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 15))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(context.l10n.onboardingNext,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800, fontSize: 15)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_rounded, size: 19),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

/// Küçük, ikonlu güven rozeti — onboarding kartındaki 3'lü sırada.
class _TrustChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustChip({required this.icon, required this.label});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.mobileAccent.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.mobileAccentDark),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: AppColors.mobileTextSecondary,
              ),
            ),
          ],
        ),
      );
}
