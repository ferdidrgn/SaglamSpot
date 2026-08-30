import 'package:flutter/material.dart';

/// Ne `dart.library.js` ne de `dart.library.io` eşleşmediği (örn. VM
/// testleri) durumlarda kullanılan zararsız yedek — hiçbir reklam paketine
/// dokunmaz.
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({super.key});

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}
