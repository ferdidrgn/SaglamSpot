import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../shared/navigation/widgets/nav_handler.dart';

/// Sepet (WhatsApp istek listesi) için rozetli kısayol simgesi. Mobilde
/// artık kalıcı bir sekme değil — ana sayfa/keşfet başlıkları ve ürün
/// detayı gibi yerlerden buraya erişilir.
class CartIconButton extends ConsumerWidget {
  const CartIconButton({super.key, this.color});

  final Color? color;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final int count = ref.watch(cartItemCountProvider);
    final Color iconColor = color ?? AppColors.mobileTextPrimary;

    return IconButton(
      onPressed: () => NavigationHandler.goToCart(context),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: AppColors.mobileAccent,
        textColor: Colors.white,
        child: Icon(Icons.shopping_bag_outlined, color: iconColor),
      ),
    );
  }
}
