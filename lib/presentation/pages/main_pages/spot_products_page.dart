import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_product_card.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../data/providers/product/product_state.dart';

class SpotProductsPage extends ConsumerStatefulWidget {
  const SpotProductsPage({super.key});

  @override
  ConsumerState<SpotProductsPage> createState() => _SpotProductsPageState();
}

class _SpotProductsPageState extends ConsumerState<SpotProductsPage> {
  String _sortBy = 'newest';
  final List<String> _sortOptions = [
    'newest',
    'price_low',
    'price_high',
    'discount'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);

    return CustomScrollView(
      slivers: [
        // Header with countdown timer
        _buildSpotHeader(context),

        // Sort and Filter Bar
        _buildSortBar(context),

        // Spotlight Banner
        _buildSpotlightBanner(context),

        // Products Grid
        _buildProductsGrid(context, productState),
      ],
    );
  }

  SliverToBoxAdapter _buildSpotHeader(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(24),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D), Color(0xFF4ECDC4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: context.responsive(
          mobile: _buildMobileSpotHeader(context),
          desktop: _buildDesktopSpotHeader(context),
        ),
      ),
    );
  }

  Widget _buildMobileSpotHeader(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpotHeaderBadge(),
        const SizedBox(height: 20),
        Text(
          'Kaçırılmayacak\nFırsatlar',
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive(mobile: 36, desktop: 56),
            fontWeight: FontWeight.bold,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sıfır ve ikinci el ürünlerde %70\'e varan indirimler',
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive(mobile: 16, desktop: 20),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
        _buildCountdownTimer(context),
      ],
    );
  }

  Widget _buildDesktopSpotHeader(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSpotHeaderBadge(),
              const SizedBox(height: 20),
              Text(
                'Kaçırılmayacak\nFırsatlar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.responsive(mobile: 36, desktop: 56),
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sıfır ve ikinci el ürünlerde %70\'e varan indirimler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.responsive(mobile: 16, desktop: 20),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              _buildCountdownTimer(context),
            ],
          ),
        ),
        const SizedBox(width: 60),
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(150),
          ),
          child: Center(
            child: Icon(
              Icons.percent_outlined,
              color: Colors.white.withOpacity(0.4),
              size: 150,
            ),
          ),
        ),
      ],
    );
  }

  Container _buildSpotHeaderBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'SPOT ÜRÜNLER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(final BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (final context, final snapshot) {
        final now = DateTime.now();
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        final remaining = endOfDay.difference(now);

        return Container(
          padding: context.responsive(
            mobile: const EdgeInsets.all(16),
            desktop: const EdgeInsets.all(24),
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white, size: 24),
              const SizedBox(width: 16),
              _buildTimeUnit(
                context,
                remaining.inHours.toString().padLeft(2, '0'),
                'Saat',
              ),
              const SizedBox(width: 8),
              Text(
                ':',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.responsive(mobile: 28, desktop: 32),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              _buildTimeUnit(
                context,
                (remaining.inMinutes % 60).toString().padLeft(2, '0'),
                'Dakika',
              ),
              const SizedBox(width: 8),
              Text(
                ':',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.responsive(mobile: 28, desktop: 32),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              _buildTimeUnit(
                context,
                (remaining.inSeconds % 60).toString().padLeft(2, '0'),
                'Saniye',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeUnit(
      final BuildContext context, final String value, final String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive(mobile: 28, desktop: 32),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildSortBar(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(12),
          desktop: const EdgeInsets.all(20),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 16.0, desktop: 20.0),
          ),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: context.responsive(
          mobile: _buildMobileSortBar(context),
          desktop: _buildDesktopSortBar(context),
        ),
      ),
    );
  }

  Widget _buildMobileSortBar(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.sort_rounded,
              color: AppColors.textSecondary,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Sıralama:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _buildSortChips(),
        ),
        const SizedBox(height: 16),
        _buildProductCountBadge(),
      ],
    );
  }

  Widget _buildDesktopSortBar(final BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.sort_rounded,
          color: AppColors.textSecondary,
          size: 24,
        ),
        const SizedBox(width: 12),
        const Text(
          'Sıralama:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 16),
        ..._buildSortChips(),
        const Spacer(),
        _buildProductCountBadge(),
      ],
    );
  }

  List<Widget> _buildSortChips() {
    return _sortOptions.map((final option) {
      final isSelected = _sortBy == option;
      String label;
      switch (option) {
        case 'newest':
          label = 'En Yeni';
          break;
        case 'price_low':
          label = 'Ucuzdan Pahalıya';
          break;
        case 'price_high':
          label = 'Pahalıdan Ucuza';
          break;
        case 'discount':
          label = 'En Yüksek İndirim';
          break;
        default:
          label = option;
      }

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (final selected) {
            if (selected) {
              setState(() {
                _sortBy = option;
              });
            }
          },
          backgroundColor: AppColors.background,
          selectedColor: AppColors.primary.withOpacity(0.15),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildProductCountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 8),
          Consumer(
            builder: (final context, final ref, final child) {
              final productState = ref.watch(productProvider);
              final count = productState.dataList?.length ?? 0;
              return Text(
                '$count Spot Ürün',
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildSpotlightBanner(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(32),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.secondary.withOpacity(0.2),
              AppColors.accent.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 16.0, desktop: 24.0),
          ),
          border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: context.responsive(
                mobile: const EdgeInsets.all(12),
                desktop: const EdgeInsets.all(20),
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(
                  context.responsive(mobile: 12.0, desktop: 20.0),
                ),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: AppColors.secondary,
                size: context.responsive(mobile: 32, desktop: 48),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 İpucu',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Spot ürünler hızla tükeniyor! Beğendiğiniz ürünü favorilere ekleyerek takip edebilirsiniz.',
                    style: TextStyle(
                      fontSize: context.bodySize,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(
      final BuildContext context, final ProductState productState) {
    final horizontalPadding = context.responsive(mobile: 16.0, desktop: 24.0);

    if (productState.isLoading) {
      return SliverPadding(
        padding: EdgeInsets.all(horizontalPadding),
        sliver: SliverToBoxAdapter(
          child: _buildLoadingState(context),
        ),
      );
    }

    if (productState.errorMessage != null) {
      return SliverPadding(
        padding: EdgeInsets.all(horizontalPadding),
        sliver: SliverToBoxAdapter(
          child: _buildErrorState(context, productState.errorMessage!),
        ),
      );
    }

    final products = productState.dataList ?? [];
    if (products.isEmpty) {
      return SliverPadding(
        padding: EdgeInsets.all(horizontalPadding),
        sliver: SliverToBoxAdapter(
          child: _buildEmptyState(context),
        ),
      );
    }

    // Filter only spot products (you can add a field to Product model)
    final spotProducts = products.where((final p) => !p.isSold).toList();

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          childAspectRatio:
              context.responsive(mobile: 0.72, tablet: 0.78, desktop: 0.75),
          crossAxisSpacing: context.gridSpacing,
          mainAxisSpacing: context.gridSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            return CustomProductCard(
              product: spotProducts[index],
            );
          },
          childCount: spotProducts.length,
        ),
      ),
    );
  }

  Widget _buildLoadingState(final BuildContext context) {
    return Center(
      child: Padding(
        padding: context.responsive(
          mobile: const EdgeInsets.all(32),
          desktop: const EdgeInsets.all(60),
        ),
        child: const Column(
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 24),
            Text(
              'Spot Ürünler Yükleniyor...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(final BuildContext context) {
    return Center(
      child: Padding(
        padding: context.responsive(
          mobile: const EdgeInsets.all(32),
          desktop: const EdgeInsets.all(60),
        ),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 100,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz Spot Ürün Yok',
              style: TextStyle(
                fontSize: context.responsive(mobile: 20, desktop: 24),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Yeni fırsatlar için sayfayı takip etmeye devam edin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(final BuildContext context, final String message) {
    return Center(
      child: Padding(
        padding: context.responsive(
          mobile: const EdgeInsets.all(32),
          desktop: const EdgeInsets.all(60),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Bir Hata Oluştu',
              style: TextStyle(
                fontSize: context.responsive(mobile: 20, desktop: 24),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ref.read(productProvider.notifier).loadProducts();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: context.responsive(
                  mobile: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  desktop: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
