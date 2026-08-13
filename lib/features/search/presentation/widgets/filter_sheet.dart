import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/search_providers.dart';

class FilterSheet extends ConsumerStatefulWidget {
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;

  const FilterSheet({
    super.key,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Senin orijinal 400ms süren korundu
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      final filters = ref.read(searchFiltersProvider);
      if (filters.minPrice > 0) {
        _minPriceController.text = filters.minPrice.toInt().toString();
      }
      if (filters.maxPrice < 100000) {
        _maxPriceController.text = filters.maxPrice.toInt().toString();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _closeSheet() async {
    await _animController.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(final BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);
    final filtersNotifier = ref.read(searchFiltersProvider.notifier);

    return GestureDetector(
      onTap: _closeSheet,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {}, // İçeriğe tıklayınca kapanmasın
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHandleBar(),
                      _buildHeader(),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            context.responsive(
                                mobile: 20.0, tablet: 24.0, desktop: 28.0),
                            8,
                            context.responsive(
                                mobile: 20.0, tablet: 24.0, desktop: 28.0),
                            context.responsive(
                                mobile: 20.0, tablet: 24.0, desktop: 28.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle(context.l10n.condition),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 12.0, desktop: 14.0)),
                              _buildConditionSelector(filters, filtersNotifier),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 28.0,
                                      tablet: 32.0,
                                      desktop: 36.0)),
                              _buildSectionTitle(context.l10n.priceRange),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 12.0, desktop: 14.0)),
                              _buildPriceRangeInputs(filters, filtersNotifier),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 28.0,
                                      tablet: 32.0,
                                      desktop: 36.0)),
                              _buildSectionTitle(context.l10n.quickOptions),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 12.0, desktop: 14.0)),
                              _buildPricePresets(filtersNotifier),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 32.0,
                                      tablet: 36.0,
                                      desktop: 40.0)),
                            ],
                          ),
                        ),
                      ),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandleBar() => Container(
        margin: const EdgeInsets.only(top: 12),
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.responsive(mobile: 20.0, tablet: 24.0, desktop: 28.0),
        20,
        16,
        context.responsive(mobile: 14.0, tablet: 16.0, desktop: 18.0),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
                context.responsive(mobile: 9.0, tablet: 10.0, desktop: 11.0)),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: AppColors.textSecondary,
              size:
                  context.responsive(mobile: 22.0, tablet: 23.0, desktop: 24.0),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.filter,
                style: TextStyle(
                  fontSize: context.responsive(
                      mobile: 22.0, tablet: 23.0, desktop: 24.0),
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Text(context.l10n.easyFind),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: _closeSheet,
            icon:
                Icon(Icons.close_rounded, color: AppColors.textSecondary),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(final String title) => Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 10),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      );

  Widget _buildConditionSelector(
      final dynamic filters, final dynamic notifier) {
    return Wrap(
      spacing: context.responsive(mobile: 10.0, tablet: 12.0, desktop: 14.0),
      runSpacing: 12,
      children: ProductCondition.values.map((final cond) {
        final isSelected = (filters.condition ?? ProductCondition.all) == cond;
        return _buildConditionCard(
          label: cond.label(context),
          isSelected: isSelected,
          onTap: () => notifier.setCondition(cond),
        );
      }).toList(),
    );
  }

  Widget _buildConditionCard(
      {required final String label,
      required final bool isSelected,
      required final VoidCallback onTap}) {
    final cardWidth = (MediaQuery.of(context).size.width -
            context.responsive(mobile: 60.0, tablet: 72.0, desktop: 84.0)) /
        3;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.textSecondary.withOpacity(0.12)
              : AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? AppColors.textSecondary : AppColors.border,
              width: 2),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.textSecondary
                    : AppColors.textPrimary)),
      ),
    );
  }

  Widget _buildPriceRangeInputs(final dynamic filters, final dynamic notifier) {
    return Row(
      children: [
        Expanded(
            child: _buildPriceInput(
                controller: _minPriceController,
                label: 'Min',
                onChanged: (final val) => notifier.setPriceRange(
                    double.tryParse(val) ?? 0, filters.maxPrice))),
        const SizedBox(width: 12),
        Expanded(
            child: _buildPriceInput(
                controller: _maxPriceController,
                label: 'Max',
                onChanged: (final val) => notifier.setPriceRange(
                    filters.minPrice, double.tryParse(val) ?? 100000))),
      ],
    );
  }

  Widget _buildPriceInput(
      {required final TextEditingController controller,
      required final String label,
      required final Function(String) onChanged}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border)),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.payments_rounded, size: 18),
            suffixText: '₺',
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      ),
    );
  }

  Widget _buildPricePresets(final dynamic notifier) {
    final presets = [
      (0.0, 1000.0, '0-1K'),
      (1000.0, 5000.0, '1K-5K'),
      (5000.0, 10000.0, '5K-10K')
    ];
    return Wrap(
      spacing: 8,
      children: presets
          .map((final p) => ActionChip(
              label: Text(p.$3),
              onPressed: () {
                _minPriceController.text = p.$1.toInt().toString();
                _maxPriceController.text = p.$2.toInt().toString();
                notifier.setPriceRange(p.$1, p.$2);
              }))
          .toList(),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border))),
      child: Row(
        children: [
          Expanded(
              child: OutlinedButton(
                  onPressed: () {
                    widget.onResetFilters();
                    _closeSheet();
                  },
                  child: Text(context.l10n.clear))),
          const SizedBox(width: 12),
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters();
                    _closeSheet();
                  },
                  child: Text(context.l10n.apply))),
        ],
      ),
    );
  }
}
