import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/onboarding_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';

/// "Ev içi tanıtım" — sadece ilk açılışta, native mobilde gösterilir (bkz.
/// app_router.dart initialLocation + OnboardingCache). ÜÇÜNCÜ VE KÖKLÜ
/// SÜRÜM: önceki iki deneme (soluk ikonlar, sonra elle çizilmiş mobilya
/// silüetleri) yetersiz kaldı. Artık illüstrasyon YOK — gerçek katalogdaki
/// GERÇEK ürün fotoğrafları tam ekran arka plan olarak kullanılıyor
/// (availableProductsProvider'dan canlı çekiliyor), üzerine koyu bir
/// gradyan ve metin biniyor; hafif bir "Ken Burns" yakınlaşma animasyonu
/// sinematik/derinlik hissi katıyor. İçerik artık jenerik değil,
/// markanın gerçek konumlandırmasını (esnaf güvencesi, spot+sıfır
/// çeşitliliği, doğrudan iletişim) yansıtan ticari metinlerle yazıldı.
class HouseWalkthroughOnboardingScreen extends ConsumerStatefulWidget {
  const HouseWalkthroughOnboardingScreen({super.key});

  @override
  ConsumerState<HouseWalkthroughOnboardingScreen> createState() =>
      _HouseWalkthroughOnboardingScreenState();
}

class _HouseWalkthroughOnboardingScreenState
    extends ConsumerState<HouseWalkthroughOnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  static const int _pageCount = 3;

  late final AnimationController _kenBurnsController =
      AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat(reverse: true);
  late final Animation<double> _kenBurns = Tween<double>(begin: 1.0, end: 1.12)
      .animate(CurvedAnimation(parent: _kenBurnsController, curve: Curves.easeInOut));

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
    _kenBurnsController.dispose();
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

  /// Katalogdan, mümkün olduğunca FARKLI kategorilerden, gerçek fotoğrafı
  /// olan ürünler seçer — vitrinin çeşitliliğini yansıtsın diye. Kategori
  /// çeşitliliği tükenirse kalan slotlar herhangi bir görselli ürünle
  /// doldurulur; hiç ürün/görsel yoksa (ör. henüz yeni kurulan bir mağaza)
  /// boş liste döner ve arayüz marka gradyanına güvenle geri düşer.
  List<Product> _pickHeroProducts(final List<Product> products) {
    final withImages = products.where((final p) => p.imagesUrl.isNotEmpty).toList();
    if (withImages.isEmpty) return const [];

    final seenCategories = <ProductCategory>{};
    final picked = <Product>[];
    for (final p in withImages) {
      if (picked.length >= _pageCount) break;
      if (seenCategories.add(p.category)) picked.add(p);
    }
    for (final p in withImages) {
      if (picked.length >= _pageCount) break;
      if (!picked.contains(p)) picked.add(p);
    }
    return picked;
  }

  @override
  Widget build(final BuildContext context) {
    final products = ref.watch(availableProductsProvider);
    final heroProducts = _pickHeroProducts(products);
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

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: _pageCount,
            itemBuilder: (final context, final index) {
              final imageUrl = heroProducts.isEmpty
                  ? null
                  : heroProducts[index % heroProducts.length].imagesUrl.first;
              final (eyebrow, title, desc) = copy[index];
              return _FullBleedSlide(
                imageUrl: imageUrl,
                kenBurns: _kenBurns,
                eyebrow: eyebrow,
                title: title,
                desc: desc,
              );
            },
          ),

          // Sabit üst-alt kontrol katmanı — sayfa değişse de yerinde kalır.
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
                        backgroundColor: Colors.black.withOpacity(0.28),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(context.l10n.onboardingSkip,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
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
                              color: selected ? Colors.white : Colors.white.withOpacity(0.4),
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

/// Tek bir tam ekran sahne: gerçek ürün fotoğrafı (Ken Burns yakınlaşmalı)
/// + okunabilirlik için koyu gradyan + metin İÇERİĞİN ÜSTÜNDE.
class _FullBleedSlide extends StatelessWidget {
  final String? imageUrl;
  final Animation<double> kenBurns;
  final String eyebrow;
  final String title;
  final String desc;

  const _FullBleedSlide({
    required this.imageUrl,
    required this.kenBurns,
    required this.eyebrow,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(final BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: AnimatedBuilder(
              animation: kenBurns,
              builder: (final context, final child) =>
                  Transform.scale(scale: kenBurns.value, child: child),
              child: imageUrl != null
                  ? OptimizedCachedImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 0,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.mobilePrimaryDark, AppColors.mobilePrimary],
                        ),
                      ),
                    ),
            ),
          ),
          // Okunabilirlik gradyanı — üstte (Atla butonu için) ve altta
          // (metin/CTA için) daha koyu, ortada şeffaf.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xB3000000),
                  Color(0x00000000),
                  Color(0x00000000),
                  Color(0xE6000000),
                ],
                stops: [0.0, 0.22, 0.42, 1.0],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 160),
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
                      color: AppColors.mobileAccentLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: GoogleFonts.fraunces(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
