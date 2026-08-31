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
  const SocialShowcaseSection({super.key});

  static const List<String> _photos = [
    'https://images.unsplash.com/photo-1594026112284-02bb6f3352fe?q=80&w=700', // 0 raf
    'https://images.unsplash.com/photo-1506439773649-6e0eb8cfb237?q=80&w=700', // 1 koltuk
    'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?q=80&w=700', // 2 çalışma masası
    'https://images.unsplash.com/photo-1567016432779-094069958ea5?q=80&w=700', // 3 sehpa/vazo
    'https://images.unsplash.com/photo-1615874959474-d609969a20ed?q=80&w=900', // 4 yemek odası (vitrin, uzun)
    'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=900', // 5 yatak odası (geniş)
    'https://images.unsplash.com/photo-1531835551805-16d864c8d311?q=80&w=700', // 6 çerçeve/dekor
    'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=700', // 7 mutfak rafı
    'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?q=80&w=700', // 8 tuğla duvar/ahşap masa (aksan)
  ];

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
            context.isMobile
                ? _buildMobileMasonry(context)
                : _buildBentoGrid(context),
          ],
        ),
      ),
    );
  }

  // Masaüstü/tablet: 6 sütunluk gerçek bento — büyük/küçük/geniş/uzun
  // karışık, boşluksuz, referans görseldeki asimetrik ritimle.
  Widget _buildBentoGrid(final BuildContext context) {
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
                  child: _PhotoTile(url: _photos[tile[4]]),
                ),
            ],
          ),
        );
      },
    );
  }

  // Mobil: dar ekranda karmaşık bento yerine, tüm 9 fotoğrafı kullanan
  // eşit olmayan iki sütunlu bir masonry — dolu ama sade.
  Widget _buildMobileMasonry(final BuildContext context) {
    const leftHeights = [190.0, 130.0, 170.0, 150.0, 200.0];
    const leftPhotos = [0, 2, 4, 6, 8];
    const rightHeights = [140.0, 220.0, 150.0, 180.0];
    const rightPhotos = [1, 3, 5, 7];

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
