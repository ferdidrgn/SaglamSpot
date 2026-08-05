import 'package:flutter/material.dart';

/// Mobil (Android/iOS) derlemesinde AdSense kullanılmaz — reklamlar
/// AdManager üzerinden AdMob ile yönetilir. Bu yüzden burada boş widget döner.
class RealAdsenseAd extends StatelessWidget {
  final String slotId;
  final String format;
  final String? layout;
  final double height;
  final bool fullWidthResponsive;

  const RealAdsenseAd({
    super.key,
    required this.slotId,
    this.format = 'auto',
    this.layout,
    this.height = 280,
    this.fullWidthResponsive = true,
  });

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}
