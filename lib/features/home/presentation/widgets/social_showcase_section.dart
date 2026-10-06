import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Referans tasarımdaki "Share your setup" fotoğraf duvarının karşılığı:
/// eşit boy sütunlar DEĞİL, gerçek bir bento/mozaik ızgara. Referans
/// görseldeki asimetrik ritmi birebir yakalayan 6 sütunluk bir hücre planı
/// kullanılıyor: solda üst-alt ikili sütunlar, ortada boydan boya tek bir
/// "vitrin" fotoğraf, sağında geniş+uzun bir çift ve en sağda dar-uzun bir
/// aksan sütunu (harici paket yok).
class SocialShowcaseSection extends StatelessWidget {
  /// Dükkândaki gerçek ürün fotoğrafları. Dörtten azsa bölüm gizlenir;
  /// stok görselle doldurulmaz.
  final List<String> photos;

  const SocialShowcaseSection({super.key, required this.photos});

  List<String> get _frames =>
      [for (var i = 0; i < 9; i++) photos[i % photos.length]];

  // (col, row, colSpan, rowSpan, photoIndex) — 6 sütun x 6 satırlık bir
  // hücre planı, boşluk kalmadan 9 karo ile dolduruluyor. Referans
  // görseldeki yerleşimin birebir karşılığı: iki dar sütun üst/alt ikili,
  // ortada boydan boya bir "vitrin" karo, sağda geniş+uzun bir çift ve en
  // sağda dar-uzun bir aksan sütunu.
  static const List<List<int>> _tiles = [
    [0, 0, 1, 3, 0], // raf — sol üst
    [0, 3, 1, 3, 1], // koltuk — sol alt
    [1, 0, 1, 3, 2], // çalışma masası — üst
    [1, 3, 1, 3, 3], // sehpa/vazo — alt
    [2, 0, 1, 6, 4], // yemek odası — boydan boya vitrin
    [3, 0, 2, 4, 5], // yatak odası — geniş, üst
    [3, 4, 1, 2, 6], // çerçeve/dekor — alt sol
    [4, 4, 1, 2, 7], // mutfak rafı — alt sağ
    [5, 0, 1, 6, 8], // tuğla duvar — boydan boya aksan
  ];

  @override
  Widget build(final BuildContext context) {
    if (photos.length < 4) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final frames = _frames;
    return SliverPadding(
      padding: context.pagePadding.copyWith(
          top: context.spacingLarge * 0.6, bottom: context.spacingLarge),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Text(context.l10n.socialShowcaseEyebrow,
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    fontSize: context.captionSize)),
            const SizedBox(height: 8),
            Text(context.l10n.socialShowcaseHeading,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 28),
            if (context.isMobile)
              _buildMobileMasonry(context, frames)
            else
              _buildBentoGrid(context, frames),
          ],
        ),
      ),
    );
  }

  // Masaüstü/tablet: 6 sütunluk gerçek bento — büyük/küçük/geniş/uzun
  // karışık, boşluksuz, referans görseldeki asimetrik ritimle.
  Widget _buildBentoGrid(final BuildContext context, final List<String> frames) {
    const spacing = 12.0;
    final rowUnit =
        context.responsive(mobile: 60.0, tablet: 66.0, desktop: 76.0);

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final colWidth = (constraints.maxWidth - 5 * spacing) / 6;
        final totalHeight = 6 * rowUnit + 5 * spacing;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              for (final tile in _tiles)
                Positioned(
                  left: tile[0] * (colWidth + spacing),
                  top: tile[1] * (rowUnit + spacing),
                  width: tile[2] * colWidth + (tile[2] - 1) * spacing,
                  height: tile[3] * rowUnit + (tile[3] - 1) * spacing,
                  child: _PhotoTile(url: frames[tile[4]]),
                ),
            ],
          ),
        );
      },
    );
  }

  // Mobil: dar ekranda karmaşık bento yerine, tüm 9 fotoğrafı kullanan
  // eşit olmayan iki sütunlu bir masonry — dolu ama sade.
  Widget _buildMobileMasonry(
      final BuildContext context, final List<String> frames) {
    const leftHeights = [190.0, 130.0, 170.0, 150.0, 200.0];
    const leftPhotos = [0, 2, 4, 6, 8];
    const rightHeights = [140.0, 220.0, 150.0, 180.0];
    const rightPhotos = [1, 3, 5, 7];

    Widget column(final List<int> indexes, final List<double> heights) =>
        Column(
          children: [
            for (int i = 0; i < indexes.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _PhotoTile(url: frames[indexes[i]], height: heights[i]),
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
