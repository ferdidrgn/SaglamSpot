// NativeAdCard artık burada değil — platforma göre koşullu dışa aktarılan
// ayrı bir dosyada (bkz. native_ad_card.dart). Bu re-export, mevcut
// `import 'ad_grid_helper.dart';` kullanan tüm çağıranların değişmeden
// çalışmasını sağlıyor.
export 'native_ad_card.dart';

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
