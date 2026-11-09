import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../../core/widgets/design_system/atelier_charts.dart';
import '../../../../core/widgets/design_system/atelier_components.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../products/data/models/category_meta.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/category_meta_provider.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../providers/analytics_stats_provider.dart';

enum _RangePreset { today, week, month, year, custom }

/// Admin > İstatistikler — ESKİ hali SADECE Product.viewCountWeb/Mobile
/// ömür boyu ham sayaçlarını listeliyordu (tarih filtresi YOKTU). Artık
/// `analytics_events` koleksiyonundan (bkz. AnalyticsEventLogger) GERÇEK,
/// tarih aralığı seçilebilen, platforma ve metriğe göre kırılımlı bir
/// panel: görüntülenme/WhatsApp tıklaması/favori/satış + gelir, kategori
/// dağılımı, zaman içindeki trend.
class AdminProductStatsPage extends ConsumerStatefulWidget {
  const AdminProductStatsPage({super.key});

  @override
  ConsumerState<AdminProductStatsPage> createState() =>
      _AdminProductStatsPageState();
}

class _AdminProductStatsPageState
    extends ConsumerState<AdminProductStatsPage> {
  _RangePreset _preset = _RangePreset.month;
  DateTimeRange? _customRange;
  String _platform = 'all'; // all | web | mobile
  String _metric = 'view'; // view | contact_click | favorite | sale

  DateTimeRange get _range {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (_preset) {
      case _RangePreset.today:
        return DateTimeRange(start: today, end: today);
      case _RangePreset.week:
        return DateTimeRange(
            start: today.subtract(Duration(days: today.weekday - 1)), end: today);
      case _RangePreset.month:
        return DateTimeRange(start: DateTime(now.year, now.month, 1), end: today);
      case _RangePreset.year:
        return DateTimeRange(start: DateTime(now.year, 1, 1), end: today);
      case _RangePreset.custom:
        return _customRange ?? DateTimeRange(start: today, end: today);
    }
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
      initialDateRange: _customRange ?? _range,
    );
    if (picked != null) {
      setState(() {
        _preset = _RangePreset.custom;
        _customRange = picked;
      });
    }
  }

  String _metricLabel(final BuildContext context, final String metric) => switch (metric) {
        'view' => context.l10n.statsMetricViews,
        'contact_click' => context.l10n.statsMetricClicks,
        'favorite' => context.l10n.statsMetricFavorites,
        'sale' => context.l10n.statsMetricSales,
        _ => metric,
      };

  @override
  Widget build(final BuildContext context) {
    final eventsAsync = ref.watch(analyticsEventsProvider(_range));
    final available = ref.watch(availableProductsProvider);
    final sold = ref.watch(soldProductsProvider);
    final productsById = {for (final p in [...available, ...sold]) p.id: p};

    return AtelierBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(context.l10n.productStatsTitle,
            style: AppTextStyles.serif(
                color: AppColors.mobileTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 21)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _buildRangeChips(context),
          const SizedBox(height: AppSpacing.sm + 2),
          _buildPlatformChips(context),
          const SizedBox(height: AppSpacing.lg),
          eventsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (final e, final _) => AtelierStateView(
              icon: Icons.cloud_off_rounded,
              title: context.l10n.loadErrorTitle,
              message: e.toString(),
              actionLabel: context.l10n.retry,
              onAction: () => ref.invalidate(analyticsEventsProvider(_range)),
            ),
            data: (final allEvents) {
              final events = _platform == 'all'
                  ? allEvents
                  : allEvents.where((final e) => e.platform == _platform).toList();
              return _buildContent(context, events, productsById);
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildMostLikedCategories(context),
        ],
      ),
    ));
  }

  // "Kategori beğenme" — tarih aralığından bağımsız, her zaman güncel bir
  // toplam (bkz. category_likes_provider.dart'taki CategoryMeta.likeCount
  // notu). Bu yüzden events/_range'den AYRI, kendi provider'ını (zaten
  // canlı bir Firestore akışı) doğrudan izler.
  Widget _buildMostLikedCategories(final BuildContext context) {
    final metaAsync = ref.watch(categoryMetaProvider);
    final meta = metaAsync.value;
    if (meta == null) return const SizedBox.shrink();

    final liked = meta.values.where((final m) => m.likeCount > 0).toList()
      ..sort((final a, final b) => b.likeCount.compareTo(a.likeCount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, context.l10n.statsMostLikedCategoriesTitle),
        const SizedBox(height: AppSpacing.md),
        AtelierPanel(
          child: AtelierHorizontalBreakdown(
            bars: liked
                .take(8)
                .map((final m) => ChartBar(
                      label: m.customLabel ?? m.category.label(context),
                      value: m.likeCount.toDouble(),
                      color: m.color,
                    ))
                .toList(),
            emptyLabel: context.l10n.statsNoData,
          ),
        ),
      ],
    );
  }

  Widget _buildRangeChips(final BuildContext context) => Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          AtelierChoiceChip(
            label: context.l10n.statsRangeToday,
            selected: _preset == _RangePreset.today,
            onTap: () => setState(() => _preset = _RangePreset.today),
          ),
          AtelierChoiceChip(
            label: context.l10n.statsRangeWeek,
            selected: _preset == _RangePreset.week,
            onTap: () => setState(() => _preset = _RangePreset.week),
          ),
          AtelierChoiceChip(
            label: context.l10n.statsRangeMonth,
            selected: _preset == _RangePreset.month,
            onTap: () => setState(() => _preset = _RangePreset.month),
          ),
          AtelierChoiceChip(
            label: context.l10n.statsRangeYear,
            selected: _preset == _RangePreset.year,
            onTap: () => setState(() => _preset = _RangePreset.year),
          ),
          AtelierChoiceChip(
            label: context.l10n.statsRangeCustom,
            selected: _preset == _RangePreset.custom,
            onTap: _pickCustomRange,
          ),
        ],
      );

  Widget _buildPlatformChips(final BuildContext context) => Wrap(
        spacing: AppSpacing.sm,
        children: [
          AtelierChoiceChip(
            label: context.l10n.statsPlatformAll,
            selected: _platform == 'all',
            onTap: () => setState(() => _platform = 'all'),
          ),
          AtelierChoiceChip(
            label: context.l10n.statsPlatformWeb,
            selected: _platform == 'web',
            onTap: () => setState(() => _platform = 'web'),
          ),
          AtelierChoiceChip(
            label: context.l10n.statsPlatformMobile,
            selected: _platform == 'mobile',
            onTap: () => setState(() => _platform = 'mobile'),
          ),
        ],
      );

  Widget _buildContent(final BuildContext context, final List<AnalyticsEvent> events,
      final Map<String, Product> productsById) {
    final views = events.where((final e) => e.type == 'view').length;
    final clicks = events.where((final e) => e.type == 'contact_click').length;
    final favorites = events.where((final e) => e.type == 'favorite').length;
    final sales = events.where((final e) => e.type == 'sale').toList();
    final revenue = sales.fold<double>(0, (final s, final e) => s + (e.price ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildKpiGrid(context, views, clicks, favorites, sales.length, revenue),
        if (_platform != 'mobile') ...[
          const SizedBox(height: AppSpacing.sm),
          Text(context.l10n.statsWebFavoriteNote,
              style: TextStyle(
                  fontSize: 11.5, color: AppColors.textTertiary, height: 1.4)),
        ],
        const SizedBox(height: AppSpacing.xl),
        _sectionTitle(context, context.l10n.statsTrendTitle),
        const SizedBox(height: AppSpacing.sm),
        _buildMetricChips(context),
        const SizedBox(height: AppSpacing.md),
        AtelierPanel(
          child: AtelierTrendBars(
            bars: _trendBars(events.where((final e) => e.type == _metric).toList()),
            emptyLabel: context.l10n.statsNoData,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _sectionTitle(context, context.l10n.statsByCategoryTitle),
        const SizedBox(height: AppSpacing.md),
        AtelierPanel(
          child: AtelierHorizontalBreakdown(
            bars: _categoryBars(context, events.where((final e) => e.type == _metric).toList()),
            emptyLabel: context.l10n.statsNoData,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _sectionTitle(context, context.l10n.statsTopProductsTitle),
        const SizedBox(height: AppSpacing.md),
        AtelierPanel(
          child: AtelierHorizontalBreakdown(
            bars: _topProductBars(
                events.where((final e) => e.type == _metric).toList(), productsById),
            emptyLabel: context.l10n.statsNoData,
          ),
        ),
      ],
    );
  }

  List<ChartBar> _topProductBars(
      final List<AnalyticsEvent> events, final Map<String, Product> productsById) {
    final counts = <String, int>{};
    for (final e in events) {
      counts[e.productId] = (counts[e.productId] ?? 0) + 1;
    }
    final sortedIds = counts.keys.toList()
      ..sort((final a, final b) => counts[b]!.compareTo(counts[a]!));
    return sortedIds.take(5).map((final id) {
      final product = productsById[id];
      return ChartBar(
        label: product?.name ?? id,
        value: counts[id]!.toDouble(),
      );
    }).toList();
  }

  Widget _sectionTitle(final BuildContext context, final String text) => Text(
        text,
        style: AppTextStyles.serif(
            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      );

  Widget _buildMetricChips(final BuildContext context) => Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: ['view', 'contact_click', 'favorite', 'sale']
            .map((final m) => AtelierChoiceChip(
                  label: _metricLabel(context, m),
                  selected: _metric == m,
                  onTap: () => setState(() => _metric = m),
                ))
            .toList(),
      );

  Widget _buildKpiGrid(final BuildContext context, final int views, final int clicks,
          final int favorites, final int salesCount, final double revenue) =>
      GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 170,
          mainAxisExtent: 86,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
        ),
        children: [
          _KpiCard(
              icon: Icons.visibility_rounded,
              color: AppColors.info,
              value: '$views',
              label: context.l10n.statsMetricViews),
          _KpiCard(
              icon: Icons.chat_bubble_rounded,
              color: AppColors.success,
              value: '$clicks',
              label: context.l10n.statsMetricClicks),
          _KpiCard(
              icon: Icons.favorite_rounded,
              color: AppColors.error,
              value: '$favorites',
              label: context.l10n.statsMetricFavorites),
          _KpiCard(
              icon: Icons.sell_rounded,
              color: AppColors.accentDark,
              value: '$salesCount',
              label: context.l10n.statsMetricSales),
          _KpiCard(
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.primary,
              value: '₺${revenue.toStringAsFixed(0)}',
              label: context.l10n.statsRevenueLabel),
        ],
      );

  List<ChartBar> _categoryBars(final BuildContext context, final List<AnalyticsEvent> events) {
    final counts = <String, int>{};
    for (final e in events) {
      counts[e.category] = (counts[e.category] ?? 0) + 1;
    }
    return counts.entries.map((final entry) {
      final category = entry.key.toProductCategory();
      return ChartBar(
        label: category.label(context),
        value: entry.value.toDouble(),
        color: defaultCategoryMeta[category]?.color,
      );
    }).toList();
  }

  List<ChartBar> _trendBars(final List<AnalyticsEvent> events) {
    final range = _range;
    final days = range.end.difference(range.start).inDays + 1;
    final bucketByMonth = days > 120;
    final bucketByWeek = !bucketByMonth && days > 31;

    String keyFor(final DateTime d) {
      if (bucketByMonth) return '${d.year}-${d.month.toString().padLeft(2, '0')}';
      if (bucketByWeek) {
        final weekStart = d.subtract(Duration(days: d.weekday - 1));
        return '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
      }
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }

    String labelFor(final DateTime d) {
      if (bucketByMonth) return '${d.month}/${d.year % 100}';
      return '${d.day}/${d.month}';
    }

    final buckets = <String, _Bucket>{};
    final step = bucketByMonth
        ? null
        : bucketByWeek
            ? const Duration(days: 7)
            : const Duration(days: 1);

    if (bucketByMonth) {
      var cursor = DateTime(range.start.year, range.start.month, 1);
      final end = DateTime(range.end.year, range.end.month, 1);
      while (!cursor.isAfter(end)) {
        buckets[keyFor(cursor)] = _Bucket(labelFor(cursor), 0);
        cursor = DateTime(cursor.year, cursor.month + 1, 1);
      }
    } else {
      var cursor = range.start;
      while (!cursor.isAfter(range.end)) {
        buckets[keyFor(cursor)] = _Bucket(labelFor(cursor), 0);
        cursor = cursor.add(step!);
      }
    }

    for (final e in events) {
      final key = keyFor(e.createdAt);
      final bucket = buckets[key];
      if (bucket != null) bucket.count += 1;
    }

    return buckets.values
        .map((final b) => ChartBar(label: b.label, value: b.count.toDouble()))
        .toList();
  }
}

class _Bucket {
  final String label;
  int count;
  _Bucket(this.label, this.count);
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _KpiCard(
      {required this.icon, required this.color, required this.value, required this.label});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.mobileSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mobileBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.serif(
                          fontSize: 16, fontWeight: FontWeight.w800,
                          color: AppColors.mobileTextPrimary)),
                  Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10.5, color: AppColors.mobileTextTertiary)),
                ],
              ),
            ),
          ],
        ),
      );
}
