import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';

/// Yönetici panelinin üstündeki özet kartı (Stok / Satıldı / Toplam).
/// Sayı serif ve büyük (panelin "okunan" bilgisi), etiket küçük; solda
/// durumun rengini taşıyan ince bir dikey çizgi — renkli gradyan kutu ve
/// renkli gölge yerine.
class AdminStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const AdminStatCard(
      {super.key,
      required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(final BuildContext context) => Semantics(
        label: '$label: $value',
        child: Container(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.mobileSurface,
            borderRadius: AppRadius.all(AppRadius.md),
            border: Border.all(color: AppColors.mobileBorder),
            boxShadow: AppShadows.level1(AppColors.primary),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadius.all(AppRadius.pill),
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: AppTextStyles.serif(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mobileTextPrimary,
                          height: 1.05,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        Icon(icon, size: 12, color: color),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mobileTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
