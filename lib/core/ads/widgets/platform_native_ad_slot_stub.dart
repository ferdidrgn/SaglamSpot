import 'package:flutter/material.dart';

/// Ne `dart.library.js` ne de `dart.library.io` eşleşmediği durumlarda
/// kullanılan zararsız yedek.
class PlatformNativeAdSlot extends StatelessWidget {
  final double height;

  const PlatformNativeAdSlot({super.key, this.height = 110});

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}
