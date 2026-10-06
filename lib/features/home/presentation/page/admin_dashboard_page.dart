import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/category_accent_rail.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../../core/widgets/design_system/atelier_components.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/add_product_page.dart';
import '../../../products/presentation/pages/edit_product_page.dart';
import '../widgets/admin_dashboard_product_grid.dart';
import '../widgets/admin_dashboard_stat_card.dart';
import 'admin_firebase_services_page.dart';
import 'admin_product_stats_page.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../products/presentation/providers/product_mutation_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';

/// Yönetici (Esnaf) Paneli — Kontrol Odası. Stok/satılan ürünleri yönetmek
/// için kategoriye göre filtrelenebilir, hızlı özet istatistikli bir
/// kontrol paneli.
class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
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

    List<Product> filtered(final List<Product> list) =>
        _selectedCategory == null
            ? list
            : list.where((final p) => p.category == _selectedCategory).toList();

    final Widget scaffold = Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: AtelierBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: productsAsync.when(
                  loading: () => Center(
                      child: CircularProgressIndicator(
                          color: AppColors.mobileAccent)),
                  error: (final e, final _) => AtelierStateView(
                    icon: Icons.cloud_off_rounded,
                    title: context.l10n.loadErrorTitle,
                    message: context.l10n.productsLoadError(e.toString()),
                    actionLabel: context.l10n.retry,
                    onAction: () => ref.invalidate(productsProvider),
                  ),
                  data: (final _) => Column(
                    children: [
                      _buildStatsRow(inStock.length, sold.length),
                      _buildShowcaseGap(context, inStock),
                      _buildToolsRow(context),
                      _buildTabBar(inStock.length, sold.length),
                      // Keşfet/Arama ile aynı dil: solda dikey kategori
                      // rayı, sağda ürünler.
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CategoryAccentRail(
                              orientation: Axis.vertical,
                              selected: _selectedCategory,
                              onSelect: (final c) =>
                                  setState(() => _selectedCategory = c),
                              allColor: AppColors.mobilePrimary,
                              selectedTextColor: AppColors.mobileTextPrimary,
                              unselectedTextColor: AppColors.mobileTextTertiary,
                              width: 52,
                              border: Border(
                                  right: BorderSide(
                                      color: AppColors.mobileBorder)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  AdminProductGrid(products: filtered(inStock)),
                                  AdminProductGrid(products: filtered(sold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(context),
    );

    return kIsWeb ? scaffold : BackToHomeGuard(child: scaffold);
  }

  Widget _buildHeader(final BuildContext context) => AtelierScreenHeader(
        title: context.l10n.adminPanelTitle,
        subtitle: context.l10n.adminPanelSubtitle,
        leading: AtelierIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onTap: () => context.go('/'),
        ),
        actions: [
          AtelierIconButton(
            icon: Icons.logout_rounded,
            tooltip: context.l10n.logout,
            onTap: () => _confirmLogout(context),
          ),
        ],
      );

  /// İstatistikler + Firebase servisleri: eskiden AppBar'da sıkışmış iki
  /// ikondu; artık okunabilir, büyük dokunma alanlı iki araç kartı.
  Widget _buildToolsRow(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: _AdminToolTile(
                icon: Icons.bar_chart_rounded,
                label: context.l10n.productStatsTooltip,
                color: AppColors.info,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (final _) => const AdminProductStatsPage())),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: _AdminToolTile(
                icon: Icons.cloud_outlined,
                label: context.l10n.firebaseServicesTooltip,
                color: AppColors.mobileAccentDark,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (final _) =>
                            const AdminFirebaseServicesPage())),
              ),
            ),
          ],
        ),
      );

  Future<void> _confirmLogout(final BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.brand,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(context.l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel,
                style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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

  /// Fotoğrafı, açıklaması veya fiyatı eksik stok. Reklam incelemesi
  /// boş ürün sayfalarını "hazır değil" sayar; esnaf bunları telefondan
  /// tek dokunuşla düzenleme ekranına alır.
  List<Product> _showcaseGaps(final List<Product> products) => products
      .where((final p) =>
          p.imagesUrl.isEmpty || p.desc.trim().length < 24 || p.price <= 0)
      .toList();

  Widget _buildShowcaseGap(
      final BuildContext context, final List<Product> stock) {
    final gaps = _showcaseGaps(stock);
    if (gaps.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.md),
      child: AtelierPanel(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_library_outlined,
                    color: AppColors.mobileAccentDark, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(context.l10n.adminShowcaseGapTitle,
                      style: TextStyle(
                          color: AppColors.mobileTextPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(context.l10n.adminShowcaseGapBody(gaps.length),
                style: TextStyle(
                    color: AppColors.mobileTextSecondary, height: 1.35)),
            const SizedBox(height: AppSpacing.sm),
            for (final product in gaps.take(4))
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (final _) => EditProductPage(
                        productId: product.id, product: product),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.mobileTextPrimary,
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(context.l10n.adminShowcaseGapOpen,
                          style: TextStyle(
                              color: AppColors.mobileAccentDark,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(final int stock, final int sold) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, AppSpacing.md),
        child: Row(
          children: [
            Expanded(
                child: AdminStatCard(
                    label: context.l10n.stock,
                    value: '$stock',
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.success)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
                child: AdminStatCard(
                    label: context.l10n.sold,
                    value: '$sold',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.mobileAccentDark)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
                child: AdminStatCard(
                    label: context.l10n.totalCount,
                    value: '${stock + sold}',
                    icon: Icons.widgets_rounded,
                    color: AppColors.info)),
          ],
        ),
      );

  Widget _buildTabBar(final int stock, final int sold) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.sm),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.mobileSurface,
            borderRadius: AppRadius.all(AppRadius.lg),
            border: Border.all(color: AppColors.mobileBorder),
          ),
          child: AnimatedBuilder(
            animation: _tabController,
            builder: (final context, final _) => TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: _tabController.index == 0
                    ? AppColors.success
                    : AppColors.mobileAccentDark,
                borderRadius: AppRadius.all(AppRadius.md),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.mobileTextSecondary,
              labelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              dividerColor: Colors.transparent,
              splashBorderRadius: AppRadius.all(AppRadius.md),
              tabs: [
                _buildTab(context.l10n.stock, stock),
                _buildTab(context.l10n.sold, sold)
              ],
            ),
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
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: AppRadius.all(AppRadius.xs),
              ),
              child: Text(count.toString(),
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

  Widget _buildAddButton(final BuildContext context) =>
      FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (final _) => const AddProductPage())),
        backgroundColor: AppColors.mobilePrimary,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.asymSm),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(context.l10n.addProductFab,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      );
}

class _AdminToolTile extends StatelessWidget {
  const _AdminToolTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => Material(
        color: AppColors.mobileSurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.all(AppRadius.md),
          side: BorderSide(color: AppColors.mobileBorder),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.all(AppRadius.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: AppRadius.all(AppRadius.sm),
                    ),
                    child: Icon(icon, size: 18, color: color),
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mobileTextPrimary,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      size: 18, color: AppColors.mobileTextTertiary),
                ],
              ),
            ),
          ),
        ),
      );
}
