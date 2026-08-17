import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../domain/entites/product.dart';
import '../providers/favorites_provider.dart';

/// Favoriler sayfası — SEPETTEN bağımsız, sadece kalp ikonuyla işaretlenen
/// ürünlerin listesi (bkz. favorites_provider.dart). Gerçek bir sipariş
/// akışı yok; buradan ürün detayına gidip oradan sepete ekleyebilir veya
/// WhatsApp'tan sorabilirsiniz.
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    final scaffold = Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: !kIsWeb ? const MobileBottomNav() : null,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => NavigationHandler.smartGoBack(context),
                    icon: Icon(Icons.arrow_back_rounded, color: AppColors.mobileTextPrimary),
                  ),
                  Expanded(
                    child: Text(context.l10n.favoritesTitle,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.mobileTextPrimary)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: favorites.isEmpty
                  ? _buildEmptyState(context)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (final context, final index) =>
                          _FavoriteCard(product: favorites[index]),
                    ),
            ),
          ],
        ),
      ),
    );

    return kIsWeb ? scaffold : BackToHomeGuard(child: scaffold);
  }

  Widget _buildEmptyState(final BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(color: AppColors.mobileCardBg, shape: BoxShape.circle),
                child: Icon(Icons.favorite_border_rounded, size: 40, color: AppColors.mobileMutedDark),
              ),
              const SizedBox(height: 20),
              Text(context.l10n.favoritesEmptyTitle,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.mobileTextPrimary)),
              const SizedBox(height: 8),
              Text(context.l10n.favoritesEmptyDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.5, color: AppColors.mobileTextSecondary, height: 1.5)),
            ],
          ),
        ),
      );
}

class _FavoriteCard extends ConsumerWidget {
  final Product product;
  const _FavoriteCard({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) => GestureDetector(
        onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug(),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.mobileSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.mobileBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: OptimizedCachedImage(
                        imageUrl: product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '',
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (product.isSold)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(context.l10n.sold,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Material(
                        color: Colors.black.withOpacity(0.4),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => ref.read(favoritesProvider.notifier).remove(product.id),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.favorite_rounded, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.mobileTextPrimary)),
                    const SizedBox(height: 3),
                    Text('${product.price.toStringAsFixed(0)}₺',
                        style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: AppColors.mobilePrimary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
