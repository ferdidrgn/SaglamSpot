import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/enum/enums.dart';
import '../services/category_watch_cache.dart';
import '../services/category_watch_sync.dart';

/// "Yeni Ürün Bildirimi" — kullanıcının takip ettiği kategoriler. Sadece
/// native mobilde kullanılır (bkz. category_watch_sync.dart'taki web/push
/// notu); Ayarlar sayfasındaki kontrolün kendisi zaten `!kIsWeb` ile
/// gizlenir, bu provider platformdan bağımsız (toggle çağrılmazsa hiç
/// etkisi olmaz).
class CategoryWatchNotifier extends Notifier<Set<ProductCategory>> {
  @override
  Set<ProductCategory> build() => CategoryWatchCache.saved;

  void toggle(final ProductCategory category) {
    final next = {...state};
    if (!next.add(category)) next.remove(category);
    state = next;
    CategoryWatchCache.setSaved(next);
    CategoryWatchSync.sync(next);
  }

  bool isWatching(final ProductCategory category) => state.contains(category);
}

final categoryWatchProvider =
    NotifierProvider<CategoryWatchNotifier, Set<ProductCategory>>(
        CategoryWatchNotifier.new);
