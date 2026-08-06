import 'package:flutter/material.dart';
import '../../common/enum/enums.dart';
import '../../common/extentions/app_context_ui_extension.dart';
import '../ads_manager.dart';
import 'real_adsense_ad.dart';

/// Web ürün ızgaralarına/karusellerine gömülen, ürün kartlarıyla AYNI dış
/// çerçeveye (yuvarlak köşe 28, gölge) sahip AdSense reklam kartı.
/// "Sponsorlu" etiketiyle şeffaf.
class WebAdProductCard extends StatelessWidget {
  final double height;

  const WebAdProductCard({super.key, this.height = 320});

  @override
  Widget build(final BuildContext context) {
    final slotId = AdManager.getAdUnitId(AdUnitType.display);
    if (slotId.isEmpty) return const SizedBox.shrink();

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(right: 20, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: RealAdsenseAd(slotId: slotId, format: 'auto', height: height),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(context.l10n.sponsored,
                  style: TextStyle(
                      color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
