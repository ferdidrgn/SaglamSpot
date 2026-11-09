import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/analytics_event_logger.dart';
import '../../../../core/services/favorite_ids_cache.dart';
import '../../../../core/services/favorite_notification_sync.dart';
import '../../domain/entites/product.dart';
import 'product_provider.dart';

/// Favori (beğenilen) ürünler — SEPETTEN tamamen bağımsız bir liste.
/// Sepet "bunu satın almak/sormak istiyorum" anlamına gelirken, favori
/// sadece "bunu beğendim, sonra tekrar bakmak istiyorum" demek — ikisi
/// karıştırılmamalı (bkz. product_detail_page.dart'taki ayrı kalp/sepet
/// düğmeleri). Bellekteki `state` (tam `Product` nesneleri — ürün adı/
/// fiyat/görsel favoriler sayfasında anında gösterilebilsin diye) oturum
/// boyunca yaşar, ama ID'ler `FavoriteIdsCache` ile cihazda kalıcıdır
/// (bkz. o dosyadaki not — bu önbellek olmadan Firestore'daki favori
/// bildirim eşleşmesi hiç temizlenmiyordu). Ürün kataloğu
/// (`productsProvider`) yüklenince persisted ID'ler gerçek `Product`
/// nesnelerine çözülüp state'e BİR KEZ yüklenir.
class FavoritesNotifier extends Notifier<List<Product>> {
  bool _hydratedFromCache = false;

  @override
  List<Product> build() {
    ref.listen(productsProvider, (final _, final next) {
      _hydrateFromCache(next.value);
    }, fireImmediately: true);
    return [];
  }

  void _hydrateFromCache(final List<Product>? products) {
    if (_hydratedFromCache || products == null) return;
    _hydratedFromCache = true;

    final savedIds = FavoriteIdsCache.saved;
    if (savedIds.isEmpty) return;

    final byId = {for (final p in products) p.id: p};
    final matched =
        savedIds.map((final id) => byId[id]).whereType<Product>().toList();
    if (matched.isNotEmpty) state = matched;

    // Önbellekteki ID'lerden biri artık yoksa (ör. ürün silindi) kırpılmış
    // gerçek hali Firestore'a da yansıt.
    if (matched.length != savedIds.length) _sync();
  }

  bool contains(final String productId) =>
      state.any((final p) => p.id == productId);

  void add(final Product product) {
    if (contains(product.id)) return;
    state = [product, ...state];
    _sync();
    // Admin > İstatistikler ekranındaki "favori" metriği BURADAN gelir —
    // sadece EKLEME anında (kaldırma sayılmaz), bkz. AnalyticsEventLogger.
    AnalyticsEventLogger.log(
      type: 'favorite',
      productId: product.id,
      category: product.category.name,
    );
  }

  void remove(final String productId) {
    state = state.where((final p) => p.id != productId).toList();
    _sync();
  }

  void toggle(final Product product) {
    if (contains(product.id)) {
      remove(product.id);
    } else {
      add(product);
    }
  }

  // Fiyat düşünce bildirim gönderebilmek için (bkz. functions/index.js →
  // notifyPriceDrop) ve admin kampanya segmenti için (bkz.
  // sendCampaignNotification → "favorited"), bu cihazın hangi ürünleri
  // favorilediği Firestore'a best-effort yazılır — UI state değişikliğini
  // bloklamaz. Aynı ID listesi cihazda da kalıcı tutulur (bkz.
  // FavoriteIdsCache'teki not) ki bir sonraki açılışta hem UI hem Firestore
  // doğru kalsın.
  void _sync() {
    final ids = state.map((final p) => p.id).toList();
    FavoriteIdsCache.setSaved(ids);
    FavoriteNotificationSync.sync(ids);
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<Product>>(FavoritesNotifier.new);

final favoritesCountProvider =
    Provider<int>((final ref) => ref.watch(favoritesProvider).length);
