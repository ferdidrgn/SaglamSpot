import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/responsive_utils.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);
    final filtersNotifier = ref.read(searchFiltersProvider.notifier);

    return GestureDetector(
      onTap: _closeSheet,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {},
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
                              _buildSectionTitle('Ürün Durumu'),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 12.0, desktop: 14.0)),
                              _buildConditionSelector(filters, filtersNotifier),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 28.0,
                                      tablet: 32.0,
                                      desktop: 36.0)),
                              _buildSectionTitle('Fiyat Aralığı'),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 12.0, desktop: 14.0)),
                              _buildPriceRangeInputs(filters, filtersNotifier),
                              SizedBox(
                                  height: context.responsive(
                                      mobile: 28.0,
                                      tablet: 32.0,
                                      desktop: 36.0)),
                              _buildSectionTitle('Hızlı Seçenekler'),
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

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

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
          SizedBox(
              width: context.responsive(
                  mobile: 14.0, tablet: 16.0, desktop: 18.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtreleme',
                style: TextStyle(
                  fontSize: context.responsive(
                      mobile: 22.0, tablet: 23.0, desktop: 24.0),
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Aradığınız ürünü kolayca bulun',
                style: TextStyle(
                  fontSize: context.responsive(
                      mobile: 12.5, tablet: 13.0, desktop: 13.5),
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: _closeSheet,
            icon: Icon(Icons.close_rounded, color: AppColors.textSecondary),
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

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.textSecondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize:
                context.responsive(mobile: 15.0, tablet: 15.5, desktop: 16.0),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildConditionSelector(dynamic filters, dynamic notifier) {
    final conditions = [
      ('Tümü', Icons.grid_view_rounded, 'Hepsi'),
      ('Sıfır', Icons.new_releases_rounded, 'Yeni'),
      ('İkinci El', Icons.recycling_rounded, 'Kullanılmış'),
    ];

    return Wrap(
      spacing: context.responsive(mobile: 10.0, tablet: 12.0, desktop: 14.0),
      runSpacing: context.responsive(mobile: 10.0, tablet: 12.0, desktop: 14.0),
      children: conditions.map((condition) {
        final isSelected = (filters.condition ?? 'Tümü') == condition.$1;
        return _buildConditionCard(
          label: condition.$1,
          icon: condition.$2,
          subtitle: condition.$3,
          isSelected: isSelected,
          onTap: () => notifier.setCondition(condition.$1),
        );
      }).toList(),
    );
  }

  Widget _buildConditionCard({
    required String label,
    required IconData icon,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final cardWidth = (MediaQuery.of(context).size.width -
            context.responsive(mobile: 60.0, tablet: 72.0, desktop: 84.0)) /
        3;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardWidth,
        padding: EdgeInsets.symmetric(
          vertical:
              context.responsive(mobile: 14.0, tablet: 16.0, desktop: 18.0),
          horizontal:
              context.responsive(mobile: 10.0, tablet: 12.0, desktop: 14.0),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.textSecondary.withOpacity(0.12)
              : AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.textSecondary : AppColors.border,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.textSecondary
                  : AppColors.textSecondary.withOpacity(0.5),
              size:
                  context.responsive(mobile: 26.0, tablet: 28.0, desktop: 30.0),
            ),
            SizedBox(
                height:
                    context.responsive(mobile: 7.0, tablet: 8.0, desktop: 9.0)),
            Text(
              label,
              style: TextStyle(
                fontSize: context.responsive(
                    mobile: 13.5, tablet: 14.0, desktop: 14.5),
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsive(
                    mobile: 10.5, tablet: 11.0, desktop: 11.5),
                color: AppColors.textSecondary.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRangeInputs(dynamic filters, dynamic notifier) {
    return Row(
      children: [
        Expanded(
          child: _buildPriceInput(
            controller: _minPriceController,
            label: 'Minimum',
            hint: '0',
            icon: Icons.arrow_upward_rounded,
            onChanged: (val) {
              final min = double.tryParse(val) ?? 0;
              notifier.setPriceRange(min, filters.maxPrice);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(width: 24, height: 2, color: AppColors.border),
        ),
        Expanded(
          child: _buildPriceInput(
            controller: _maxPriceController,
            label: 'Maksimum',
            hint: '∞',
            icon: Icons.arrow_downward_rounded,
            onChanged: (val) {
              final max = double.tryParse(val) ?? 100000;
              notifier.setPriceRange(filters.minPrice, max);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize:
                context.responsive(mobile: 11.5, tablet: 12.0, desktop: 12.5),
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(
            height: context.responsive(mobile: 7.0, tablet: 8.0, desktop: 9.0)),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            style: TextStyle(
              fontSize:
                  context.responsive(mobile: 15.0, tablet: 15.5, desktop: 16.0),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.4),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
              suffixText: '₺',
              suffixStyle: TextStyle(
                fontSize: context.responsive(
                    mobile: 13.5, tablet: 14.0, desktop: 14.5),
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricePresets(dynamic notifier) {
    final presets = [
      (0.0, 1000.0, '0-1K'),
      (1000.0, 5000.0, '1K-5K'),
      (5000.0, 10000.0, '5K-10K'),
      (10000.0, 100000.0, '10K+'),
    ];

    return Wrap(
      spacing: context.responsive(mobile: 9.0, tablet: 10.0, desktop: 11.0),
      runSpacing: context.responsive(mobile: 9.0, tablet: 10.0, desktop: 11.0),
      children: presets.map((preset) {
        return InkWell(
          onTap: () {
            _minPriceController.text = preset.$1.toInt().toString();
            _maxPriceController.text =
                preset.$2 < 100000 ? preset.$2.toInt().toString() : '';
            notifier.setPriceRange(preset.$1, preset.$2);
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  context.responsive(mobile: 18.0, tablet: 20.0, desktop: 22.0),
              vertical:
                  context.responsive(mobile: 11.0, tablet: 12.0, desktop: 13.0),
            ),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.payments_rounded,
                    size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  preset.$3,
                  style: TextStyle(
                    fontSize: context.responsive(
                        mobile: 13.5, tablet: 14.0, desktop: 14.5),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(
          context.responsive(mobile: 20.0, tablet: 24.0, desktop: 28.0)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: () {
                  widget.onResetFilters();
                  _minPriceController.clear();
                  _maxPriceController.clear();
                  _closeSheet();
                },
                icon: Icon(Icons.refresh_rounded,
                    size: context.responsive(
                        mobile: 19.0, tablet: 20.0, desktop: 21.0)),
                label: Text('Temizle',
                    style: TextStyle(
                        fontSize: context.responsive(
                            mobile: 14.5, tablet: 15.0, desktop: 15.5))),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(color: AppColors.border, width: 1.5),
                  padding: EdgeInsets.symmetric(
                      vertical: context.responsive(
                          mobile: 16.0, tablet: 17.0, desktop: 18.0)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onApplyFilters();
                  _closeSheet();
                },
                icon: Icon(Icons.check_rounded,
                    size: context.responsive(
                        mobile: 19.0, tablet: 20.0, desktop: 21.0)),
                label: Text('Uygula',
                    style: TextStyle(
                        fontSize: context.responsive(
                            mobile: 14.5, tablet: 15.0, desktop: 15.5))),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textSecondary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      vertical: context.responsive(
                          mobile: 16.0, tablet: 17.0, desktop: 18.0)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
