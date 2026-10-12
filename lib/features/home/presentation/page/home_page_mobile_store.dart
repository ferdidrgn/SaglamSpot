import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../../core/widgets/design_system/atelier_components.dart';
import '../../../../core/widgets/design_system/hud_corner_frame.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/google_maps_embed.dart';
import '../../../../core/widgets/whatsapp_quick_fab.dart';
import '../../../../features/products/domain/entites/product.dart';
import '../../../../features/products/presentation/providers/product_filters_provider.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../widgets/home_store_promo_sections.dart';
import '../widgets/home_store_showcase_sections.dart';

/// Mobil ana sayfa — profesyonel vitrin tanıtımları (yatay ürün rayı,
/// koleksiyon bandı, önerilen, sıfır/spot büyük kartlar, kategori çifti)
/// gerçek Firestore ürünleriyle; Keşfet ve ürün kartı dokunulmaz.
class HomeStorePage extends ConsumerWidget {
  const HomeStorePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final available = ref.watch(availableProductsProvider);
    final newDeals = ref.watch(newDealsProductsProvider);
    // Ray: vitrin ürünleri; önerilen: kaydırılmış dilim (aynı bloğu
    // iki kez peş peşe basmamak için).
    final List<Product> rail = available.take(8).toList();
    final List<Product> recommended = available.length > 4
        ? available.skip(2).take(8).toList()
        : available.take(6).toList();
    final Product? promoSpotlight = newDeals.isNotEmpty
        ? newDeals.first
        : (available.isNotEmpty ? available.first : null);

    final scaffold = Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: const MobileBottomNav(),
      floatingActionButton: kIsWeb ? null : const WhatsAppQuickFab(),
      body: AtelierBackground(
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: HomeWelcomeHeader()),
              if (rail.isNotEmpty)
                SliverToBoxAdapter(
                    child: HomeFeaturedProductRail(products: rail)),
              SliverToBoxAdapter(
                child: HomeCollectionPromoBanner(spotlight: promoSpotlight),
              ),
              SliverToBoxAdapter(
                child: AtelierSectionHeader(
                  title: context.l10n.sectionCategories,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl,
                      AppSpacing.section, AppSpacing.xl, AppSpacing.sm),
                ),
              ),
              const SliverToBoxAdapter(child: HomeCategoryChips()),
              if (recommended.isNotEmpty)
                SliverToBoxAdapter(
                  child: HomeRecommendedStrip(products: recommended),
                ),
              const SliverToBoxAdapter(child: HomeTopCollectionPromos()),
              const SliverToBoxAdapter(child: HomeCategoryPromoPair()),
              SliverToBoxAdapter(
                child: AtelierSectionHeader(
                  title: context.l10n.visitUsHeading,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl,
                      AppSpacing.section, AppSpacing.xl, AppSpacing.sm),
                ),
              ),
              const SliverToBoxAdapter(child: _MobileBusinessCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );

    return kIsWeb ? scaffold : HomeExitGuard(child: scaffold);
  }
}

class _MobileBusinessCard extends StatefulWidget {
  const _MobileBusinessCard();

  @override
  State<_MobileBusinessCard> createState() => _MobileBusinessCardState();
}

class _MobileBusinessCardState extends State<_MobileBusinessCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (final _) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isOpen = SaglamSpotCommunication.isOpenNow;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, 0),
      child: HudCornerFrame(
        armLength: 18,
        inset: 10,
        color: AppColors.mobilePrimary,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GoogleMapsEmbed(
                        latitude: SaglamSpotCommunication.placeLatitude,
                        longitude: SaglamSpotCommunication.placeLongitude,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: AppShadows.level1(Colors.black),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isOpen
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFC62828),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isOpen
                                  ? context.l10n.openNowLabel
                                  : context.l10n.closedNowLabel,
                              style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: isOpen
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFC62828)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                color: AppColors.mobileSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 16, color: AppColors.mobilePrimary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(context.l10n.storeAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mobileTextPrimary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                        context.l10n.todayHoursPrefix(
                            SaglamSpotCommunication.todayHoursLabel),
                        style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.mobileTextTertiary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TactilePress(
                            onTap: SaglamSpotCommunication.launchWhatsApp,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.mobilePrimary,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                              ),
                              child: const Center(
                                child: Text('WhatsApp',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TactilePress(
                            onTap: SaglamSpotCommunication.openStoreLocation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                                border:
                                    Border.all(color: AppColors.mobilePrimary),
                              ),
                              child: Center(
                                child: Text(context.l10n.directionsButton,
                                    style: TextStyle(
                                        color: AppColors.mobilePrimary,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
