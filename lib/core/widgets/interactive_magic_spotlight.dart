import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class InsaneMagicShowcase extends StatefulWidget {
  const InsaneMagicShowcase({super.key});

  @override
  State<InsaneMagicShowcase> createState() => _InsaneMagicShowcaseState();
}

class _InsaneMagicShowcaseState extends State<InsaneMagicShowcase>
    with SingleTickerProviderStateMixin {
  Offset interaction = Offset.zero;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final size = constraints.biggest;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,

          /// 📱 MOBİL WEB – PARMAK
          onPanUpdate: (final details) {
            setState(() {
              interaction = Offset(
                (details.localPosition.dx / size.width - 0.5) * 2,
                (details.localPosition.dy / size.height - 0.5) * 2,
              );
            });
          },
          onPanEnd: (final _) {
            setState(() => interaction = Offset.zero);
          },

          child: MouseRegion(
            /// 🖥️ DESKTOP WEB – MOUSE
            onHover: (final event) {
              setState(() {
                interaction = Offset(
                  (event.localPosition.dx / size.width - 0.5) * 2,
                  (event.localPosition.dy / size.height - 0.5) * 2,
                );
              });
            },

            child: AnimatedBuilder(
              animation: controller,
              builder: (final _, final __) {
                final t = controller.value * 2 * pi;

                return Container(
                  height: 800,
                  width: double.infinity,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      /// 🌌 AKAN GRADIENT BACKGROUND
                      Positioned.fill(
                        child: Transform.rotate(
                          angle: t * 0.05,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                radius: 1.2,
                                colors: [
                                  Colors.deepPurple.withOpacity(0.4),
                                  Colors.blue.withOpacity(0.2),
                                  Colors.black,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// 🔦 MOUSE / TOUCH SPOTLIGHT
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(
                                interaction.dx,
                                interaction.dy,
                              ),
                              radius: 0.45,
                              colors: [
                                Colors.white.withOpacity(0.25),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// 🌀 DEV GLOW HALO
                      Positioned(
                        left: size.width / 2 - 350 + sin(t) * 40,
                        top: 200 + cos(t) * 40,
                        child: Container(
                          width: 700,
                          height: 700,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.35),
                                blurRadius: 200,
                                spreadRadius: 80,
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// 🪐 GENİŞ ARKA PLAN FOTO (SAHNE)
                      Positioned.fill(
                        child: OverflowBox(
                          maxWidth: size.width * 1.2,
                          maxHeight: size.height * 1.2,
                          alignment: Alignment.center,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(-interaction.dy * 0.3)
                              ..rotateY(interaction.dx * 0.4)
                              ..translate(
                                interaction.dx * 40,
                                interaction.dy * 30,
                              )
                              ..scale(1.15),
                            child: Image.network(
                              "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      /// ✨ FLOATING NEON TEXT
                      Positioned(
                        top: 120,
                        left: 80,
                        child: Transform.translate(
                          offset: Offset(sin(t) * 20, cos(t) * 20),
                          child: Text(
                            "NEXT\nLEVEL\nSCENE",
                            style: TextStyle(
                              fontSize: 72,
                              height: 1,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Colors.cyanAccent,
                                    Colors.purpleAccent,
                                  ],
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 400, 200),
                                ),
                              shadows: [
                                Shadow(
                                  color: Colors.cyanAccent.withOpacity(0.8),
                                  blurRadius: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// 🧩 FLOATING HUD CARD – SOL ALT
                      _hudCard(
                        left: 120,
                        bottom: 140,
                        label: "REAL-TIME\nINTERACTION",
                        t: t,
                      ),

                      /// 🧩 FLOATING HUD CARD – SAĞ ÜST
                      _hudCard(
                        right: 160,
                        top: 160,
                        label: "MOBILE + WEB\nREADY",
                        t: t + 1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _hudCard({
    final double? left,
    final double? right,
    final double? top,
    final double? bottom,
    required final String label,
    required final double t,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Transform.translate(
        offset: Offset(sin(t) * 15, cos(t) * 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.5),
                    blurRadius: 40,
                  )
                ],
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
