import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/domain/entites/product.dart';
import '../../domain/entities/cart_item.dart';

/// Sepet durumunu (in-memory) yöneten Notifier. Gerçek ödeme yok — bu
/// sepet bir istek listesi olarak çalışır, mağaza WhatsApp'tan toplu
/// olarak bilgilendirilir.
class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  bool contains(final String productId) =>
      state.any((final item) => item.product.id == productId);

  void add(final Product product) {
    if (contains(product.id)) return;
    state = [...state, CartItem(product: product)];
  }

  void remove(final String productId) {
    state = state.where((final item) => item.product.id != productId).toList();
  }

  void toggle(final Product product) {
    if (contains(product.id)) {
      remove(product.id);
    } else {
      add(product);
    }
  }

  void setQuantity(final String productId, final int quantity) {
    if (quantity < 1) {
      remove(productId);
      return;
    }
    state = [
      for (final item in state)
        if (item.product.id == productId) item.copyWith(quantity: quantity) else item,
    ];
  }

  void increment(final String productId) {
    final item = state.firstWhere((final i) => i.product.id == productId);
    setQuantity(productId, item.quantity + 1);
  }

  void decrement(final String productId) {
    final item = state.firstWhere((final i) => i.product.id == productId);
    setQuantity(productId, item.quantity - 1);
  }

  void clear() => state = [];
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

final cartItemCountProvider = Provider<int>((final ref) =>
    ref.watch(cartProvider).fold<int>(0, (final sum, final item) => sum + item.quantity));

final cartTotalProvider = Provider<double>((final ref) => ref
    .watch(cartProvider)
    .fold<double>(0, (final sum, final item) => sum + item.subtotal));
