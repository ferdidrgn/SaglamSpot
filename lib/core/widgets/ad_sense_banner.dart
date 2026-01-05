import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Web'de AdSense göstermek için placeholder.
/// Mobil ve Desktop'ta boş gösterir.
class AdsenseBanner extends StatelessWidget {
  final String? adSlot;
  final double height;

  const AdsenseBanner({
    super.key,
    this.adSlot,
    this.height = 90,
  });

  @override
  Widget build(final BuildContext context) {
    if (kIsWeb)
      // Web için placeholder
      return Container(
        height: height,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: Text(
          "AdSense Banner ${adSlot ?? ''}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

    // Mobil ve Desktop boş
    return const SizedBox.shrink();
  }
}
