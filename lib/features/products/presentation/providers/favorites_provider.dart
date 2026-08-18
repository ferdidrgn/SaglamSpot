import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }

  void remove(final String productId) {
    state = state.where((final p) => p.id != productId).toList();
  }

  void toggle(final Product product) {
    if (contains(product.id)) {
      remove(product.id);
    } else {
      add(product);
    }
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<Product>>(FavoritesNotifier.new);

final favoritesCountProvider = Provider<int>((final ref) => ref.watch(favoritesProvider).length);
