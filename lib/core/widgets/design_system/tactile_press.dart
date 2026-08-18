import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Her dokunulabilir yüzeye "gerçek" bir his katan mikro-etkileşim sarmalayıcı.
///
/// - **Dokunma:** basılı tutulduğunda hafifçe küçülür (spring-damped geri
///   dönüş — [SpringSimulation] ile, sabit süreli bir [Curve] DEĞİL).
/// - **Web hover:** fare imleci üzerine geldiğinde 3B'ye yakın hafif bir
///   "tilt/parallax" — imlecin kart merkezine göre konumuna bağlı ince bir
///   [Matrix4] rotasyonu. Sadece web'de aktif (mobilde MouseRegion zaten
///   tetiklenmez, ama gereksiz perspektif hesaplamasından kaçınmak için
///   [kIsWeb] ile de kapatılır).
///
/// State-agnostik: herhangi bir child'ı sarmalar, kendi görsel dilini
/// dayatmaz — bento kart, buton, chip, ürün kartı fark etmez.
class TactilePress extends StatefulWidget {
  const TactilePress({
    super.key,
    required this.child,
    this.onTap,
    this.pressScale = 0.96,
    this.enableTilt = true,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Basılı durumdaki ölçek (1.0 = değişim yok).
  final double pressScale;

  /// Web'de fare hover'ında tilt/parallax efekti.
  final bool enableTilt;

  /// Tilt sırasında gölge/köşe hesaplarken kullanılan köşe yarıçapı ipucu
  /// (yalnızca görsel tutarlılık için, zorunlu değil).
  final double? borderRadius;

  @override
  State<TactilePress> createState() => _TactilePressState();
}

class _TactilePressState extends State<TactilePress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController = AnimationController(
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
    value: 0.0,
  );

  Offset _tilt = Offset.zero; // -1..1 aralığında normalize edilmiş imleç konumu
  Size _size = Size.zero;

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _animateTo(final double target) {
    final simulation = SpringSimulation(
      const SpringDescription(mass: 1, stiffness: 420, damping: 22),
      _scaleController.value,
      target,
      0,
    );
    _scaleController.animateWith(simulation);
  }

  void _onHover(final PointerHoverEvent event) {
    if (!widget.enableTilt || !kIsWeb || _size == Size.zero) return;
    final dx = (event.localPosition.dx / _size.width) * 2 - 1;
    final dy = (event.localPosition.dy / _size.height) * 2 - 1;
    setState(() => _tilt = Offset(dx.clamp(-1.0, 1.0), dy.clamp(-1.0, 1.0)));
  }

  void _resetTilt() {
    if (_tilt != Offset.zero) setState(() => _tilt = Offset.zero);
  }

  @override
  Widget build(final BuildContext context) {
    final scale = 1.0 - (_scaleController.value * (1 - widget.pressScale));

    Widget content = AnimatedBuilder(
      animation: _scaleController,
      builder: (final context, final child) {
        final matrix = Matrix4.identity()
          ..setEntry(3, 2, 0.0012)
          ..rotateX(-_tilt.dy * 0.06)
          ..rotateY(_tilt.dx * 0.06)
          ..scale(scale);
        return Transform(
          alignment: Alignment.center,
          transform: matrix,
          child: child,
        );
      },
      child: widget.child,
    );

    content = MouseRegion(
      onHover: _onHover,
      onExit: (final _) => _resetTilt(),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: content,
    );

    return LayoutBuilder(
      builder: (final context, final constraints) {
        _size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTap: widget.onTap,
          onTapDown: (final _) => _animateTo(1.0),
          onTapUp: (final _) => _animateTo(0.0),
          onTapCancel: () => _animateTo(0.0),
          child: content,
        );
      },
    );
  }
}
