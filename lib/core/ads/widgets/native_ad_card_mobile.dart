import 'package:flutter/material.dart';
import 'native_ad_product_card.dart';

/// Ürün ızgarasına gömülen, ürün kartlarıyla aynı çerçeveye sahip "doğal"
/// reklam kartı — mobil (io) derlemesi: her zaman AdMob native.
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({super.key});

  @override
  Widget build(final BuildContext context) => const NativeAdProductCard();
}
