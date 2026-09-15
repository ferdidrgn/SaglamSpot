import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/add_product_page.dart';
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
      appBar: _buildAppBar(context),
      body: productsAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: AppColors.mobileAccent)),
        error: (final e, final _) =>
            Center(child: Text(context.l10n.productsLoadError(e.toString()))),
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
      floatingActionButton: _buildAddButton(context),
    );

    return kIsWeb ? scaffold : BackToHomeGuard(child: scaffold);
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
            icon: Icon(Icons.bar_chart_rounded,
                color: AppColors.mobileTextSecondary),
            tooltip: context.l10n.productStatsTooltip,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (final _) => const AdminProductStatsPage())),
          ),
          IconButton(
            icon: Icon(Icons.cloud_outlined,
                color: AppColors.mobileTextSecondary),
            tooltip: context.l10n.firebaseServicesTooltip,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (final _) => const AdminFirebaseServicesPage())),
          ),
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

  Widget _buildStatsRow(final int stock, final int sold) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
                child: AdminStatCard(
                    label: context.l10n.stock,
                    value: '$stock',
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.success)),
            const SizedBox(width: 10),
            Expanded(
                child: AdminStatCard(
                    label: context.l10n.sold,
                    value: '$sold',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.mobileAccentDark)),
            const SizedBox(width: 10),
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
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.mobileSurface,
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
            tabs: [
              _buildTab(context.l10n.stock, stock),
              _buildTab(context.l10n.sold, sold)
            ],
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
        backgroundColor: AppColors.mobileAccent,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(context.l10n.addProductFab,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      );
}
