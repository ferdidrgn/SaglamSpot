import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Ekrana kaydırıldığında (scroll ile göründüğünde) bir kez tetiklenen,
/// 0'dan hedef değere sayan animasyon. İstatistik bölümleri, "2.5K+ Mutlu
/// Müşteri" gibi güven rakamları için kullanılır.
///
/// Sayfa ilk açıldığında DEĞİL, kullanıcı gerçekten o bölüme kaydırdığında
/// tetiklenir — bu yüzden [VisibilityDetector] kullanıyoruz (sadece bir kez
/// ateşlenmesi için [_hasAnimated] ile kilitliyoruz).
class CountUpOnVisible extends StatefulWidget {
  final double targetValue;
  final String prefix;
  final String suffix;
  final int decimalDigits;
  final TextStyle? style;
  final Duration duration;

  const CountUpOnVisible({
    super.key,
    required this.targetValue,
    this.prefix = '',
    this.suffix = '',
    this.decimalDigits = 0,
    this.style,
    this.duration = const Duration(milliseconds: 1600),
  });

  @override
  State<CountUpOnVisible> createState() => _CountUpOnVisibleState();
}

class _CountUpOnVisibleState extends State<CountUpOnVisible>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  bool _hasAnimated = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(final VisibilityInfo info) {
    if (_hasAnimated) return;
    // %30'undan fazlası görünür hale gelince say meye başla.
    if (info.visibleFraction > 0.3) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return VisibilityDetector(
      key: Key('count-up-${widget.key ?? widget.targetValue}-${widget.suffix}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (final context, final _) {
          final current = widget.targetValue * _animation.value;
          return Text(
            '${widget.prefix}${current.toStringAsFixed(widget.decimalDigits)}${widget.suffix}',
            style: widget.style,
          );
        },
      ),
    );
  }
}
