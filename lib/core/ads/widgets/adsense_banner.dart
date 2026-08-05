import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../common/enum/enums.dart';
import '../ads_manager.dart';
import '../ads_remote_config.dart';
import 'real_adsense_ad.dart';

/// Sayfa içine yerleştirilebilen, reklamlar kapatıldığında (RemoteConfig)
/// otomatik gizlenen GERÇEK Google AdSense reklam alanı.
///
/// [type] -> AdManager üzerinden doğru slot ID'sini otomatik seçer:
///   AdUnitType.display    -> Klasik görüntülü reklam (hero altı, sayfa arası)
///   AdUnitType.inArticle  -> İçerik akışı arasına gömülü, "fluid" reklam
///   AdUnitType.multiplex  -> "Benzer ürünler" tarzı çoklu kart reklam bloğu
class AdsenseBanner extends StatelessWidget {
  final AdUnitType type;
  final double height;

  const AdsenseBanner({super.key, required this.type, this.height = 280});

  @override
  Widget build(final BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final slotId = AdManager.getAdUnitId(type);
    if (slotId.isEmpty) return const SizedBox.shrink();

    return ReactiveAdWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: RealAdsenseAd(
          slotId: slotId,
          format: _formatFor(type),
          layout: _layoutFor(type),
          height: height,
        ),
      ),
    );
  }

  String _formatFor(final AdUnitType type) {
    switch (type) {
      case AdUnitType.inArticle:
      case AdUnitType.multiplex:
        return 'fluid';
      case AdUnitType.display:
      default:
        return 'auto';
    }
  }

  String? _layoutFor(final AdUnitType type) {
    switch (type) {
      case AdUnitType.inArticle:
        return 'in-article';
      case AdUnitType.multiplex:
        return null; // multiplex kendi otomatik yerleşimini kullanır
      default:
        return null;
    }
  }
}
