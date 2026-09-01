import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';

/// DENEME/KARŞILAŞTIRMA BÖLÜMÜ — kullanıcının paylaştığı referans
/// tasarımların (Livora/InteriorStudio) en beğenilen öğelerini kendi
/// marka renklerimiz, kendi rozetlerimiz ve kendi gerçek ürün verimizle
/// yeniden yorumlar. Mevcut hiçbir section'ın yerini almaz — sayfanın en
/// altına, ayrı ve bağımsız bir blok olarak eklenir; kullanıcı hangi
/// tasarımı beğenirse onu tutacak.
///
/// NOT: Buradaki metinler bilerek l10n'e taşınmadı (deneme amaçlı, kalıcı
/// olması durumunda 11 dile çevrilip ARB dosyalarına taşınmalı).
class LivoraStyleShowcaseSection extends ConsumerWidget {
  const LivoraStyleShowcaseSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final availableProducts = ref.watch(availableProductsProvider);
    final spotlight =
        availableProducts.isNotEmpty ? availableProducts.first : null;

    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        color: AppColors.background,
        padding: EdgeInsets.symmetric(
            vertical: context.responsive(mobile: 32, desktop: 48)),
        child: Column(
          children: [
            _buildLabel(context),
            SizedBox(height: context.responsive(mobile: 28, desktop: 40)),
            _buildIconRow(context),
            SizedBox(height: context.responsive(mobile: 28, desktop: 40)),
            if (spotlight != null) ...[
              Padding(
                padding: context.pagePadding.copyWith(top: 0, bottom: 0),
                child: _ProductSpotlightCard(product: spotlight),
              ),
              SizedBox(height: context.responsive(mobile: 28, desktop: 40)),
            ],
            _buildAccentBanner(context),
            SizedBox(height: context.responsive(mobile: 28, desktop: 40)),
            _buildWhyChooseRow(context),
            SizedBox(height: context.responsive(mobile: 28, desktop: 40)),
            _buildQuoteRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(final BuildContext context) => Padding(
        padding: context.pagePadding.copyWith(top: 0, bottom: 0),
        child: Column(
          children: [
            Text('ALTERNATİF VİTRİN DENEMESİ',
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    fontSize: context.captionSize)),
            const SizedBox(height: 8),
            Text('Sade ve Zarif Bir Görünüm',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(
              'Aynı ürünler ve verilerle, daha sade bir düzen denemesi — hangisini beğenirseniz onu tutacağız.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: context.bodySize,
                  height: 1.5),
            ),
            const SizedBox(height: 18),
            _buildTrustAvatars(context),
          ],
        ),
      );

  // Referans tasarımdaki "Trusted by 25.000+ happy customers" satırının
  // karşılığı — gerçek müşteri fotoğrafımız olmadığı için baş harfli,
  // marka renginde rozetlerle (uydurma yüz fotoğrafı YOK).
  Widget _buildTrustAvatars(final BuildContext context) {
    const initials = ['E', 'M', 'A', 'B'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 26.0 * initials.length + 14,
          height: 34,
          child: Stack(
            children: [
              for (int i = 0; i < initials.length; i++)
                Positioned(
                  left: i * 22.0,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: AppColors.surface,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          AppColors.accent.withOpacity(0.85 - i * 0.1),
                      child: Text(initials[i],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text('2.500+ mutlu müşteri',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: context.captionSize)),
      ],
    );
  }

  Widget _buildIconRow(final BuildContext context) {
    final items = [
      (Icons.verified_rounded, 'Kaliteli Malzeme', 'Özenle seçilir'),
      (Icons.handyman_rounded, 'El İşçiliği', 'Ustaların emeği'),
      (Icons.eco_rounded, 'Sürdürülebilir Seçim', 'Çevre dostu tercih'),
      (Icons.assignment_return_rounded, 'Kolay İade', '30 gün içinde'),
    ];

    return Padding(
      padding: context.pagePadding.copyWith(top: 0, bottom: 0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: context.responsive(mobile: 24, desktop: 40),
        runSpacing: 20,
        children: [
          for (final item in items)
            SizedBox(
              width: context.responsive(mobile: 130, desktop: 160),
              child: Column(
                children: [
                  Icon(item.$1, color: AppColors.accentDark, size: 28),
                  const SizedBox(height: 10),
                  Text(item.$2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: context.captionSize,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(item.$3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccentBanner(final BuildContext context) => Padding(
        padding: context.pagePadding.copyWith(top: 0, bottom: 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: double.infinity,
            padding:
                EdgeInsets.all(context.responsive(mobile: 24, desktop: 44)),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
            child: Flex(
              direction: context.isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: context.isMobile
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('YENİ GELENLER',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              fontSize: 11)),
                      const SizedBox(height: 8),
                      Text('Sıfır Koleksiyonu Keşfedin',
                          style: TextStyle(
                              fontFamily: 'Fraunces',
                              fontSize: context.h3Size,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      const SizedBox(height: 6),
                      Text('Esnek, şık ve gerçek hayata uygun mobilyalar.',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: context.bodySize)),
                    ],
                  ),
                ),
                SizedBox(
                    width: context.isMobile ? 0 : 24,
                    height: context.isMobile ? 16 : 0),
                ElevatedButton(
                  onPressed: () => NavigationHandler.goToNewProducts(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Koleksiyonu Gör',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildWhyChooseRow(final BuildContext context) {
    final items = [
      (Icons.workspace_premium_outlined, '20+ Yıl Tecrübe'),
      (Icons.people_outline_rounded, '2.500+ Mutlu Müşteri'),
      (Icons.verified_user_outlined, 'Sigortalı Teslimat'),
      (Icons.storefront_outlined, 'Yerel Esnaf Güvencesi'),
    ];

    return Padding(
      padding: context.pagePadding.copyWith(top: 0, bottom: 0),
      child: Container(
        padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 32)),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.4),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: context.responsive(mobile: 20, desktop: 36),
          runSpacing: 16,
          children: [
            for (final item in items)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.$1, color: AppColors.accent, size: 22),
                  const SizedBox(width: 8),
                  Text(item.$2,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: context.captionSize,
                          color: AppColors.textPrimary)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteRow(final BuildContext context) {
    final quotes = [
      (
        'Ürün tam anlattıkları gibi geldi, teslimat da çok hızlıydı.',
        'Elif Y.',
        5,
      ),
      (
        'Esnaf gibi değil dost gibi ilgilendiler, kesinlikle tavsiye ederim.',
        'Mehmet K.',
        5,
      ),
      (
        'Spot ürün aldık ama sıfır gibi geldi, çok memnun kaldık.',
        'Ayşe D.',
        4,
      ),
    ];

    return Padding(
      padding: context.pagePadding.copyWith(top: 0, bottom: 0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 20,
        children: [
          for (final q in quotes)
            SizedBox(
              width: context.responsive(mobile: 280, desktop: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (final i) => Icon(
                        i < q.$3
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: AppColors.accent,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('"${q.$1}"',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                          fontSize: context.captionSize,
                          height: 1.5)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.secondary,
                        child: Text(q.$2.characters.first,
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      Text(q.$2,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                              color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductSpotlightCard extends StatelessWidget {
  const _ProductSpotlightCard({required this.product});

  final Product product;

  Color _parseHex(final String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  @override
  Widget build(final BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, 12)),
          ],
        ),
        padding: EdgeInsets.all(context.responsive(mobile: 16, desktop: 24)),
        child: Flex(
          direction: context.isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: context.isMobile ? 0 : 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: context.isMobile ? 16 / 10 : 1,
                  child: product.imagesUrl.isNotEmpty
                      ? Image.network(product.imagesUrl.first,
                          fit: BoxFit.cover)
                      : Container(color: AppColors.secondary),
                ),
              ),
            ),
            SizedBox(
                width: context.isMobile ? 0 : 32,
                height: context.isMobile ? 20 : 0),
            Expanded(
              flex: context.isMobile ? 0 : 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('ÖNE ÇIKAN ÜRÜN',
                      style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          fontSize: 11)),
                  const SizedBox(height: 8),
                  Text(product.name,
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: context.h3Size,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text('₺${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontSize: context.h4Size,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                  const SizedBox(height: 10),
                  if (product.desc.isNotEmpty)
                    Text(product.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: context.bodySize,
                            height: 1.5)),
                  if (product.availableColors.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        for (final hex in product.availableColors.take(5))
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _parseHex(hex),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => NavigationHandler.goToProduct(
                        context: context,
                        productId: product.id,
                        productSlug: product.name.toSlug()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('İncele',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
