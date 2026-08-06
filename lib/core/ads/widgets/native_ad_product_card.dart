import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../common/enum/enums.dart';
import '../../common/extentions/app_context_ui_extension.dart';
import '../../theme/app_colors.dart';
import '../ads_manager.dart';

/// Ürün ızgarasına (grid) gömülen, ürün kartlarıyla AYNI dış görünüme
/// (yuvarlak köşe, gölge) sahip AdMob native reklam kartı. "Sponsorlu"
/// etiketi ile şeffaf — Google'ın reklam ifşa politikasına uygun.
class NativeAdProductCard extends StatefulWidget {
  const NativeAdProductCard({super.key});

  @override
  State<NativeAdProductCard> createState() => _NativeAdProductCardState();
}

class _NativeAdProductCardState extends State<NativeAdProductCard> {
  NativeAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _load();
  }

  void _load() => _ad = NativeAd(
        adUnitId: AdManager.getAdUnitId(AdUnitType.native),
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (final _) => setState(() => _loaded = true),
          onAdFailedToLoad: (final ad, final error) => ad.dispose(),
        ),
        // 'medium' şablonu dikey bir kart şeklinde render eder — ürün
        // kartlarının bulunduğu grid hücresine görsel olarak uyar.
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.medium,
          cornerRadius: 24,
          mainBackgroundColor: AppColors.card,
        ),
      )..load();

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (kIsWeb || !_loaded || _ad == null) return const SizedBox.shrink();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(child: AdWidget(ad: _ad!)),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(context.l10n.sponsored,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
