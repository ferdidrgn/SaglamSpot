import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// Mobil (native app) derlemesi: canlı bir web <iframe>'i göstermek yerine
/// (bu WebView gerektirir ve native harita uygulamasından daha ağırdır),
/// dokununca cihazın kendi harita uygulamasını açan zarif bir önizleme
/// kartı gösterir. [onOpenExternal] genelde
/// `SaglamSpotCommunication.openStoreLocation` olur.
class GoogleMapEmbed extends StatelessWidget {
  final double lat;
  final double lng;
  final String label;
  final double height;
  final double borderRadius;
  final VoidCallback? onOpenExternal;

  const GoogleMapEmbed({
    super.key,
    required this.lat,
    required this.lng,
    required this.label,
    this.height = 260,
    this.borderRadius = 24,
    this.onOpenExternal,
  });

  @override
  Widget build(final BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onOpenExternal,
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondary,
                  AppColors.secondaryVariant,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.map_rounded,
                    size: height * 0.5,
                    color: AppColors.textPrimary.withOpacity(0.08)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 34, color: AppColors.accentDark),
                    const SizedBox(height: 8),
                    Text(label,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('Haritada Aç',
                        style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentDark)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
