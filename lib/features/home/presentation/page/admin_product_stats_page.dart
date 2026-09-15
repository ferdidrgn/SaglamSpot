import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';

/// Admin > İstatistikler — hangi ürüne ne kadar bakılmış (detay sayfası kaç
/// kez açılmış), web'den mi mobilden mi — tek bakışta görülsün diye.
/// Veri kaynağı Product.viewCountWeb/viewCountMobile (bkz.
/// core/services/product_view_tracker.dart'taki artırma noktası ve
/// firestore.rules'daki güvenli artırma kuralı). Mevcut (satılmamış) ve
/// satılmış ürünler AYRI listelenir — "en çok bakılan ama hâlâ satılmayan"
/// ile "çok bakılıp satılmış" birbirine karışmasın diye.
class AdminProductStatsPage extends ConsumerWidget {
  const AdminProductStatsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final available = ref.watch(availableProductsProvider);
    final sold = ref.watch(soldProductsProvider);
    final all = [...available, ...sold];

    final int webTotal =
        all.fold<int>(0, (final sum, final p) => sum + p.viewCountWeb);
    final int mobileTotal =
        all.fold<int>(0, (final sum, final p) => sum + p.viewCountMobile);

    final availableSorted = [...available]
      ..sort((final a, final b) => _totalViews(b).compareTo(_totalViews(a)));
    final soldSorted = [...sold]
      ..sort((final a, final b) => _totalViews(b).compareTo(_totalViews(a)));

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      appBar: AppBar(
        backgroundColor: AppColors.mobileBackground,
        elevation: 0,
        title: Text(context.l10n.productStatsTitle,
            style: TextStyle(
                color: AppColors.mobileTextPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _TotalsCard(webTotal: webTotal, mobileTotal: mobileTotal),
          const SizedBox(height: 20),
          _SectionLabel(
              context.l10n.productStatsAvailableSection(availableSorted.length)),
          const SizedBox(height: 8),
          if (availableSorted.isEmpty)
            _EmptyNote(text: context.l10n.productStatsEmpty)
          else
            for (int i = 0; i < availableSorted.length; i++)
              _ProductViewRow(rank: i + 1, product: availableSorted[i]),
          const SizedBox(height: 24),
          _SectionLabel(context.l10n.productStatsSoldSection(soldSorted.length)),
          const SizedBox(height: 8),
          if (soldSorted.isEmpty)
            _EmptyNote(text: context.l10n.productStatsEmpty)
          else
            for (int i = 0; i < soldSorted.length; i++)
              _ProductViewRow(rank: i + 1, product: soldSorted[i], dimmed: true),
        ],
      ),
    );
  }

  int _totalViews(final Product p) => p.viewCountWeb + p.viewCountMobile;
}

class _TotalsCard extends StatelessWidget {
  final int webTotal;
  final int mobileTotal;

  const _TotalsCard({required this.webTotal, required this.mobileTotal});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.mobilePrimaryGradient,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.productStatsTotalViews,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('${webTotal + mobileTotal}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1.1)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _TotalsMiniStat(
                    icon: Icons.language_rounded,
                    label: context.l10n.productStatsWeb,
                    value: webTotal,
                  ),
                ),
                Container(width: 1, height: 30, color: Colors.white24),
                Expanded(
                  child: _TotalsMiniStat(
                    icon: Icons.phone_iphone_rounded,
                    label: context.l10n.productStatsMobile,
                    value: mobileTotal,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _TotalsMiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _TotalsMiniStat(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$value',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                Text(label,
                    style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
              ],
            ),
          ],
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(final BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
          color: AppColors.mobileTextTertiary,
        ),
      );
}

class _EmptyNote extends StatelessWidget {
  final String text;
  const _EmptyNote({required this.text});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text,
            style: TextStyle(fontSize: 12.5, color: AppColors.mobileTextTertiary)),
      );
}

class _ProductViewRow extends StatelessWidget {
  final int rank;
  final Product product;
  final bool dimmed;

  const _ProductViewRow({
    required this.rank,
    required this.product,
    this.dimmed = false,
  });

  @override
  Widget build(final BuildContext context) {
    final int total = product.viewCountWeb + product.viewCountMobile;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: dimmed
            ? AppColors.mobileSurface.withOpacity(0.6)
            : AppColors.mobileSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mobileBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text('$rank',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mobileTextTertiary)),
          ),
          const SizedBox(width: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: OptimizedCachedImage(
              imageUrl: product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '',
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              borderRadius: 0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mobileTextPrimary)),
                const SizedBox(height: 3),
                Text(
                  context.l10n
                      .productStatsRowBreakdown(product.viewCountWeb, product.viewCountMobile),
                  style: TextStyle(fontSize: 11, color: AppColors.mobileTextTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.mobileAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$total',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.mobileAccentDark)),
          ),
        ],
      ),
    );
  }
}
