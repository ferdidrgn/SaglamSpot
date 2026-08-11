import 'package:flutter/material.dart';
import '../../util/platform_checker.dart';
import 'native_ad_product_card.dart';
import 'web_ad_product_card.dart';

/// Ürün ızgaralarına reklam serpiştirme kuralı, tüm sayfalarda tek yerden:
/// liste kısaysa (aza yakınsa) her 5 üründe bir, uzunsa her 10 üründe bir
/// reklam gösterilir. Kısa listelerde bile en az bir reklam görünmesini
/// garantiler; uzun listelerde ise araya çok sık girip boğmaz.
///
/// Önceden bu mantık (dolgulu index + modulo) 4 farklı sayfada ayrı ayrı,
/// birbirinden bağımsız sabit sayılarla kopyalanmıştı — artık tek yerden
/// yönetiliyor.
int adFrequencyFor(final int itemCount) => itemCount < 20 ? 5 : 10;

/// Reklam kartlarıyla serpiştirilmiş toplam slot sayısı (GridView/SliverGrid
/// için "dolgulu" itemCount).
int paddedItemCountForAds(final int itemCount) {
  if (itemCount <= 0) return itemCount;
  final freq = adFrequencyFor(itemCount);
  return itemCount + (itemCount ~/ freq);
}

/// Dolgulu dizindeki [index] bir reklam yuvası mı?
bool isAdSlot(final int index, final int itemCount) {
  final freq = adFrequencyFor(itemCount);
  return index > 0 && (index + 1) % (freq + 1) == 0;
}

/// Reklam yuvası değilse, dolgulu [index]'in gerçek üründeki karşılığı.
int realIndexForAdGrid(final int index, final int itemCount) {
  final freq = adFrequencyFor(itemCount);
  return index - (index ~/ (freq + 1));
}

/// Platforma uygun, ürün kartıyla aynı çerçeveye sahip "doğal" reklam
/// kartı — web'de AdSense, mobil uygulamada AdMob native. Reklam
/// yüklenemezse (boş slot id, henüz yüklenmedi vb.) ilgili kart zaten
/// kendi içinde boş widget döner; burada platforma göre doğru olanı
/// seçmek yeterli.
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({super.key});

  @override
  Widget build(final BuildContext context) => PlatformChecker.isWeb
      ? const WebAdProductCard()
      : const NativeAdProductCard();
}
