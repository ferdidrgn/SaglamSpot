import 'package:flutter/material.dart';
import '../ads_remote_config.dart';
import 'web_ad_product_card.dart';

/// Ürün ızgarasına gömülen, ürün kartlarıyla aynı çerçeveye sahip "doğal"
/// reklam kartı — web derlemesi: her zaman AdSense.
/// [ReactiveAdWrapper] ile sarılı — RemoteConfig kill-switch kapalıysa
/// hiçbir şey göstermez.
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({super.key});

  @override
  Widget build(final BuildContext context) =>
      const ReactiveAdWrapper(child: WebAdProductCard());
}
