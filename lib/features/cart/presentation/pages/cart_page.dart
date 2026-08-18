import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/services/deeplink/deeplink_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../features/products/domain/entites/product.dart';
import '../../../../features/products/presentation/providers/recently_viewed_provider.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/cart_provider.dart';

/// Sepet ekranı — gerçek bir ödeme akışı yok. Müşteri beğendiği ürünleri
/// buraya ekler, hangilerini soracağını onay kutularıyla seçer, ardından
/// tek bir mesajla mağazadan hepsi hakkında bilgi ister (mevcut
/// "ara/WhatsApp'tan sor" iş modeliyle uyumlu). "Son Görüntülenenler"
/// bölümü ürün detayına her girişte otomatik güncellenen ayrı bir
/// provider'dan (recentlyViewedProvider) beslenir.
class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  // Boş küme = hepsi seçili (varsayılan). Sepete yeni eklenen bir ürün
  // otomatik olarak seçili başlar — burada ayrıca bir şey yapmaya gerek
  // yok, sadece "işareti kaldırılanlar" tutuluyor.
  final Set<String> _uncheckedIds = {};

  bool _isSelected(final String productId) => !_uncheckedIds.contains(productId);

  void _toggle(final String productId) {
    setState(() {
      if (_uncheckedIds.contains(productId)) {
        _uncheckedIds.remove(productId);
      } else {
        _uncheckedIds.add(productId);
      }
    });
  }

  Future<void> _confirmClearCart(final List<CartItem> items) async {
    if (items.isEmpty) return;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.cartTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(context.l10n.cartEmptyDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(context.l10n.clear),
          ),
        ],
      ),
    );
    if (confirm == true) ref.read(cartProvider.notifier).clear();
  }

  void _sendCartToWhatsApp(final List<CartItem> items) {
    final buffer = StringBuffer('Merhaba, şu ürünler hakkında bilgi almak istiyorum:\n\n');
    for (final item in items) {
      final String link =
          FurnitureShareService.generateProductUrl(item.product.id, item.product.name);
      buffer.write('• ${item.product.name}');
      if (item.quantity > 1) buffer.write(' (x${item.quantity})');
      buffer.write(' — ${item.subtotal.toStringAsFixed(0)}₺\n');
      buffer.write('  $link\n\n');
    }
    final total = items.fold<double>(0, (final sum, final item) => sum + item.subtotal);
    buffer.write('Toplam: ${total.toStringAsFixed(0)}₺\n\n');
    buffer.write('Tüm ürünler: ${FurnitureShareService.storeUrl}');
    SaglamSpotCommunication.launchWhatsApp(message: buffer.toString());
  }

  @override
  Widget build(final BuildContext context) {
    final items = ref.watch(cartProvider);
    final selectedItems = items.where((final i) => _isSelected(i.product.id)).toList();
    final double selectedTotal =
        selectedItems.fold<double>(0, (final sum, final item) => sum + item.subtotal);
    final int selectedCount =
        selectedItems.fold<int>(0, (final sum, final item) => sum + item.quantity);
    final recentlyViewed = ref.watch(recentlyViewedProvider);

    final scaffold = Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: !kIsWeb ? const MobileBottomNav() : null,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, items),
            Expanded(
              child: items.isEmpty
                  ? _buildEmptyState(context)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      children: [
                        for (final item in items) ...[
                          _CartItemCard(
                            item: item,
                            isSelected: _isSelected(item.product.id),
                            onToggleSelected: () => _toggle(item.product.id),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (recentlyViewed.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _RecentlyViewedSection(products: recentlyViewed),
                        ],
                      ],
                    ),
            ),
            if (items.isNotEmpty)
              _buildFooter(context, selectedItems, selectedCount, selectedTotal),
          ],
        ),
      ),
    );

    return kIsWeb ? scaffold : BackToHomeGuard(child: scaffold);
  }

  Widget _buildHeader(final BuildContext context, final List<CartItem> items) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
        child: Row(
          children: [
            IconButton(
              onPressed: () => NavigationHandler.smartGoBack(context),
              icon: Icon(Icons.arrow_back_rounded, color: AppColors.mobileTextPrimary),
            ),
            Expanded(
              child: Text(
                context.l10n.cartTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mobileTextPrimary,
                ),
              ),
            ),
            if (items.isNotEmpty)
              IconButton(
                onPressed: () => _confirmClearCart(items),
                icon: Icon(Icons.delete_outline_rounded, color: AppColors.mobileTextSecondary),
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
                child: Icon(Icons.shopping_bag_outlined,
                    size: 40, color: AppColors.mobileMutedDark),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.cartEmptyTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mobileTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.cartEmptyDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
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
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: Text(context.l10n.storeHeroCta,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      );

  Widget _buildFooter(final BuildContext context, final List<CartItem> selectedItems,
      final int selectedCount, final double selectedTotal) {
    final bool hasSelection = selectedItems.isNotEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.mobileSurface,
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
                context.l10n.cartItemsCount(selectedCount),
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.mobileTextSecondary),
              ),
              Text(
                '${selectedTotal.toStringAsFixed(0)}₺',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.mobileTextPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: hasSelection ? () => _sendCartToWhatsApp(selectedItems) : null,
              icon: const Icon(Icons.chat_bubble_rounded, size: 18),
              label: Text(context.l10n.cartWhatsappCta,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mobilePrimary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.mobileMutedDark,
                shape: const StadiumBorder(),
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
  final bool isSelected;
  final VoidCallback onToggleSelected;

  const _CartItemCard({
    required this.item,
    required this.isSelected,
    required this.onToggleSelected,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final product = item.product;
    final notifier = ref.read(cartProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.mobileSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? AppColors.mobilePrimary.withOpacity(0.4) : AppColors.mobileBorder,
        ),
        boxShadow: [
          BoxShadow(
              color: AppColors.mobileTextPrimary.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onToggleSelected,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.mobilePrimary : AppColors.mobileSurface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected ? AppColors.mobilePrimary : AppColors.mobileMutedDark,
                    width: 1.6,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => NavigationHandler.goToProduct(
              context: context,
              productId: product.id,
              productSlug: product.name.toSlug(),
            ),
            child: OptimizedCachedImage(
              imageUrl: product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '',
              width: 64,
              height: 64,
              borderRadius: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => NavigationHandler.goToProduct(
                context: context,
                productId: product.id,
                productSlug: product.name.toSlug(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.mobileTextPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(0)}₺',
                    style: TextStyle(
                        fontSize: 14.5, fontWeight: FontWeight.w900, color: AppColors.mobilePrimary),
                  ),
                  const SizedBox(height: 8),
                  _QtyStepper(
                    quantity: item.quantity,
                    onDecrement: () => notifier.decrement(product.id),
                    onIncrement: () => notifier.increment(product.id),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => notifier.remove(product.id),
            icon: Icon(Icons.close_rounded, size: 18, color: AppColors.mobileMutedDark),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

/// Referans tasarımdaki tek parça, hap şeklinde adet seçici ("- 1 +").
class _QtyStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QtyStepper(
      {required this.quantity, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(final BuildContext context) => Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.mobileCardBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _stepIcon(Icons.remove_rounded, onDecrement),
            SizedBox(
              width: 26,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: AppColors.mobileTextPrimary),
              ),
            ),
            _stepIcon(Icons.add_rounded, onIncrement),
          ],
        ),
      );

  Widget _stepIcon(final IconData icon, final VoidCallback onTap) => InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 22,
          height: 22,
          child: Icon(icon, size: 14, color: AppColors.mobileTextPrimary),
        ),
      );
}

class _RecentlyViewedSection extends StatelessWidget {
  final List<Product> products;

  const _RecentlyViewedSection({required this.products});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.recentlyViewedTitle,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.mobileTextPrimary),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (final _, final __) => const SizedBox(width: 10),
            itemBuilder: (final context, final index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => NavigationHandler.goToProduct(
                  context: context,
                  productId: product.id,
                  productSlug: product.name.toSlug(),
                ),
                child: Container(
                  width: 110,
                  decoration: BoxDecoration(
                    color: AppColors.mobileSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.mobileBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: OptimizedCachedImage(
                              imageUrl: product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '',
                              width: 110,
                              height: 90,
                              borderRadius: 0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (product.isSold)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  context.l10n.sold,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${product.price.toStringAsFixed(0)}₺',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.mobilePrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
