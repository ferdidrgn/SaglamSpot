import 'package:flutter/material.dart';
import 'ad_native_widget.dart';

/// Mobil (io) derlemesi: her zaman AdMob native reklam.
class PlatformNativeAdSlot extends StatelessWidget {
  final double height;

  const PlatformNativeAdSlot({super.key, this.height = 110});

  @override
  Widget build(final BuildContext context) => AdNativeWidget(height: height);
}
