import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Sayfaların arkasında oturan sade, sakin arka plan katmanı.
///
/// Önceki "blueprint ızgara + gradyan mesh leke + gren dokusu" katmanının
/// (AmbientMeshBackground) yerini alır: sabit (animasyonsuz), tek bir
/// yumuşak radyal geçişten oluşur — okunabilirliği bozmaz, ekstra CPU/GPU
/// maliyeti neredeyse hiç yoktur. Dokunuşları asla yakalamaz.
class SoftPageBackdrop extends StatelessWidget {
  const SoftPageBackdrop({super.key, this.tint});

  /// Verilmezse marka rengiyle (AppColors.accent) sıcak bir hava verir.
  final Color? tint;

  @override
  Widget build(final BuildContext context) {
    final base = AppColors.background;
    final glow = (tint ?? AppColors.accent).withOpacity(
      Theme.of(context).brightness == Brightness.dark ? 0.10 : 0.07,
    );

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.9),
            radius: 1.35,
            colors: [glow, base],
            stops: const [0.0, 0.75],
          ),
        ),
      ),
    );
  }
}
