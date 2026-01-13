import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/ad_manager.dart';

class AdsenseBanner extends StatelessWidget {
  final double width;
  final double height;

  const AdsenseBanner({
    super.key,
    this.width = 320,
    this.height = 50,
  });

  @override
  Widget build(final BuildContext context) {
    if (kIsWeb) {
      final adSlot = AdManager().adsenseId();
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: Text(
          "AdSense Banner $adSlot",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return const SizedBox.shrink(); // Mobil ve Desktop
  }
}
