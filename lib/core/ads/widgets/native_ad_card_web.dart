import 'package:flutter/material.dart';
import 'web_ad_product_card.dart';

/// Ürün ızgarasına gömülen, ürün kartlarıyla aynı çerçeveye sahip "doğal"
/// reklam kartı — web derlemesi: her zaman AdSense.
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({super.key});

  @override
  Widget build(final BuildContext context) => const WebAdProductCard();
}
