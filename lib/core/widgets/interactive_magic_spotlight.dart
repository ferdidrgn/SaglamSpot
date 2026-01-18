import 'dart:ui';
import 'package:flutter/material.dart';

import '../extentions/app_context_ui_extension.dart';

class InsaneMagicShowcase extends StatefulWidget {
  final double? height;
  final String imageUrl;
  final bool enableInteraction;
  final double imageScale;

  const InsaneMagicShowcase({
    super.key,
    this.height,
    required this.imageUrl,
    this.enableInteraction = true,
    this.imageScale = 1.05,
  });

  @override
  State<InsaneMagicShowcase> createState() => _InsaneMagicShowcaseState();
}

class _InsaneMagicShowcaseState extends State<InsaneMagicShowcase>
    with SingleTickerProviderStateMixin {
  Offset _target = Offset.zero;
  Offset _smooth = Offset.zero;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 32),
    )
      ..addListener(_tick)
      ..repeat();
  }

  void _tick() {
    // 🔥 SMOOTH FOLLOW (İNERTIA)
    _smooth = Offset.lerp(_smooth, _target, context.isMobile ? 0.04 : 0.08)!;
    setState(() {});
  }

  Offset _normalize(final Offset local, final Size size) {
    final dx = ((local.dx / size.width) - 0.5) * 2;
    final dy = ((local.dy / size.height) - 0.5) * 2;

    return Offset(
      dx.clamp(-0.6, 0.6),
      dy.clamp(-0.6, 0.6),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final sectionHeight = widget.height ??
        context.responsive(
          mobile: 520.0,
          tablet: 640.0,
          desktop: 820.0,
          largeDesktop: 920.0,
        );

    return LayoutBuilder(
      builder: (final _, final constraints) {
        final size = constraints.biggest;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: widget.enableInteraction
              ? (final d) => _target = _normalize(d.localPosition, size)
              : null,
          onPanEnd: (final _) => _target = Offset.zero,
          child: MouseRegion(
            onHover: widget.enableInteraction
                ? (final e) => _target = _normalize(e.localPosition, size)
                : null,
            onExit: (final _) => _target = Offset.zero,
            child: Container(
              height: sectionHeight,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.4,
                  colors: [
                    Color(0xFF1A1A2E),
                    Colors.black,
                  ],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  /// 🌌 SOFT BACKGROUND
                  Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        radius: 1.4,
                        colors: [
                          Color(0xFF1A1A2E),
                          Colors.black,
                        ],
                      ),
                    ),
                  ),

                  /// 🪐 MAIN IMAGE (SAFE PARALLAX)
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      //perspektif kamera yakınlığı
                      ..setEntry(3, 2, 0.001)
                      //hareket
                      ..rotateX(-_smooth.dy * 0.2)
                      ..rotateY(-_smooth.dx * 0.1)
                      //gezinme - kaydırma
                      ..translate(
                        _smooth.dx * 22,
                        _smooth.dy * 16,
                      )
                      //takip hızı
                      ..scale(widget.imageScale.clamp(1.08, 1.18)),                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  /// 🔦 VERY SOFT SPOTLIGHT
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(
                            _smooth.dx,
                            _smooth.dy,
                          ),
                          radius: 0.6,
                          colors: [
                            Colors.white.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// ✨ UI OVERLAY (OPTIONAL)
                  Positioned(
                    left: 80,
                    top: 120,
                    child: _label("IMMERSIVE\nSHOWCASE"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(final String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
