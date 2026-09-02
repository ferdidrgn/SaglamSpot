import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../util/comminucation_actions.dart';
import 'design_system/hud_corner_frame.dart';
import 'google_maps_embed.dart';

/// Canlı Google Haritası + gerçek zamanlı "Açık/Kapalı" rozeti + çalışma
/// saatleri + iletişim aksiyonları içeren, animasyonlu bir "işletme
/// künyesi" bloğu. Ana sayfa, Hakkımızda ve SSS sayfaları arasında paylaşılır
/// — hepsi AYNI gerçek zamanlı veriyi (SaglamSpotCommunication) gösterir,
/// tek yerden bakımı yapılır.
class BusinessInfoShowcase extends StatefulWidget {
  const BusinessInfoShowcase({super.key});

  @override
  State<BusinessInfoShowcase> createState() => _BusinessInfoShowcaseState();
}

class _BusinessInfoShowcaseState extends State<BusinessInfoShowcase> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Açık/Kapalı rozeti gerçek saate bağlı — sayfa açık kalırken saat
    // dönüp durum değişirse (ör. 22:00'yi geçince) UI kendiliğinden
    // güncellensin diye her dakika bir kez yeniden çiziliyor.
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
    final mapHeight =
        context.responsive(mobile: 240.0, tablet: 340.0, desktop: 440.0);

    final mapCard = HudCornerFrame(
      armLength: 22,
      inset: 10,
      color: AppColors.accent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.borderRadius(1.4)),
        child: SizedBox(
          height: mapHeight,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: GoogleMapsEmbed(
                  latitude: SaglamSpotCommunication.placeLatitude,
                  longitude: SaglamSpotCommunication.placeLongitude,
                ),
              ),
              Positioned(
                  left: 14, top: 14, child: _LiveOpenBadge(isOpen: isOpen)),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Material(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: SaglamSpotCommunication.openStoreLocation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.travel_explore_rounded,
                                size: 15, color: Color(0xFF1A1A1A)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(context.l10n.viewOnGoogleMapsButton,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1A1A))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.visitUsEyebrow,
            style: AppTextStyles.microLabel(
                color: AppColors.accentLight,
                letterSpacing: 2,
                fontSize: context.captionSize)),
        const SizedBox(height: 12),
        Text(context.l10n.visitUsHeading,
            style: TextStyle(
                fontFamily: 'Fraunces',
                color: Colors.white,
                fontSize: context.h2Size,
                fontWeight: FontWeight.w600,
                height: 1.2)),
        const SizedBox(height: 14),
        Text(
          SaglamSpotCommunication.workingHours.replaceAll('\n', '   ·   '),
          style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: context.bodySize,
              height: 1.5),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: SaglamSpotCommunication.launchWhatsApp,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: const Text('WhatsApp'),
            ),
            OutlinedButton.icon(
              onPressed: SaglamSpotCommunication.makeCall,
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              icon: const Icon(Icons.call_outlined, size: 16),
              label: Text(SaglamSpotCommunication.displayPhone),
            ),
            OutlinedButton.icon(
              onPressed: SaglamSpotCommunication.openStoreLocation,
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              icon: const Icon(Icons.north_east, size: 16),
              label: Text(context.l10n.directionsButton),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _visitInfoRow(
                  Icons.local_shipping_outlined,
                  context.l10n.freeDeliveryLabel,
                  SaglamSpotCommunication.freeDeliveryZones.join(', ')),
              const SizedBox(height: 16),
              _visitInfoRow(
                  Icons.directions_bus_outlined,
                  context.l10n.busLinesLabel,
                  SaglamSpotCommunication.getBusLines()
                      .entries
                      .map((final e) => '${e.key}: ${e.value.join(', ')}')
                      .join('\n')),
            ],
          ),
        ),
      ],
    );

    return Container(
      margin: context.sectionPadding,
      padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 48)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.borderRadius(2)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: _FloatingMotifLayer()),
          context.isMobile
              ? Column(
                  children: [mapCard, const SizedBox(height: 28), infoColumn])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: mapCard),
                    const SizedBox(width: 40),
                    Expanded(flex: 5, child: infoColumn),
                  ],
                ),
        ],
      ),
    );
  }
}

Widget _visitInfoRow(
        final IconData icon, final String title, final String detail) =>
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accentLight, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 4),
              Text(detail,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      height: 1.4)),
            ],
          ),
        ),
      ],
    );

/// Harita üzerine binen, canlı "Açık/Kapalı" rozeti — gerçek zamana göre.
class _LiveOpenBadge extends StatelessWidget {
  const _LiveOpenBadge({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              isOpen ? context.l10n.openNowLabel : context.l10n.closedNowLabel,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: isOpen
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFC62828)),
            ),
            const SizedBox(width: 6),
            Text('· ${SaglamSpotCommunication.todayHoursLabel}',
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5A5A5A),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

/// Panelin arka planında usulca süzülen, çok düşük opaklıklı mobilya
/// ikonları — "işletme künyesi"ne dekoratif bir canlılık katan, dokunulmaz
/// (IgnorePointer) bir animasyon katmanı.
class _FloatingMotifLayer extends StatefulWidget {
  const _FloatingMotifLayer();

  @override
  State<_FloatingMotifLayer> createState() => _FloatingMotifLayerState();
}

class _FloatingMotifLayerState extends State<_FloatingMotifLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  static const _motifs = [
    (icon: Icons.auto_awesome, size: 46.0, phase: 0.0, top: 0.06, right: 0.08),
    (
      icon: Icons.weekend_rounded,
      size: 96.0,
      phase: 0.33,
      top: 0.62,
      right: -0.03
    ),
    (
      icon: Icons.chair_rounded,
      size: 64.0,
      phase: 0.66,
      top: 0.12,
      right: 0.42
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ExcludeSemantics(
        child: IgnorePointer(
          child: ClipRect(
            child: LayoutBuilder(
              builder: (final context, final constraints) => AnimatedBuilder(
                animation: _controller,
                builder: (final context, final _) {
                  final t = _controller.value;
                  return Stack(
                    children: [
                      for (final m in _motifs)
                        Positioned(
                          top: constraints.maxHeight * m.top +
                              math.sin((t + m.phase) * 2 * math.pi) * 12,
                          right: constraints.maxWidth * m.right,
                          child: Transform.rotate(
                            angle: math.sin((t + m.phase) * 2 * math.pi) * 0.09,
                            child: Icon(m.icon,
                                size: m.size,
                                color: Colors.white.withOpacity(0.05)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
}
