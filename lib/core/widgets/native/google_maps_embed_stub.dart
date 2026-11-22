import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/extentions/app_context_ui_extension.dart';
import '../../theme/app_colors.dart';

/// Mobil (Android/iOS) derlemesinde gömülü `<iframe>` yok — bunun yerine
/// tıklanınca gerçek Google Haritalar uygulamasını/sayfasını açan, aynı
/// konumu gösteren şık bir kart döner.
class GoogleMapsEmbed extends StatelessWidget {
  const GoogleMapsEmbed({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 16,
    this.borderRadius = 0,
  });

  final double latitude;
  final double longitude;
  final int zoom;
  final double borderRadius;

  Future<void> _open() async {
    final uri =
        Uri.parse('https://www.google.com/maps?q=$latitude,$longitude&z=$zoom');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Sessizce yut — kritik olmayan bir yönlendirme aksiyonu.
    }
  }

  @override
  Widget build(final BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: AppColors.secondary,
          child: InkWell(
            onTap: _open,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_rounded,
                      size: 40, color: AppColors.accentDark),
                  const SizedBox(height: 10),
                  Text(context.l10n.openInMapsButton,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),
        ),
      );
}
