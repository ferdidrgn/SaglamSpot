import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'pause_when_offscreen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TickerItem {
  final IconData icon;
  final String label;
  const TickerItem(this.icon, this.label);
}

/// Referans tasarımlardaki yatay "brand strip" hareketinin karşılığı: sabit
/// hızda, kesintisiz ve sonsuz akan bir güven/özellik şeridi. `itemCount`
/// bilerek verilmiyor — `ListView.builder` böylece sınırsız kabul edip
/// modulo ile döngüsel olarak [items]'a indeksler, bu da genişlik ölçüp
/// döngü sıçraması yönetmeyi gereksiz kılar; kaydırma konumu yalnızca artar.
class InfiniteTicker extends StatefulWidget {
  final List<TickerItem> items;
  final double height;

  const InfiniteTicker({super.key, required this.items, this.height = 68});

  @override
  State<InfiniteTicker> createState() => _InfiniteTickerState();
}

class _InfiniteTickerState extends State<InfiniteTicker>
    with SingleTickerProviderStateMixin {
  /// Saniyedeki kayma (px) — eskiden kare başına sabit 0.6 px'ti; 120 Hz
  /// ekranlarda iki kat hızlı akıyor, yavaş cihazlarda sürünüyordu.
  static const double _pixelsPerSecond = 36;

  final ScrollController _scrollController = ScrollController();
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Azaltılmış hareket açıksa şerit sabit durur.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion && _ticker.isActive) {
      _ticker.stop();
    } else if (!reduceMotion && !_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    }
  }

  void _tick(final Duration elapsed) {
    if (!_scrollController.hasClients) return;
    // TickerMode ile durdurulup yeniden başlayınca (ekran dışına çıkma)
    // biriken süre yüzünden şerit sıçramasın diye adım 50 ms ile sınırlı.
    final dtMs = (elapsed - _last).inMicroseconds / 1000.0;
    _last = elapsed;
    _offset += _pixelsPerSecond * dtMs.clamp(0.0, 50.0) / 1000.0;
    _scrollController.jumpTo(_offset);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Köşesiz, dikdörtgen bir "reklam panosu" şeridi — önceki hap (pill)
  // biçimli cam yüzeyin yerine geçti. Kenarlarda ince bir gradyan maske ile
  // öğeler yumuşakça belirip kayboluyor (sert kesim yerine).
  @override
  Widget build(final BuildContext context) => PauseWhenOffscreen(
        child: Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.border, width: 1.4),
            ),
          ),
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (final rect) => const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: [0.0, 0.05, 0.95, 1.0],
            ).createShader(rect),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (final context, final index) {
                final item = widget.items[index % widget.items.length];
                return _TickerChip(item: item);
              },
            ),
          ),
        ),
      );
}

class _TickerChip extends StatelessWidget {
  final TickerItem item;
  const _TickerChip({required this.item});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 24, color: AppColors.accent),
            const SizedBox(width: 12),
            // maxWidth + ellipsis: uzun/dinamik (semt listesi gibi
            // interpolasyonlu) bir etiket geldiğinde bile bu tek çip,
            // şeritteki komşularının çok üstünde genişleyip akışın
            // ritmini bozmasın diye.
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Text(item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.microLabel(
                      fontSize: 17,
                      letterSpacing: 1.2,
                      color: AppColors.textPrimary)),
            ),
            const SizedBox(width: 26),
            Icon(Icons.circle, size: 6, color: AppColors.border),
          ],
        ),
      );
}
