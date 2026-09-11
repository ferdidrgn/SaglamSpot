import 'package:flutter/material.dart';
import '../../common/extentions/app_context_ui_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Uygulamanın YENİ, tek ve tutarlı "bölüm başlığı" motifi — eskiden her
/// sayfa kendi başlık stilini (ortalanmış eyebrow+başlık, ya da düz renkli
/// çubuk) icat ediyordu. Artık her yerde AYNI imza: kartlardaki asimetrik
/// köşe dilinin başlıklardaki karşılığı olan, eğik kesilmiş (paralelkenar)
/// bir renk bloğu + solda eyebrow/başlık + sağda opsiyonel "Tümünü Gör"
/// eylemi.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.eyebrow,
    this.color,
    this.onSeeAll,
    this.seeAllLabel,
  });

  final String title;
  final String? eyebrow;
  final Color? color;
  final VoidCallback? onSeeAll;
  final String? seeAllLabel;

  @override
  Widget build(final BuildContext context) {
    final Color accent = color ?? AppColors.accent;
    final double barHeight = context.responsive(mobile: 30.0, desktop: 40.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipPath(
          clipper: const _SkewedBarClipper(),
          child: Container(width: 13, height: barHeight, color: accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (eyebrow != null)
                Text(
                  eyebrow!.toUpperCase(),
                  style: AppTextStyles.microLabel(
                      color: accent, letterSpacing: 2.2, fontSize: 11),
                ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: context.responsive(mobile: 20.0, desktop: 26.0),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(foregroundColor: accent),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(seeAllLabel ?? context.l10n.seeAll,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 15),
              ],
            ),
          ),
      ],
    );
  }
}

class _SkewedBarClipper extends CustomClipper<Path> {
  const _SkewedBarClipper();

  @override
  Path getClip(final Size size) {
    final double skew = size.height * 0.3;
    return Path()
      ..moveTo(skew, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - skew, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant final CustomClipper<Path> oldClipper) => false;
}
