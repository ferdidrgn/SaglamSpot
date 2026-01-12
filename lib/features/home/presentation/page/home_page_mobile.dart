import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../../core/widgets/gallery_section.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/add_product_page.dart';
import '../../../products/presentation/pages/edit_product_page.dart';
import '../../../products/presentation/providers/gallery_provider.dart';
import '../../../products/presentation/providers/product_mutation_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';

// ═══════════════════════════════════════════════════════════
// 1. ENUMLAR (Okunabilirlik ve Yönetim İçin)
// ═══════════════════════════════════════════════════════════

enum ProductStatus {
  stokta('STOKTA'),
  satildi('SATILDI');

  final String label;

  const ProductStatus(this.label);
}

enum AdminAction {
  edit(Icons.edit_note_rounded, Colors.blue),
  delete(Icons.delete_sweep_rounded, Colors.redAccent);

  final IconData icon;
  final Color color;

  const AdminAction(this.icon, this.color);
}

// ═══════════════════════════════════════════════════════════
// 2. ANA SAYFA WIDGET'I
// ═══════════════════════════════════════════════════════════

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // İşlem başarılı olduğunda listeyi otomatik yenile
    ref.listen(productMutationProvider, (_, next) {
      if (next is AsyncData) {
        ref.invalidate(productsProvider);
      }
    });

    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: false,
        title: const Text(
          'Yönetici Paneli',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              fontSize: 24),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(52),
          child: AdBannerWidget(),
        ),
      ),
      bottomNavigationBar: const SafeArea(child: AdBannerWidget()),
      floatingActionButton: _buildLuxuryFAB(context),
      body: productsAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text("Hata: $e")),
        data: (products) => _ProductGrid(products: products),
      ),
    );
  }

  Widget _buildLuxuryFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddProductPage())),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Ürün Ekle',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 3. ÜRÜN IZGARASI (GRID)
// ═══════════════════════════════════════════════════════════

class _ProductGrid extends StatelessWidget {
  final List<Product> products;

  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
          child: Text('Ürün bulunamadı',
              style: TextStyle(color: AppColors.textSecondary)));
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.gridColumns(2),
        childAspectRatio: 0.62, // DİKKAT: Taşmayı önleyen kritik oran
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length + (products.length ~/ 5),
      itemBuilder: (context, index) {
        // Her 6 üründe bir reklam göster
        if (index > 0 && (index + 1) % 6 == 0) return const AdNativeWidget();

        final realIndex = index - (index ~/ 6);
        if (realIndex >= products.length) return const SizedBox.shrink();

        return LuxuryProductCard(product: products[realIndex]);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 4. LÜKS ÜRÜN KARTI (TASARIM BURADA)
// ═══════════════════════════════════════════════════════════

class LuxuryProductCard extends ConsumerWidget {
  final Product product;

  const LuxuryProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ImageArea(product: product),
          _InfoArea(product: product, ref: ref),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.card,
            AppColors.surface.withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      );
}

class _ImageArea extends ConsumerWidget {
  final Product product;

  const _ImageArea({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              ref.read(galleryProvider.notifier).setCurrentIndex(0);

              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.95),
                builder: (_) => GalleryViewerDialog(
                  images: product.imagesUrl,
                  isMobile: context.isMobile,
                ),
              ).then((_) {
                ref.read(galleryProvider.notifier).reset();
              });
            },
            child: Positioned.fill(
              child: product.imagesUrl.isNotEmpty
                  ? OptimizedCachedImage(
                      imageUrl: product.imagesUrl.first,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.darkSurface,
                      child: const Icon(
                        Icons.chair_alt_rounded,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                    ),
            ),
          ),

          /// STATUS BADGE
          Positioned(
            top: 14,
            left: 14,
            child: _StatusBadge(isSold: product.isSold),
          ),

          /// PRICE BADGE
          Positioned(
            bottom: 14,
            right: 14,
            child: _PriceBadge(price: product.price),
          ),
        ],
      ),
    );
  }
}

class _InfoArea extends ConsumerWidget {
  final Product product;
  final WidgetRef ref;

  const _InfoArea({
    required this.product,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _ActionBar(product: product),
        ],
      ),
    );
  }
}

class _ActionBar extends ConsumerWidget {
  final Product product;

  const _ActionBar({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _actionBtn(
            icon: Icons.edit_rounded,
            color: AppColors.info,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProductPage(
                    productId: product.id,
                    product: product,
                  ),
                ),
              );
            },
          ),
          _divider(),
          _actionBtn(
            icon: Icons.delete_forever_rounded,
            color: AppColors.error,
            onTap: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _divider() => Container(width: 1, color: AppColors.border);

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Ürünü Sil'),
        content: Text('${product.name} kalıcı olarak silinecek. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () {
              ref.read(productMutationProvider.notifier).delete(product.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Evet, Sil',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 5. YARDIMCI KÜÇÜK WIDGETLAR
// ═══════════════════════════════════════════════════════════

class _StatusBadge extends StatelessWidget {
  final bool isSold;

  const _StatusBadge({required this.isSold});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: isSold
            ? AppColors.secondaryGradient
            : AppColors.accentGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isSold ? 'SATILDI' : 'STOKTA',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final num price;

  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$price ₺',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
