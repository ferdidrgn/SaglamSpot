import 'package:flutter/material.dart';
import '../../common/enum/enums.dart';
import 'ad_banner_widget.dart';

/// Sayfa altlarına konulan reklam şeridi — mobil (io) derlemesi: her
/// zaman AdMob banner.
class PlatformBottomBanner extends StatelessWidget {
  final AdUnitType webType;

  const PlatformBottomBanner({super.key, this.webType = AdUnitType.display});

  @override
  Widget build(final BuildContext context) =>
      const Center(child: AdBannerWidget());
}
