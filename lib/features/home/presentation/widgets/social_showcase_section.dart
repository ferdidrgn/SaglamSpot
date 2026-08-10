import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Referans tasarımdaki "Share your setup" fotoğraf duvarının karşılığı:
/// başlıksız, farklı yükseklikte bir mozaik ızgara. Harici paket olmadan,
/// sabit yükseklikli sütunlarla "masonry" hissi verir.
class SocialShowcaseSection extends StatelessWidget {
  const SocialShowcaseSection({super.key});

  static const List<String> _photos = [
    'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=600',
    'https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=600',
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=600',
    'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?q=80&w=600',
    'https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=600',
    'https://images.unsplash.com/photo-1556912178-8f4df6d97a33?q=80&w=600',
    'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?q=80&w=600',
    'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?q=80&w=600',
  ];

  // Her sütun için görsel index'i + göreli yükseklik (masonry hissi).
  static const List<List<double>> _columnPattern = [
    [0, 190, 3, 240],
    [1, 240, 4, 190],
    [2, 190, 5, 240],
    [6, 240, 7, 190],
  ];

  @override
  Widget build(final BuildContext context) {
    final columns = context.isMobile ? 2 : 4;

    return SliverPadding(
      padding: context.pagePadding.copyWith(
          top: context.spacingLarge, bottom: context.spacingLarge * 2),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Text('PAYLAŞIN',
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    fontSize: context.captionSize)),
            const SizedBox(height: 8),
            Text('#SağlamSpot ile Kurulumunuzu Paylaşın',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int c = 0; c < columns; c++) ...[
                  if (c > 0) const SizedBox(width: 12),
                  Expanded(child: _buildColumn(c)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(final int columnIndex) {
    final pattern = _columnPattern[columnIndex % _columnPattern.length];
    return Column(
      children: [
        for (int i = 0; i < pattern.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: pattern[i + 1],
              width: double.infinity,
              child: Image.network(
                _photos[pattern[i].toInt()],
                fit: BoxFit.cover,
                errorBuilder: (final c, final e, final s) =>
                    Container(color: AppColors.secondary),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
