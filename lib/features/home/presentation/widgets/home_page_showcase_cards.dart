import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';

/// Ana sayfanın ("HomePage", web) "iki kapı" / özellik / oda vitrin
/// kartları — eskiden home_page_web.dart'ın sonunda duruyordu, okunabilirlik
/// için ayrı dosyaya taşındı. Davranış/görünüm AYNI kaldı.

/// Ana sayfadaki "iki kapı" kartı — Sıfır Koleksiyon ve Spot Fırsatlar'ın
/// kendi renk/tipografi kimliğini (bkz. catalog_theme.dart) taşıyan,
/// tıklanınca ilgili sekmeye götüren büyük bir vitrin kartı.
class GatewayCard extends StatelessWidget {
  const GatewayCard({
    required this.eyebrow,
    required this.eyebrowColor,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.background,
    required this.cardBorder,
    required this.heading,
    required this.body,
    required this.accent,
    required this.headingFontFamily,
    required this.icon,
    required this.buttonLabel,
    required this.onTap,
  });

  final String eyebrow;
  final Color eyebrowColor;
  final String title;
  final String subtitle;
  final int count;
  final Color background;
  final Color cardBorder;
  final Color heading;
  final Color body;
  final Color accent;
  final String? headingFontFamily;
  final IconData icon;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => TactilePress(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(context.responsive(mobile: 24, desktop: 32)),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cardBorder),
            // "Havada süzülen" 3B his: katmanlı, tamamen dikey ofsetli
            // gölgeler — üstte neredeyse hiç iz bırakmıyor, aşağı ve
            // yanlara doğru gide gide belirginleşiyor.
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: accent.withOpacity(0.16),
                blurRadius: 36,
                offset: const Offset(0, 22),
                spreadRadius: -6,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Köşeden taşan renkli "glow" — düz arka plana canlılık
              // katan yumuşak bir radyal gradyan; LayoutBuilder KULLANMAZ
              // (masaüstünde bu kartlar IntrinsicHeight içinde eşit
              // yüksekliğe zorlanıyor, LayoutBuilder orada exception atar).
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(1.15, 1.25),
                      radius: 1.05,
                      colors: [accent.withOpacity(0.22), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // İnce yörünge çizgisi + nokta kümesi: sanatsal, dokusal bir
              // dokunuş. CustomPaint boyutu doğrudan paint(size)'dan alır,
              // LayoutBuilder gerektirmez — bu yüzden IntrinsicHeight ile
              // güvenle bir arada kullanılabilir.
              Positioned.fill(
                child:
                    CustomPaint(painter: _GatewayMotifPainter(accent: accent)),
              ),
              // Katmanlı ikon kompozisyonu: tek soluk ikon yerine, farklı
              // boyut/açı/opaklıkta üç ikon — "koleksiyon" hissi veren bir
              // mini kolaj.
              Positioned(
                right: -22,
                bottom: -22,
                child: Transform.rotate(
                  angle: -0.12,
                  child: Icon(icon, size: 132, color: accent.withOpacity(0.10)),
                ),
              ),
              Positioned(
                right: 34,
                bottom: 8,
                child: Transform.rotate(
                  angle: 0.22,
                  child: Icon(Icons.auto_awesome_rounded,
                      size: 30, color: accent.withOpacity(0.30)),
                ),
              ),
              Positioned(
                top: 14,
                right: 18,
                child: Icon(Icons.circle,
                    size: 8, color: accent.withOpacity(0.24)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(eyebrow,
                      style: AppTextStyles.microLabel(
                          color: eyebrowColor,
                          letterSpacing: 2.4,
                          fontSize: 11)),
                  const SizedBox(height: 12),
                  Text(title,
                      style: TextStyle(
                          fontFamily: headingFontFamily,
                          fontSize: context.responsive(mobile: 22, desktop: 26),
                          fontWeight: FontWeight.w700,
                          color: heading,
                          height: 1.15)),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style:
                          TextStyle(color: body, fontSize: 13, height: 1.45)),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(context.l10n.gatewayProductCount(count),
                            style: TextStyle(
                                color: accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                      ElevatedButton.icon(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                        label: Text(buttonLabel,
                            style: const TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

/// Ana sayfadaki özellik satırının, hero'nun altına taşan tekil beyaz kartı.
class FeatureOverlapCard extends StatefulWidget {
  const FeatureOverlapCard({
    required this.image,
    required this.icon,
    required this.title,
    required this.desc,
    required this.buttonLabel,
    required this.onTap,
  });

  final String image;
  final IconData icon;
  final String title;
  final String desc;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  State<FeatureOverlapCard> createState() => _FeatureOverlapCardState();
}

class _FeatureOverlapCardState extends State<FeatureOverlapCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) => MouseRegion(
        onEnter: (final _) => setState(() => _isHovered = true),
        onExit: (final _) => setState(() => _isHovered = false),
        child: TactilePress(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: _isHovered
                ? (Matrix4.identity()..translate(0.0, -4.0))
                : Matrix4.identity(),
            padding:
                EdgeInsets.all(context.responsive(mobile: 16, desktop: 20)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.08),
                  blurRadius: _isHovered ? 28 : 20,
                  offset: Offset(0, _isHovered ? 14 : 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Referans tasarımdaki gibi: küçük görsel solda, başlık
                // yanında — dekoratif tek başına bir ikon yerine.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        children: [
                          Image.network(
                            widget.image,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorBuilder: (final c, final e, final s) =>
                                Container(
                                    width: 52,
                                    height: 52,
                                    color: AppColors.secondary),
                          ),
                          Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            color: Colors.black.withOpacity(0.18),
                            child: Icon(widget.icon,
                                color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(widget.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: context.bodySize,
                                color: AppColors.textPrimary)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(widget.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: context.captionSize,
                        height: 1.4)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: widget.onTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(widget.buttonLabel,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

/// Kapı kartlarındaki ince yörünge çizgisi + nokta kümesi dokusu. Sabit bir
/// [CustomPainter] — [paint] doğrudan kendi [Size]'ını alır, bir üst
/// widget'tan constraints SORMAZ. Bu yüzden [GatewayCard]'ın masaüstünde
/// sarıldığı [IntrinsicHeight] ile çakışmaz (bkz. [TactilePress] geçmişi:
/// aynı sebepten LayoutBuilder oradan tamamen kaldırıldı).
class _GatewayMotifPainter extends CustomPainter {
  const _GatewayMotifPainter({required this.accent});

  final Color accent;

  @override
  void paint(final Canvas canvas, final Size size) {
    final arcPaint = Paint()
      ..color = accent.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.12, size.height * 0.16),
        radius: 30,
      ),
      math.pi * 0.1,
      math.pi * 1.4,
      false,
      arcPaint,
    );

    final dotPaint = Paint()..color = accent.withOpacity(0.26);
    const dots = [
      (dx: 0.86, dy: 0.18, r: 3.2),
      (dx: 0.93, dy: 0.30, r: 2.0),
      (dx: 0.80, dy: 0.10, r: 1.6),
    ];
    for (final d in dots) {
      canvas.drawCircle(
          Offset(size.width * d.dx, size.height * d.dy), d.r, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant final _GatewayMotifPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

class RoomCard extends StatefulWidget {
  final String title;
  final String img;
  final String sub;
  final VoidCallback onTap;

  const RoomCard({
    required this.title,
    required this.img,
    required this.sub,
    required this.onTap,
  });

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: context.wp(context.isMobile ? 70 : 25),
          margin: const EdgeInsets.only(right: 20),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -6.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.borderRadius(2)),
            // "Havada süzülen" 3B his: katmanlı, dikey ofsetli gölgeler.
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.10 : 0.05),
                blurRadius: _isHovered ? 8 : 5,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.24 : 0.10),
                blurRadius: _isHovered ? 30 : 16,
                offset: Offset(0, _isHovered ? 20 : 12),
                spreadRadius: -4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.borderRadius(2)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: Image.network(widget.img, fit: BoxFit.cover),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.75),
                          Colors.transparent
                        ]),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.sub,
                          style: AppTextStyles.microLabel(
                              color: AppColors.accentLight,
                              letterSpacing: 1.4,
                              fontSize: 10)),
                      Text(widget.title,
                          style: TextStyle(
                              fontFamily: 'Fraunces',
                              color: Colors.white,
                              fontSize: context.h3Size,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      AnimatedOpacity(
                        opacity: _isHovered ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(context.l10n.viewButton,
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12)),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded,
                                  size: 14, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
