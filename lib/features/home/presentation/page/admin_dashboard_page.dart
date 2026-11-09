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
import '../widgets/admin_dashboard_overview.dart';
import '../widgets/admin_dashboard_product_grid.dart';
import '../widgets/admin_dashboard_stat_card.dart';
import 'admin_dashboard_page_web.dart';
import 'admin_managers_page.dart';
import 'admin_notifications_page.dart';
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
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _selectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() => setState(() {
        _selectionMode = !_selectionMode;
        _selectedIds.clear();
      });

  void _toggleSelect(final String id) => setState(() {
        if (!_selectedIds.add(id)) _selectedIds.remove(id);
      });

  Future<void> _bulkMarkSold(final List<Product> all) async {
    final selected = all
        .where((final p) => _selectedIds.contains(p.id) && !p.isSold)
        .toList();
    if (selected.isEmpty) return;
    await ref.read(productMutationProvider.notifier).markSold(selected);
    if (!mounted) return;
    setState(() {
      _selectedIds.clear();
      _selectionMode = false;
    });
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(context.l10n.adminBulkMarkSoldSuccess(selected.length)),
        action: SnackBarAction(
          label: context.l10n.undo,
          onPressed: () =>
              ref.read(productMutationProvider.notifier).markAvailable(selected),
        ),
      ));
  }

  Future<void> _bulkDelete() async {
    final ids = _selectedIds.toList();
    if (ids.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.adminBulkDeleteConfirmTitle(ids.length)),
        content: Text(context.l10n.adminBulkDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(context.l10n.adminBulkDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref.read(productMutationProvider.notifier).deleteMany(ids);
    if (!mounted) return;
    setState(() {
      _selectedIds.clear();
      _selectionMode = false;
    });
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
          SnackBar(content: Text(context.l10n.adminBulkDeleteSuccess(ids.length))));
  }

  @override
  Widget build(final BuildContext context) {
    // Masaüstü web: sidebar'lı tamamen ayrı bir kabuk (bkz.
    // admin_dashboard_page_web.dart) — mobildeki sekme/ızgara düzeni
    // büyütülüp web diye sunulmuyor (CLAUDE.md).
    if (kIsWeb) return const AdminDashboardPageWeb();

    ref.listen(productMutationProvider, (final _, final next) {
      if (next is AsyncData) ref.invalidate(productsProvider);
    });

    final productsAsync = ref.watch(productsProvider);
    final inStock = ref.watch(availableProductsProvider);
    final sold = ref.watch(soldProductsProvider);

    List<Product> filtered(final List<Product> list) {
      var result = _selectedCategory == null
          ? list
          : list.where((final p) => p.category == _selectedCategory).toList();
      final query = _searchQuery.trim().toLowerCase();
      if (query.isNotEmpty) {
        result =
            result.where((final p) => p.name.toLowerCase().contains(query)).toList();
      }
      return result;
    }

    final Widget scaffold = Scaffold(
      // Şeffaf değil: sistem durum/gezinme çubuklarının altındaki alan
      // aksi halde native pencere zeminine (siyah) düşüyordu.
      backgroundColor: AppColors.background,
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
                  data: (final all) => Column(
                    children: [
                      const AdminOverviewSection(),
                      const SizedBox(height: AppSpacing.sm),
                      _buildStatsRow(inStock.length, sold.length),
                      _buildToolsRow(context),
                      _buildSearchRow(context),
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
                                  AdminProductGrid(
                                    products: filtered(inStock),
                                    selectionMode: _selectionMode,
                                    selectedIds: _selectedIds,
                                    onToggleSelect: _toggleSelect,
                                  ),
                                  AdminProductGrid(
                                    products: filtered(sold),
                                    selectionMode: _selectionMode,
                                    selectedIds: _selectedIds,
                                    onToggleSelect: _toggleSelect,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectionMode) _buildSelectionBar(context, all),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectionMode ? null : _buildAddButton(context),
    );

    return BackToHomeGuard(child: scaffold);
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
                icon: Icons.campaign_outlined,
                label: context.l10n.notificationsAdminTooltip,
                color: AppColors.mobileAccentDark,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (final _) => const AdminNotificationsPage())),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: _AdminToolTile(
                icon: Icons.admin_panel_settings_outlined,
                label: context.l10n.adminManagersTooltip,
                color: AppColors.mobilePrimary,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (final _) => const AdminManagersPage())),
              ),
            ),
          ],
        ),
      );

  Widget _buildSearchRow(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: AtelierSearchField(
                hint: context.l10n.adminProductSearchHint,
                controller: _searchController,
                onChanged: (final q) => setState(() => _searchQuery = q),
                onClear: () => setState(() => _searchQuery = ''),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AtelierIconButton(
              icon: _selectionMode
                  ? Icons.close_rounded
                  : Icons.checklist_rounded,
              tooltip: _selectionMode
                  ? context.l10n.adminSelectModeExit
                  : context.l10n.adminSelectModeEnter,
              onTap: _toggleSelectionMode,
            ),
          ],
        ),
      );

  Widget _buildSelectionBar(final BuildContext context, final List<Product> all) {
    final count = _selectedIds.length;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.mobileSurface,
          border: Border(top: BorderSide(color: AppColors.mobileBorder)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(context.l10n.adminSelectedCount(count),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.mobileTextPrimary)),
            ),
            TextButton.icon(
              onPressed: count == 0 ? null : () => _bulkMarkSold(all),
              icon: const Icon(Icons.sell_rounded, size: 18),
              label: Text(context.l10n.adminBulkMarkSold,
                  style: const TextStyle(fontSize: 12.5)),
            ),
            TextButton.icon(
              onPressed: count == 0 ? null : _bulkDelete,
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              icon: const Icon(Icons.delete_rounded, size: 18),
              label: Text(context.l10n.adminBulkDelete,
                  style: const TextStyle(fontSize: 12.5)),
            ),
          ],
        ),
      ),
    );
  }

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
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, AppSpacing.md),
        child: AdminStatsSummaryRow(stock: stock, sold: sold),
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
