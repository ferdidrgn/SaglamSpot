import 'package:flutter/material.dart';

/// Web derlemesi: bu yuvada başka bir gerçek reklam birimi (AdSense)
/// zaten gösteriliyor — boş widget döner.
class PlatformNativeAdSlot extends StatelessWidget {
  final double height;

  const PlatformNativeAdSlot({super.key, this.height = 110});

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}
