import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'glass_surface.dart';

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
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _controller;
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_tick);
    _controller.repeat();
  }

  void _tick() {
    if (!_scrollController.hasClients) return;
    _offset += 0.6;
    _scrollController.jumpTo(_offset);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => GlassSurface(
        borderRadius: 999,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: widget.height,
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
            Text(item.label,
                style: AppTextStyles.microLabel(
                    fontSize: 17,
                    letterSpacing: 1.2,
                    color: AppColors.textPrimary)),
            const SizedBox(width: 26),
            Icon(Icons.circle, size: 6, color: AppColors.border),
          ],
        ),
      );
}
