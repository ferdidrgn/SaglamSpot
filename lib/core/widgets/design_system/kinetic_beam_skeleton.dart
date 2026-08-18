import 'package:flutter/material.dart';
import '../../theme/app_design_tokens.dart';

/// 2026 stili yükleme iskeleti: klasik tek-tonlu shimmer yerine, koyu bir
/// zemin üzerinde çapraz geçen ince bir "ışık kirişi" (ışığın camdan
/// yansıması gibi). [ShaderMask] ile taban rengin üzerine kayan bir
/// gradyan bindirilir — [AnimationController] tek sefer oluşturulur ve
/// sürekli döner, her build'de yeniden kurulmaz.
///
/// Kullanım: herhangi bir yer tutucu boyutu için (`width`/`height` veya
/// `Expanded` içinde) kart/görsel iskeleti olarak.
class KineticBeamSkeleton extends StatefulWidget {
  const KineticBeamSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 16,
  });

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  State<KineticBeamSkeleton> createState() => _KineticBeamSkeletonState();
}

class _KineticBeamSkeletonState extends State<KineticBeamSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final tokens = context.glass;
    final base = tokens.glassTint.withOpacity(0.5);
    final beam = tokens.glassHighlight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ColoredBox(
          color: base,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (final context, final _) => ShaderMask(
              blendMode: BlendMode.plus,
              shaderCallback: (final rect) {
                final sweep = _controller.value * 2.6 - 0.8;
                return LinearGradient(
                  begin: Alignment(-1.6 + sweep, -1),
                  end: Alignment(-0.6 + sweep, 1),
                  colors: [
                    Colors.transparent,
                    beam,
                    Colors.transparent,
                  ],
                  stops: const [0.35, 0.5, 0.65],
                ).createShader(rect);
              },
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}
