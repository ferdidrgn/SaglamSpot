import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ads/widgets/ad_banner_widget.dart';
import '../../../../core/ads/widgets/ad_grid_helper.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../core/widgets/gallery_section.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../../products/data/models/category_meta.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/add_product_page.dart';
import '../../../products/presentation/pages/edit_product_page.dart';
import '../../../products/presentation/providers/gallery_provider.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../products/presentation/providers/product_mutation_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';

/// Mobil Yönetici Paneli — Ana Sayfa. Stok/satılan ürünleri yönetmek için
/// kategoriye göre filtrelenebilir, hızlı özet istatistikli bir kontrol
/// paneli.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);
  ProductCategory? _selectedCategory;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    ref.listen(productMutationProvider, (final _, final next) {
      if (next is AsyncData) ref.invalidate(productsProvider);
    });

    final productsAsync = ref.watch(productsProvider);
    final inStock = ref.watch(availableProductsProvider);
    final sold = ref.watch(soldProductsProvider);

    List<Product> filtered(final List<Product> list) => _selectedCategory == null
        ? list
        : list.where((final p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      appBar: _buildAppBar(context),
      body: productsAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.mobileAccent)),
        error: (final e, final _) => Center(child: Text('Hata: $e')),
        data: (final _) => Column(
          children: [
            _buildStatsRow(inStock.length, sold.length),
            _buildTabBar(inStock.length, sold.length),
            DynamicCategoryChips(
              selected: _selectedCategory,
              onSelect: (final c) => setState(() => _selectedCategory = c),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const SizedBox(height: 4),
            const AdBannerWidget(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _ProductGrid(products: filtered(inStock)),
                  _ProductGrid(products: filtered(sold)),
                ],
              ),
            ),
            const AdBannerWidget(),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(final BuildContext context) => AppBar(
        backgroundColor: AppColors.mobileBackground,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/'),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            context.l10n.adminPanelTitle,
            style: TextStyle(
              color: AppColors.mobileTextPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: -0.5,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      );

  Future<void> _confirmLogout(final BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.brand, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(context.l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) context.go('/');
    }
  }

  Widget _buildStatsRow(final int stock, final int sold) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
                child: _StatCard(
                    label: context.l10n.stock,
                    value: '$stock',
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.success)),
            const SizedBox(width: 10),
            Expanded(
                child: _StatCard(
                    label: context.l10n.sold,
                    value: '$sold',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.mobileAccentDark)),
            const SizedBox(width: 10),
            Expanded(
                child: _StatCard(
                    label: context.l10n.totalCount,
                    value: '${stock + sold}',
                    icon: Icons.widgets_rounded,
                    color: AppColors.info)),
          ],
        ),
      );

  Widget _buildTabBar(final int stock, final int sold) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10)),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              gradient: AppColors.mobileAccentGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.mobileTextSecondary,
            labelStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            unselectedLabelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            dividerColor: Colors.transparent,
            tabs: [_buildTab(context.l10n.stock, stock), _buildTab(context.l10n.sold, sold)],
          ),
        ),
      );

  Widget _buildTab(final String label, final int count) => Tab(
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
              child: Text(count.toString(),
                  style:
                      const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

  Widget _buildAddButton(final BuildContext context) => FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (final _) => const AddProductPage())),
        backgroundColor: AppColors.mobileAccent,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(context.l10n.addProductFab,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.16),
                blurRadius: 18,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.85), color],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w900,
                    color: AppColors.mobileTextPrimary)),
            Text(label,
                style: TextStyle(fontSize: 10.5, color: AppColors.mobileTextTertiary)),
          ],
        ),
      );
}

class _ProductGrid extends StatelessWidget {
  final List<Product> products;

  const _ProductGrid({required this.products});

  @override
  Widget build(final BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 48, color: AppColors.mobileTextTertiary),
            const SizedBox(height: 10),
            Text(context.l10n.emptyCategoryProducts,
                style: TextStyle(color: AppColors.mobileTextTertiary)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.gridColumns(2),
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: paddedItemCountForAds(products.length),
      itemBuilder: (final context, final index) {
        if (isAdSlot(index, products.length)) return const NativeAdCard();
        final realIndex = realIndexForAdGrid(index, products.length);
        if (realIndex >= products.length) return const SizedBox.shrink();
        return TweenAnimationBuilder<double>(
          key: ValueKey(products[realIndex].id),
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (realIndex % 6) * 60),
          curve: Curves.easeOutCubic,
          builder: (final context, final t, final child) => Opacity(
            opacity: t,
            child: Transform.translate(
                offset: Offset(0, (1 - t) * 16), child: child),
          ),
          child: LuxuryProductCard(product: products[realIndex]),
        );
      },
    );
  }
}

class LuxuryProductCard extends ConsumerStatefulWidget {
  final Product product;

  const LuxuryProductCard({super.key, required this.product});

  @override
  ConsumerState<LuxuryProductCard> createState() => _LuxuryProductCardState();
}

class _LuxuryProductCardState extends ConsumerState<LuxuryProductCard> {
  bool _isPressed = false;

  @override
  Widget build(final BuildContext context) {
    final product = widget.product;
    return GestureDetector(
      onTapDown: (final _) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (final _) => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.mobileCardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: AppColors.mobilePrimary.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, 12)),
          BoxShadow(
              color: AppColors.mobileTextPrimary.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _ImageArea(product: product)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoArea(product: product),
                const SizedBox(height: 8),
                _ActionBar(product: product),
              ],
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}

class _ImageArea extends ConsumerWidget {
  final Product product;

  const _ImageArea({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              ref
                  .read(galleryProvider(product.imagesUrl.length).notifier)
                  .setCurrentIndex(0);
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.95),
                builder: (final _) => GalleryViewerDialog(
                    images: product.imagesUrl, isMobile: context.isMobile),
              );
            },
            child: product.imagesUrl.isNotEmpty
                ? OptimizedCachedImage(
                    imageUrl: product.imagesUrl.first, fit: BoxFit.cover)
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.mobileSecondaryBg,
                    child: Icon(Icons.chair_alt_rounded,
                        size: 48, color: AppColors.mobileTextTertiary),
                  ),
          ),
          Positioned(top: 10, left: 10, child: _StatusBadge(product: product)),
        ],
      );
}

class _InfoArea extends StatelessWidget {
  final Product product;

  const _InfoArea({required this.product});

  @override
  Widget build(final BuildContext context) {
    final meta = defaultCategoryMeta[product.category];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.mobileTextPrimary),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (meta != null) ...[
              Icon(meta.icon, size: 12, color: meta.color),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                product.category.label(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: meta?.color ?? AppColors.mobileTextSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${product.price.toStringAsFixed(0)} ₺',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.mobilePrimary),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!product.isSold) ...[
          _actionBtn(
            icon: Icons.edit_rounded,
            color: AppColors.mobilePrimary,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final _) =>
                      EditProductPage(productId: product.id, product: product),
                )),
          ),
          const SizedBox(width: 8),
        ],
        _actionBtn(
          icon: Icons.delete_rounded,
          color: AppColors.error,
          onTap: () => _confirmDelete(context, ref),
        ),
      ],
    );
  }

  Widget _actionBtn(
      {required final IconData icon,
      required final Color color,
      required final VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: color.withOpacity(0.35),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }

  void _confirmDelete(final BuildContext context, final WidgetRef ref) {
    showDialog(
      context: context,
      builder: (final _) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(context.l10n.deleteProductTitle),
        content: Text('${product.name} ${context.l10n.deleteProductConfirmSuffix}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
          TextButton(
            onPressed: () {
              ref.read(productMutationProvider.notifier).delete(product.id);
              Navigator.pop(context);
            },
            child: Text(context.l10n.yesDelete,
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Product product;

  const _StatusBadge({required this.product});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: product.isSold
            ? AppColors.mobilePrimaryGradient
            : AppColors.mobileAccentGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        product.isSold ? context.l10n.sold : context.l10n.stock,
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }
}
