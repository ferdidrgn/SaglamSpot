import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/cart_provider.dart';

/// Sepet ekranı — gerçek bir ödeme akışı yok. Müşteri beğendiği ürünleri
/// buraya ekler, ardından tek bir mesajla mağazadan hepsi hakkında bilgi
/// ister (mevcut "ara/WhatsApp'tan sor" iş modeliyle uyumlu).
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  void _sendCartToWhatsApp(final List<CartItem> items) {
    final buffer = StringBuffer('Merhaba, şu ürünler hakkında bilgi almak istiyorum:\n\n');
    for (final item in items) {
      buffer.write('• ${item.product.name}');
      if (item.quantity > 1) buffer.write(' (x${item.quantity})');
      buffer.write(' — ${item.subtotal.toStringAsFixed(0)}₺\n');
    }
    final total = items.fold<double>(0, (final sum, final item) => sum + item.subtotal);
    buffer.write('\nToplam: ${total.toStringAsFixed(0)}₺');
    SaglamSpotCommunication.launchWhatsApp(message: buffer.toString());
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: !kIsWeb ? const MobileBottomNav() : null,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: items.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: items.length,
                      separatorBuilder: (final _, final __) => const SizedBox(height: 12),
                      itemBuilder: (final context, final index) =>
                          _CartItemCard(item: items[index]),
                    ),
            ),
            if (items.isNotEmpty) _buildFooter(context, ref, items, total),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(
          children: [
            Text(
              context.l10n.cartTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.mobileTextPrimary,
              ),
            ),
          ],
        ),
      );

  Widget _buildEmptyState(final BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.mobileCardBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_bag_outlined,
                    size: 40, color: AppColors.mobileMutedDark),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.cartEmptyTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mobileTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.cartEmptyDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.mobileTextSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => NavigationHandler.goToHome(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mobilePrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(context.l10n.storeHeroCta,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );

  Widget _buildFooter(final BuildContext context, final WidgetRef ref,
      final List<CartItem> items, final double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.cartTotalLabel,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.mobileTextSecondary),
              ),
              Text(
                '${total.toStringAsFixed(0)}₺',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.mobileTextPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _sendCartToWhatsApp(items),
              icon: const Icon(Icons.chat_bubble_rounded, size: 18),
              label: Text(context.l10n.cartWhatsappCta,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mobilePrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  final CartItem item;

  const _CartItemCard({required this.item});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final product = item.product;
    final notifier = ref.read(cartProvider.notifier);

    return GestureDetector(
      onTap: () => NavigationHandler.goToProduct(
        context: context,
        productId: product.id,
        productSlug: product.name.toSlug(),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.mobileBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OptimizedCachedImage(
              imageUrl: product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '',
              width: 72,
              height: 72,
              borderRadius: 14,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.mobileTextPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(0)}₺',
                    style: const TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.w900, color: AppColors.mobilePrimary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove_rounded,
                        onTap: () => notifier.decrement(product.id),
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add_rounded,
                        onTap: () => notifier.increment(product.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => notifier.remove(product.id),
              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.mobileMutedDark),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.mobileCardBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: AppColors.mobileTextPrimary),
        ),
      );
}
