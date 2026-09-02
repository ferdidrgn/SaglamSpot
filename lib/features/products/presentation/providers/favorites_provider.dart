import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/favorite_notification_sync.dart';
import '../../domain/entites/product.dart';

/// Favori (beğenilen) ürünler — SEPETTEN tamamen bağımsız bir liste.
/// Sepet "bunu satın almak/sormak istiyorum" anlamına gelirken, favori
/// sadece "bunu beğendim, sonra tekrar bakmak istiyorum" demek — ikisi
/// karıştırılmamalı (bkz. product_detail_page.dart'taki ayrı kalp/sepet
/// düğmeleri). cartProvider ile aynı kurulan desen: in-memory, oturum
/// boyunca yaşar.
class FavoritesNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() => [];

  bool contains(final String productId) =>
      state.any((final p) => p.id == productId);

  void add(final Product product) {
    if (contains(product.id)) return;
    state = [product, ...state];
    _sync();
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
  // notifyPriceDrop), bu cihazın hangi ürünleri favorilediği Firestore'a
  // best-effort yazılır — UI state değişikliğini bloklamaz.
  void _sync() =>
      FavoriteNotificationSync.sync(state.map((final p) => p.id).toList());
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<Product>>(FavoritesNotifier.new);

final favoritesCountProvider =
    Provider<int>((final ref) => ref.watch(favoritesProvider).length);
