import '../../../products/domain/entites/product.dart';

/// Sepetteki tek bir satır — ürün + adet. Gerçek bir ödeme/checkout akışı
/// yok; bu sepet bir "istek listesi" gibi çalışır ve tek bir WhatsApp
/// mesajıyla toplu olarak sorulur (bkz. CartPage).
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;

  CartItem copyWith({final int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}
