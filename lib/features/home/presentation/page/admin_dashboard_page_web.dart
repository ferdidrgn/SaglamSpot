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
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/add_product_page.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../products/presentation/providers/product_mutation_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../widgets/admin_dashboard_overview.dart';
import '../widgets/admin_dashboard_stat_card.dart';
import '../widgets/admin_product_table_web.dart';
import 'admin_managers_page.dart';
import 'admin_notifications_page.dart';
import 'admin_product_stats_page.dart';

enum _WebSection { overview, products }

/// Admin panelinin masaüstü (web) kabuğu — mobildeki sekme/kart düzeni
/// büyütülüp web diye sunulmuyor (CLAUDE.md): sabit sol kenar çubuğu +
/// geniş içerik alanı, TicketApp'in `/yonetim` sidebar'ının Flutter
/// karşılığı. İstatistikler/Bildirimler/Yöneticiler mobildeki AYNI
/// sayfalara (`Navigator.push`) gider — navigasyon mimarisi mobille
/// aynı, sadece masaüstü "chrome" ayrı. `AdminDashboardPage` bu widget'ı
/// `kIsWeb` olduğunda kullanır.
class AdminDashboardPageWeb extends ConsumerStatefulWidget {
  const AdminDashboardPageWeb({super.key});

  @override
  ConsumerState<AdminDashboardPageWeb> createState() =>
      _AdminDashboardPageWebState();
}

class _AdminDashboardPageWebState extends ConsumerState<AdminDashboardPageWeb> {
  _WebSection _section = _WebSection.overview;
  ProductCategory? _selectedCategory;
  bool _showSold = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _selectionMode = false;
  final Set<String> _selectedIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() => setState(() {
        _selectionMode = !_selectionMode;
        _selectedIds.clear();
      });

  Future<void> _bulkMarkSold(final List<Product> all) async {
    final selected =
        all.where((final p) => _selectedIds.contains(p.id) && !p.isSold).toList();
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
              child: Text(context.l10n.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
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

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.brand,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(context.l10n.logoutConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(authProvider.notifier).signOut();
      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(final BuildContext context) {
    ref.listen(productMutationProvider, (final _, final next) {
      if (next is AsyncData) ref.invalidate(productsProvider);
    });

    final productsAsync = ref.watch(productsProvider);
    final inStock = ref.watch(availableProductsProvider);
    final sold = ref.watch(soldProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AtelierBackground(
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSidebar(context),
              Expanded(
                child: productsAsync.when(
                  loading: () => Center(
                      child:
                          CircularProgressIndicator(color: AppColors.mobileAccent)),
                  error: (final e, final _) => AtelierStateView(
                    icon: Icons.cloud_off_rounded,
                    title: context.l10n.loadErrorTitle,
                    message: context.l10n.productsLoadError(e.toString()),
                    actionLabel: context.l10n.retry,
                    onAction: () => ref.invalidate(productsProvider),
                  ),
                  data: (final all) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 24, 28, 4),
                        child: Text(
                          _section == _WebSection.overview
                              ? context.l10n.adminOverviewTabLabel
                              : context.l10n.adminSidebarProducts,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.mobileTextPrimary),
                        ),
                      ),
                      Expanded(
                        child: _section == _WebSection.overview
                            ? _buildOverview(context, inStock.length, sold.length)
                            : _buildProducts(context, all, inStock, sold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(final BuildContext context) => Container(
        width: 232,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.mobileSurface,
          border: Border(right: BorderSide(color: AppColors.mobileBorder)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(context.l10n.adminPanelTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.mobileTextPrimary)),
            ),
            const SizedBox(height: AppSpacing.lg),
            _navButton(
              icon: Icons.dashboard_rounded,
              label: context.l10n.adminOverviewTabLabel,
              selected: _section == _WebSection.overview,
              onTap: () => setState(() => _section = _WebSection.overview),
            ),
            _navButton(
              icon: Icons.inventory_2_outlined,
              label: context.l10n.adminSidebarProducts,
              selected: _section == _WebSection.products,
              onTap: () => setState(() => _section = _WebSection.products),
            ),
            _navButton(
              icon: Icons.bar_chart_rounded,
              label: context.l10n.productStatsTooltip,
              selected: false,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (final _) => const AdminProductStatsPage())),
            ),
            _navButton(
              icon: Icons.campaign_outlined,
              label: context.l10n.notificationsAdminTooltip,
              selected: false,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (final _) => const AdminNotificationsPage())),
            ),
            _navButton(
              icon: Icons.admin_panel_settings_outlined,
              label: context.l10n.adminManagersTooltip,
              selected: false,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (final _) => const AdminManagersPage())),
            ),
            const Spacer(),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            _navButton(
              icon: Icons.storefront_outlined,
              label: context.l10n.brand,
              selected: false,
              onTap: () => context.go('/'),
            ),
            _navButton(
              icon: Icons.logout_rounded,
              label: context.l10n.logout,
              selected: false,
              onTap: _confirmLogout,
            ),
          ],
        ),
      );

  Widget _navButton({
    required final IconData icon,
    required final String label,
    required final bool selected,
    required final VoidCallback onTap,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
        child: Material(
          color: selected
              ? AppColors.mobilePrimary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: AppRadius.all(AppRadius.md),
          child: InkWell(
            borderRadius: AppRadius.all(AppRadius.md),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
              child: Row(
                children: [
                  Icon(icon,
                      size: 18,
                      color: selected
                          ? AppColors.mobilePrimary
                          : AppColors.mobileTextSecondary),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                        color: selected
                            ? AppColors.mobilePrimary
                            : AppColors.mobileTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildOverview(final BuildContext context, final int stock, final int sold) =>
      ListView(
        padding: const EdgeInsets.fromLTRB(28, 4, 28, 28),
        children: [
          const AdminOverviewSection(),
          const SizedBox(height: AppSpacing.md),
          AdminStatsSummaryRow(stock: stock, sold: sold),
        ],
      );

  Widget _buildProducts(final BuildContext context, final List<Product> all,
      final List<Product> inStock, final List<Product> sold) {
    final base = _showSold ? sold : inStock;
    var list = _selectedCategory == null
        ? base
        : base.where((final p) => p.category == _selectedCategory).toList();
    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((final p) => p.name.toLowerCase().contains(query)).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, AppSpacing.sm),
          child: Row(
            children: [
              AtelierChoiceChip(
                label: '${context.l10n.stock} (${inStock.length})',
                selected: !_showSold,
                onTap: () => setState(() => _showSold = false),
                activeColor: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              AtelierChoiceChip(
                label: '${context.l10n.sold} (${sold.length})',
                selected: _showSold,
                onTap: () => setState(() => _showSold = true),
                activeColor: AppColors.mobileAccentDark,
              ),
              const Spacer(),
              SizedBox(
                width: 260,
                child: AtelierSearchField(
                  hint: context.l10n.adminProductSearchHint,
                  controller: _searchController,
                  onChanged: (final q) => setState(() => _searchQuery = q),
                  onClear: () => setState(() => _searchQuery = ''),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AtelierIconButton(
                icon: _selectionMode ? Icons.close_rounded : Icons.checklist_rounded,
                tooltip: _selectionMode
                    ? context.l10n.adminSelectModeExit
                    : context.l10n.adminSelectModeEnter,
                onTap: _toggleSelectionMode,
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (final _) => const AddProductPage())),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(context.l10n.addProductFab),
                style: FilledButton.styleFrom(backgroundColor: AppColors.mobilePrimary),
              ),
            ],
          ),
        ),
        CategoryAccentRail(
          orientation: Axis.horizontal,
          selected: _selectedCategory,
          onSelect: (final c) => setState(() => _selectedCategory = c),
          allColor: AppColors.mobilePrimary,
          selectedTextColor: AppColors.mobileTextPrimary,
          unselectedTextColor: AppColors.mobileTextTertiary,
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          border: Border(bottom: BorderSide(color: AppColors.mobileBorder)),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: AdminProductTableWeb(
              products: list,
              selectionMode: _selectionMode,
              selectedIds: _selectedIds,
              onToggleSelect: (final id) => setState(() {
                if (!_selectedIds.add(id)) _selectedIds.remove(id);
              }),
            ),
          ),
        ),
        if (_selectionMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.mobileSurface,
              border: Border(top: BorderSide(color: AppColors.mobileBorder)),
            ),
            child: Row(
              children: [
                Text(context.l10n.adminSelectedCount(_selectedIds.length),
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: AppColors.mobileTextPrimary)),
                const Spacer(),
                TextButton.icon(
                  onPressed: _selectedIds.isEmpty ? null : () => _bulkMarkSold(all),
                  icon: const Icon(Icons.sell_rounded, size: 18),
                  label: Text(context.l10n.adminBulkMarkSold),
                ),
                TextButton.icon(
                  onPressed: _selectedIds.isEmpty ? null : _bulkDelete,
                  style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                  icon: const Icon(Icons.delete_rounded, size: 18),
                  label: Text(context.l10n.adminBulkDelete),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
