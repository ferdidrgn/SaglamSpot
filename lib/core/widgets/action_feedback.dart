import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/cart/domain/entities/cart_item.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import '../../features/products/domain/entites/product.dart';
import '../../features/products/presentation/providers/favorites_provider.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';

/// Geri alınabilir işlemler için yüzen bildirim. Haptik tek cevap değildir;
/// metin ve "Geri al" her zaman görünür.
void showUndoSnackBar({
  required final BuildContext context,
  required final String message,
  required final VoidCallback onUndo,
}) {
  HapticFeedback.mediumImpact();
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: context.l10n.undo,
        onPressed: onUndo,
      ),
    ));
}

void removeFavoriteWithUndo(
  final BuildContext context,
  final WidgetRef ref,
  final Product product,
) {
  ref.read(favoritesProvider.notifier).remove(product.id);
  showUndoSnackBar(
    context: context,
    message: context.l10n.removedFromFavorites,
    onUndo: () => ref.read(favoritesProvider.notifier).add(product),
  );
}

void removeCartItemWithUndo(
  final BuildContext context,
  final WidgetRef ref,
  final CartItem item,
) {
  final quantity = item.quantity;
  ref.read(cartProvider.notifier).remove(item.product.id);
  showUndoSnackBar(
    context: context,
    message: context.l10n.cartItemRemoved,
    onUndo: () {
      final notifier = ref.read(cartProvider.notifier);
      notifier.add(item.product);
      if (quantity > 1) notifier.setQuantity(item.product.id, quantity);
    },
  );
}

/// Kaydedilmemiş formdan çıkış. `true` = çık.
Future<bool> confirmDiscardChanges(final BuildContext context) async {
  final leave = await showDialog<bool>(
    context: context,
    builder: (final ctx) => AlertDialog(
      title: Text(ctx.l10n.unsavedChangesTitle),
      content: Text(ctx.l10n.unsavedChangesBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(ctx.l10n.keepEditing),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(ctx.l10n.discardChanges,
              style: TextStyle(color: AppColors.error)),
        ),
      ],
    ),
  );
  return leave ?? false;
}
