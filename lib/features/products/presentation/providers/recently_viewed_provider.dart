import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entites/product.dart';

/// Son görüntülenen ürünleri (in-memory, en fazla 10 tane, en yeni önde)
/// tutar — sepet sayfasındaki "Son Görüntülenenler" bölümünü besler.
class RecentlyViewedNotifier extends Notifier<List<Product>> {
  static const int _maxItems = 10;

  @override
  List<Product> build() => [];

  void track(final Product product) {
    final withoutDuplicate = state.where((final p) => p.id != product.id).toList();
    state = [product, ...withoutDuplicate].take(_maxItems).toList();
  }
}

final recentlyViewedProvider =
    NotifierProvider<RecentlyViewedNotifier, List<Product>>(RecentlyViewedNotifier.new);
