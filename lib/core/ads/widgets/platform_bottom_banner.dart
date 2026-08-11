import 'package:flutter/material.dart';
import '../../common/enum/enums.dart';
import '../../util/platform_checker.dart';
import 'ad_banner_widget.dart';
import 'adsense_banner.dart';

/// Sayfa altlarına konulan reklam şeridi — web'de AdSense, mobil
/// uygulamada AdMob banner. Tek widget'la her iki platform da doğru
/// reklam türünü gösterir; yanlış platformda hiçbir şey render etmez
/// (AdsenseBanner zaten !kIsWeb'de, AdBannerWidget de mobil dışında
/// anlamsız olurdu).
class PlatformBottomBanner extends StatelessWidget {
  final AdUnitType webType;

  const PlatformBottomBanner({super.key, this.webType = AdUnitType.display});

  @override
  Widget build(final BuildContext context) {
    if (PlatformChecker.isWeb) {
      return AdsenseBanner(type: webType);
    }
    return const Center(child: AdBannerWidget());
  }
}
