import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_tokens.dart';

/// Admin istatistikler ekranı için bağımlılıksız, basit grafik
/// bileşenleri — web-genesis'teki el yapımı SVG grafiklerle (bkz.
/// public/static/js/admin-charts.js) AYNI felsefe: proje hiçbir chart
/// paketi kullanmıyor (bkz. flutter-interactive-ui skill §8 — Flutter
/// SDK yeterliyse paket eklenmez), bu yüzden burada da düz widget'larla
/// (CustomPainter dahi gerekmeden) çizilen iki genel grafik türü var.

class ChartBar {
  final String label;
  final double value;
  final Color? color;
  const ChartBar({required this.label, required this.value, this.color});
}

/// Zaman içindeki trend için dikey çubuk grafik — her çubuk, en yüksek
/// değere oranla animasyonlu şekilde büyür.
class AtelierTrendBars extends StatelessWidget {
  final List<ChartBar> bars;
  final double height;
  final String Function(double value) valueFormatter;
  final String emptyLabel;

  const AtelierTrendBars({
    super.key,
    required this.bars,
    required this.emptyLabel,
    this.height = 160,
    this.valueFormatter = _defaultFormatter,
  });

  static String _defaultFormatter(final double v) => v.toStringAsFixed(0);

  @override
  Widget build(final BuildContext context) {
    if (bars.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(emptyLabel,
              style: TextStyle(color: AppColors.textTertiary, fontSize: 13)),
        ),
      );
    }

    final max = bars.fold<double>(1, (final m, final b) => b.value > m ? b.value : m);

    return SizedBox(
      height: height + 46,
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: bars
                .map((final bar) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 38,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(valueFormatter(bar.value),
                                style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: height,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOutCubic,
                                  tween: Tween(
                                      begin: 0,
                                      end: bar.value <= 0
                                          ? 2.0
                                          : (bar.value / max) * height),
                                  builder: (final context, final h, final _) => Container(
                                    width: 22,
                                    height: h,
                                    decoration: BoxDecoration(
                                      color: bar.color ?? AppColors.accent,
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(6)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(bar.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10, color: AppColors.textTertiary)),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

/// Kategori/segment kırılımı için yatay, orana göre uzunlukta çubuklar —
/// halka (donut) grafik yerine (CustomPainter gerektirmeden) AYNI bilgiyi
/// verir: en büyükten en küçüğe sıralı liste + yüzde.
class AtelierHorizontalBreakdown extends StatelessWidget {
  final List<ChartBar> bars;
  final String emptyLabel;
  final String Function(double value) valueFormatter;

  const AtelierHorizontalBreakdown({
    super.key,
    required this.bars,
    required this.emptyLabel,
    this.valueFormatter = _defaultFormatter,
  });

  static String _defaultFormatter(final double v) => v.toStringAsFixed(0);

  @override
  Widget build(final BuildContext context) {
    if (bars.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(emptyLabel,
            style: TextStyle(color: AppColors.textTertiary, fontSize: 13)),
      );
    }

    final sorted = [...bars]..sort((final a, final b) => b.value.compareTo(a.value));
    final max = sorted.first.value <= 0 ? 1.0 : sorted.first.value;
    final total = sorted.fold<double>(0, (final s, final b) => s + b.value);

    return Column(
      children: sorted
          .map((final bar) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(bar.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                        ),
                        Text(
                          total > 0
                              ? '${valueFormatter(bar.value)} · %${(bar.value / total * 100).round()}'
                              : valueFormatter(bar.value),
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        tween: Tween(begin: 0, end: bar.value / max),
                        builder: (final context, final fraction, final _) =>
                            LinearProgressIndicator(
                          value: fraction.clamp(0.02, 1.0),
                          minHeight: 8,
                          backgroundColor: AppColors.border.withValues(alpha: 0.4),
                          color: bar.color ?? AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
