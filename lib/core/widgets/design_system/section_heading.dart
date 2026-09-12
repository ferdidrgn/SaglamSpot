import 'package:flutter/material.dart';
import '../../common/extentions/app_context_ui_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Uygulamanın tek ve tutarlı "bölüm başlığı" motifi — sade, sıcak/krem
/// referans vitrine uygun: küçük eyebrow + serif başlık, sağda opsiyonel
/// "Tümünü Gör" bağlantısı. Kalın renkli grafik öğe YOK — sakin, bol
/// boşluklu bir his hedefleniyor.
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
                  fontSize: context.responsive(mobile: 19.0, desktop: 25.0),
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
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 15),
              ],
            ),
          ),
      ],
    );
  }
}
