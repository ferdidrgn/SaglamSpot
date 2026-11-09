import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../providers/analytics_stats_provider.dart';
import 'admin_dashboard_product_grid.dart';
import 'admin_dashboard_stat_card.dart';

/// Admin ana ekranının "Genel bakış" şeridi — bu ayki KPI'lar (TicketApp'in
/// `dashboard.js`'indeki kart özetinin karşılığı, ayrı bir Cloud Function
/// olmadan mevcut `analyticsEventsProvider`'ı bu ay aralığıyla yeniden
/// kullanır) ve eksik bilgili ürün uyarısı. `_buildStatsRow`'un (Stok/
/// Satıldı/Toplam) ÜSTÜNE eklenir, onun yerini almaz.
class AdminOverviewSection extends ConsumerWidget {
  const AdminOverviewSection({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final now = DateTime.now();
    final range = DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
    final eventsAsync = ref.watch(analyticsEventsProvider(range));
    final available = ref.watch(availableProductsProvider);
    final sold = ref.watch(soldProductsProvider);
    final missing = [...available, ...sold]
        .where((final p) => p.imagesUrl.isEmpty || p.desc.trim().isEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 88,
          child: eventsAsync.when(
            loading: () => const Center(
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))),
            error: (final _, final __) => const SizedBox.shrink(),
            data: (final events) {
              int countOf(final String type) =>
                  events.where((final e) => e.type == type).length;
              return ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
                children: [
                  _kpi(context, context.l10n.statsMetricViews,
                      countOf('view'), Icons.visibility_rounded, AppColors.info),
                  _kpi(
                      context,
                      context.l10n.statsMetricClicks,
                      countOf('contact_click'),
                      Icons.chat_bubble_rounded,
                      AppColors.success),
                  _kpi(
                      context,
                      context.l10n.statsMetricFavorites,
                      countOf('favorite'),
                      Icons.favorite_rounded,
                      AppColors.mobileAccentDark),
                  _kpi(context, context.l10n.statsMetricSales, countOf('sale'),
                      Icons.sell_rounded, AppColors.mobilePrimary),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: _MissingInfoBanner(products: missing),
        ),
      ],
    );
  }

  Widget _kpi(final BuildContext context, final String label, final int value,
          final IconData icon, final Color color) =>
      Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: SizedBox(
          width: 148,
          child: AdminStatCard(
              label: label, value: '$value', icon: icon, color: color),
        ),
      );
}

class _MissingInfoBanner extends StatelessWidget {
  const _MissingInfoBanner({required this.products});

  final List<Product> products;

  @override
  Widget build(final BuildContext context) {
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.10),
          borderRadius: AppRadius.all(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(context.l10n.adminOverviewMissingInfoNone,
                  style: TextStyle(fontSize: 12.5, color: AppColors.success)),
            ),
          ],
        ),
      );
    }

    return Material(
      color: AppColors.mobileSurface,
      borderRadius: AppRadius.all(AppRadius.md),
      child: InkWell(
        borderRadius: AppRadius.all(AppRadius.md),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (final _) => _MissingInfoListPage(products: products),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
          decoration: BoxDecoration(
            borderRadius: AppRadius.all(AppRadius.md),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.warning),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.adminOverviewMissingInfoTitle,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mobileTextPrimary)),
                    Text(
                        context.l10n
                            .adminOverviewMissingInfoSubtitle(products.length),
                        style:
                            TextStyle(fontSize: 11.5, color: AppColors.mobileTextSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 18, color: AppColors.mobileTextTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingInfoListPage extends StatelessWidget {
  const _MissingInfoListPage({required this.products});

  final List<Product> products;

  @override
  Widget build(final BuildContext context) => AtelierBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(context.l10n.adminOverviewMissingInfoTitle),
          ),
          body: AdminProductGrid(products: products),
        ),
      );
}
