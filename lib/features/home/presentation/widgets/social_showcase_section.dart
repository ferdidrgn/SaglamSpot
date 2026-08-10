import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Referans tasarımdaki "Share your setup" fotoğraf duvarının karşılığı:
/// eşit boy sütunlar DEĞİL, gerçek bir bento/mozaik ızgara — bazı kareler
/// büyük, bazıları küçük, bazıları geniş. 4x4'lük bir hücre planı üzerine
/// 9 farklı boyutta karo yerleştirilerek elde edilir (harici paket yok).
class SocialShowcaseSection extends StatelessWidget {
  const SocialShowcaseSection({super.key});

  static const List<String> _photos = [
    'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=600', // A
    'https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=600', // B
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=600', // C
    'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?q=80&w=900', // D (büyük, orta)
    'https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=800', // E (geniş)
    'https://images.unsplash.com/photo-1556912178-8f4df6d97a33?q=80&w=600', // F
    'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?q=80&w=800', // G
    'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?q=80&w=800', // H
    'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?q=80&w=600', // I
  ];

  // (col, row, colSpan, rowSpan, photoIndex) — 4 sütun x 4 satırlık bir
  // hücre planı, boşluk kalmadan 9 farklı boyutta karo ile dolduruluyor.
  static const List<List<int>> _tiles = [
    [0, 0, 1, 2, 0], // A: uzun, sol üst
    [1, 0, 1, 1, 1], // B: küçük
    [1, 1, 1, 1, 2], // C: küçük
    [2, 0, 2, 2, 3], // D: büyük kare, orta (öne çıkan)
    [0, 2, 2, 1, 4], // E: geniş, alt sol
    [2, 2, 1, 2, 5], // F: uzun, sağ orta
    [3, 2, 1, 1, 6], // G: küçük
    [0, 3, 2, 1, 7], // H: geniş, alt
    [3, 3, 1, 1, 8], // I: küçük
  ];

  @override
  Widget build(final BuildContext context) {
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
            context.isMobile ? _buildMobileMasonry(context) : _buildBentoGrid(context),
          ],
        ),
      ),
    );
  }

  // Masaüstü/tablet: gerçek bento — büyük/küçük/geniş karışık, boşluksuz.
  Widget _buildBentoGrid(final BuildContext context) {
    const spacing = 12.0;
    final rowHeight = context.responsive(mobile: 120.0, tablet: 130.0, desktop: 148.0);

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final colWidth = (constraints.maxWidth - 3 * spacing) / 4;
        final totalHeight = 4 * rowHeight + 3 * spacing;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              for (final tile in _tiles)
                Positioned(
                  left: tile[0] * (colWidth + spacing),
                  top: tile[1] * (rowHeight + spacing),
                  width: tile[2] * colWidth + (tile[2] - 1) * spacing,
                  height: tile[3] * rowHeight + (tile[3] - 1) * spacing,
                  child: _PhotoTile(url: _photos[tile[4]]),
                ),
            ],
          ),
        );
      },
    );
  }

  // Mobil: dar ekranda karmaşık bento yerine, hâlâ eşit olmayan iki
  // sütunlu bir masonry — sade ama tekdüze değil.
  Widget _buildMobileMasonry(final BuildContext context) {
    const leftHeights = [190.0, 130.0, 210.0];
    const leftPhotos = [0, 3, 6];
    const rightHeights = [140.0, 220.0, 150.0];
    const rightPhotos = [1, 4, 7];

    Widget column(final List<int> photos, final List<double> heights) => Column(
          children: [
            for (int i = 0; i < photos.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _PhotoTile(url: _photos[photos[i]], height: heights[i]),
            ],
          ],
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: column(leftPhotos, leftHeights)),
        const SizedBox(width: 10),
        Expanded(child: column(rightPhotos, rightHeights)),
      ],
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String url;
  final double? height;

  const _PhotoTile({required this.url, this.height});

  @override
  Widget build(final BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (final c, final e, final s) =>
                Container(color: AppColors.secondary),
          ),
        ),
      );
}
