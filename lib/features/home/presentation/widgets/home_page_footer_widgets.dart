import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/util/comminucation_actions.dart';

/// Ana sayfanın ("HomePage", web) footer'ında kullanılan küçük widget'lar —
/// eskiden home_page_web.dart'ın sonunda duruyordu, okunabilirlik için ayrı
/// dosyaya taşındı. Davranış/görünüm AYNI kaldı.

/// Fabrika/depo levhası hissi veren, ince bir "tehlike şeridi" ayraç —
/// footer ile içerik arasındaki sınırı endüstriyel bir imzayla çizer.
/// Statik desen: bir kez çizilir, animasyon YOK.
class HazardStripeBar extends StatelessWidget {
  const HazardStripeBar();

  @override
  Widget build(final BuildContext context) => SizedBox(
        height: 6,
        width: double.infinity,
        child: CustomPaint(painter: _HazardStripePainter()),
      );
}

class _HazardStripePainter extends CustomPainter {
  @override
  void paint(final Canvas canvas, final Size size) {
    const stripeWidth = 18.0;
    final darkPaint = Paint()..color = const Color(0xFF1A120C);
    final lightPaint = Paint()..color = AppColors.accentLight;
    canvas.drawRect(Offset.zero & size, darkPaint);

    final path = Path();
    for (double x = -size.height; x < size.width; x += stripeWidth * 2) {
      path
        ..moveTo(x, size.height)
        ..lineTo(x + size.height, 0)
        ..lineTo(x + size.height + stripeWidth, 0)
        ..lineTo(x + stripeWidth, size.height)
        ..close();
    }
    canvas.drawPath(path, lightPaint);
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) => false;
}

/// CANLI çalışma-saati/konum kartı — e-posta bülten formunun yerini aldı.
/// Gerçek adres + gerçek saatlere göre "Açık şu an / Kapalı" rozetini her
/// dakika yeniden hesaplar (gerçek zamana bağlı, dinamik).
class FooterLocationCard extends StatefulWidget {
  const FooterLocationCard();

  @override
  State<FooterLocationCard> createState() => _FooterLocationCardState();
}

class _FooterLocationCardState extends State<FooterLocationCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Açık/kapalı rozeti dakikada bir kendini günceller.
    _timer = Timer.periodic(const Duration(minutes: 1), (final _) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isOpen = SaglamSpotCommunication.isOpenNow;
    final crossAlign =
        context.isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text(context.l10n.locationAndHoursLabel,
            style: AppTextStyles.microLabel(
                fontSize: 11.5,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOpen
                          ? const Color(0xFF6FCF97)
                          : const Color(0xFFE57373),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    isOpen
                        ? context.l10n.openNowLabel
                        : context.l10n.closedNowLabel,
                    style: TextStyle(
                        color: isOpen
                            ? const Color(0xFF9BE3B8)
                            : const Color(0xFFEDA0A0),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                        context.l10n.todayHoursPrefix(
                            SaglamSpotCommunication.todayHoursLabel),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: SaglamSpotCommunication.openStoreLocation,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 16, color: AppColors.accentLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(context.l10n.storeAddress,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 12,
                              height: 1.4)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: SaglamSpotCommunication.openStoreLocation,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.18)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.map_outlined, size: 16),
                  label: Text(context.l10n.openInMapsButton,
                      style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FooterSocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const FooterSocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.white.withOpacity(0.08),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, color: Colors.white70, size: 16),
          ),
        ),
      );
}
