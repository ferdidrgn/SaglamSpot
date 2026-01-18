import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../../core/widgets/gallery_section.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/add_product_page.dart';
import '../../../products/presentation/pages/edit_product_page.dart';
import '../../../products/presentation/providers/gallery_provider.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../products/presentation/providers/product_mutation_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';

// --- ENUMLAR ---
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // İşlem başarılı olduğunda listeyi otomatik yenile
    ref.listen(productMutationProvider, (final _, final next) {
      if (next is AsyncData) ref.invalidate(productsProvider);
    });

    final productsAsync = ref.watch(productsProvider);
    final inStock = ref.watch(availableProductsProvider);
    final sold = ref.watch(soldProductsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(inStock.length, sold.length),
        body: productsAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.accent)),
          error: (final e, final _) => Center(child: Text('Hata: $e')),
          data: (final _) => Column(
            children: [
              const AdBannerWidget(),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _ProductGrid(products: inStock),
                    _ProductGrid(products: sold),
                  ],
                ),
              ),
              const AdBannerWidget(),
            ],
          ),
        ),
        floatingActionButton: _buildLuxuryFAB(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(final int stock, final int sold) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      // Daha modern bir sol hizalama
      title: const Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(
          'Yönetici Paneli',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 26, // Daha iddialı bir başlık
            letterSpacing: -0.5,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Column(
          children: [
            // TabBar'ı taşıyan ana yapı
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white, // Kart rengiyle uyumlu
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: TabBar(
                  // Gösterge (Seçili Alan) Ayarları
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: AppColors.accentGradient, // Premium degrade
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // Yazı Stilleri
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  // Çizgileri kaldır
                  dividerColor: Colors.transparent,
                  tabs: [
                    _buildTab('STOKTA', stock),
                    _buildTab('SATILDI', sold),
                  ],
                ),
              ),
            ),
            // Reklam alanı (Opsiyonel: Eğer hala buradaysa)
            // const AdBannerWidget(),
          ],
        ),
      ),
    );
  }

// Tab içeriği için yardımcı fonksiyon (Sayıyı şık bir baloncuk içinde gösterir)
  Widget _buildTab(String label, int count) {
    return Tab(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryFAB(final BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (final _) => const AddProductPage())),
      backgroundColor: AppColors.accent,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text('Ürün Ekle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<Product> products;

  const _ProductGrid({required this.products});

  @override
  Widget build(final BuildContext context) {
    if (products.isEmpty) return const Center(child: Text('Ürün bulunamadı'));

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.gridColumns(2),
        // Görsel büyüdüğü için oranı 0.65'ten 0.58'e çektik (Daha uzun kartlar)
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length + (products.length ~/ 5),
      itemBuilder: (context, index) {
        if (index > 0 && (index + 1) % 6 == 0) return const AdNativeWidget();
        final realIndex = index - (index ~/ 6);
        if (realIndex >= products.length) return const SizedBox.shrink();
        return LuxuryProductCard(product: products[realIndex]);
      },
    );
  }
}

class LuxuryProductCard extends ConsumerWidget {
  final Product product;

  const LuxuryProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: AppColors.accent.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // GÖRSEL ALANI: AspectRatio 1.1'den 0.9'a çekildi (Daha Büyük Görsel)
          AspectRatio(
            aspectRatio: 0.9,
            child: _ImageArea(product: product),
          ),
          // BİLGİ VE AKSİYON ALANI
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoArea(product: product),
                  const Spacer(),
                  _ActionBar(product: product),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageArea extends ConsumerWidget {
  final Product product;

  const _ImageArea({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(galleryProvider.notifier).setCurrentIndex(0);
            showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(0.95),
              builder: (final _) => GalleryViewerDialog(
                images: product.imagesUrl,
                isMobile: context.isMobile,
              ),
            ).then((final _) => ref.read(galleryProvider.notifier).reset());
          },
          child: Positioned.fill(
            child: product.imagesUrl.isNotEmpty
                ? OptimizedCachedImage(
                    imageUrl: product.imagesUrl.first, fit: BoxFit.cover)
                : Container(
                    color: AppColors.darkSurface,
                    child: const Icon(Icons.chair_alt_rounded,
                        size: 48, color: AppColors.textTertiary),
                  ),
          ),
        ),
        Positioned(
            top: 10, left: 10, child: _StatusBadge(isSold: product.isSold)),
        Positioned(
            bottom: 10, right: 10, child: _PriceBadge(price: product.price)),
      ],
    );
  }
}

class _InfoArea extends StatelessWidget {
  final Product product;

  const _InfoArea({required this.product});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          product.category,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ActionBar extends ConsumerWidget {
  final Product product;

  const _ActionBar({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (!product.isSold) ...[
            _actionBtn(
              icon: Icons.edit_rounded,
              color: AppColors.info,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (final _) => EditProductPage(
                        productId: product.id, product: product),
                  )),
            ),
            Container(width: 1, color: AppColors.border),
          ],
          _actionBtn(
            icon: Icons.delete_forever_rounded,
            color: AppColors.error,
            onTap: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
      {required final IconData icon,
      required final Color color,
      required final VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  void _confirmDelete(final BuildContext context, final WidgetRef ref) {
    showDialog(
      context: context,
      builder: (final _) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Ürünü Sil'),
        content: Text('${product.name} silinecek. Emin misiniz?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç')),
          TextButton(
            onPressed: () {
              ref.read(productMutationProvider.notifier).delete(product.id);
              Navigator.pop(context);
            },
            child: const Text('Evet, Sil',
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isSold;

  const _StatusBadge({required this.isSold});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient:
            isSold ? AppColors.secondaryGradient : AppColors.accentGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isSold ? 'SATILDI' : 'STOKTA',
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final num price;

  const _PriceBadge({required this.price});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$price ₺',
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
    );
  }
}
