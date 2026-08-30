import 'package:flutter/material.dart';
import '../../common/enum/enums.dart';

/// Ne `dart.library.js` ne de `dart.library.io` eşleşmediği durumlarda
/// kullanılan zararsız yedek.
class PlatformBottomBanner extends StatelessWidget {
  final AdUnitType webType;

  const PlatformBottomBanner({super.key, this.webType = AdUnitType.display});

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}
