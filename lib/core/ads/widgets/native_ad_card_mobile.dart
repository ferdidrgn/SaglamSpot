import 'package:flutter/material.dart';
import '../ads_remote_config.dart';
import 'native_ad_product_card.dart';

/// Ürün ızgarasına gömülen, ürün kartlarıyla aynı çerçeveye sahip "doğal"
/// reklam kartı — mobil (io) derlemesi: her zaman AdMob native.
/// [ReactiveAdWrapper] ile sarılı — RemoteConfig kill-switch VEYA
/// `ads_removed` (bkz. ad_gate_provider.dart) kapalıysa hiçbir şey
/// yüklemez/göstermez.
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({super.key});

  @override
  Widget build(final BuildContext context) =>
      const ReactiveAdWrapper(child: NativeAdProductCard());
}
