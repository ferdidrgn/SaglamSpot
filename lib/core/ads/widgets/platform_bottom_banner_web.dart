import 'package:flutter/material.dart';
import '../../common/enum/enums.dart';
import 'adsense_banner.dart';

/// Sayfa altlarına konulan reklam şeridi — web derlemesi: her zaman
/// AdSense.
class PlatformBottomBanner extends StatelessWidget {
  final AdUnitType webType;

  const PlatformBottomBanner({super.key, this.webType = AdUnitType.display});

  @override
  Widget build(final BuildContext context) => AdsenseBanner(type: webType);
}
