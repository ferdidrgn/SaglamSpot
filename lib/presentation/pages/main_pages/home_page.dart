import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/util/responsive_utils.dart';
import '../../../core/widgets/custom_search_product_card.dart';
import '../../../core/widgets/custom_section_header.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../data/providers/product/product_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
        _buildEnhancedHeroSection(context),
        _buildValueProposition(context),
        _buildCategoriesSection(context),
        _buildFeaturedProducts(context, productState),
        _buildBusinessIntroduction(context),
        _buildSpecialOffers(context),
        _buildNewArrivals(context, productState),
        _buildDeliveryMapSection(context),
        _buildTestimonials(context),
        _buildStatsSection(context),
        SliverToBoxAdapter(
          child: SizedBox(
            height: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 40.0,
              desktop: 60.0,
            ),
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildEnhancedHeroSection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 400.0,
          tablet: 450.0,
          desktop: 550.0,
        ),
        margin: ResponsiveUtils.getScreenPadding(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, scale: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: PageView(
          children: [
            _buildHeroSlide(
              context,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              icon: Icons.weekend_outlined,
              badge: 'Yeni Koleksiyon',
              title: 'Modern Mobilyalar\nEviniz İçin',
              subtitle:
                  'Kaliteli ve şık mobilyalarla yaşam alanınızı yenileyin',
              buttonText: 'Keşfet',
            ),
            _buildHeroSlide(
              context,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondary,
                  AppColors.secondary.withOpacity(0.7)
                ],
              ),
              icon: Icons.percent_outlined,
              badge: 'Spot Ürünler',
              title: 'İnanılmaz Fırsatlar\nSizi Bekliyor',
              subtitle: '%70\'e varan indirimlerle kaliteli mobilyalar',
              buttonText: 'Fırsatları Gör',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSlide(
    final BuildContext context, {
    required final Gradient gradient,
    required final IconData icon,
    required final String badge,
    required final String title,
    required final String subtitle,
    required final String buttonText,
  }) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context, scale: 2),
        ),
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Decorative circles
          if (!isMobile) ...[
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 200.0,
                  desktop: 400.0,
                ),
                height: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 200.0,
                  desktop: 400.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 40,
              bottom: 40,
              child: Container(
                width: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 150.0,
                  desktop: 300.0,
                ),
                height: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 150.0,
                  desktop: 300.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(150),
                ),
                child: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.3),
                  size: ResponsiveUtils.getValueForDevice(
                    context,
                    mobile: 70.0,
                    desktop: 140.0,
                  ),
                ),
              ),
            ),
          ],
          // Content
          Padding(
            padding: ResponsiveUtils.getScreenPadding(context).copyWith(
              top: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 40.0,
                desktop: 60.0,
              ),
              bottom: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 40.0,
                desktop: 60.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getValueForDevice(
                      context,
                      mobile: 12.0,
                      desktop: 20.0,
                    ),
                    vertical: ResponsiveUtils.getValueForDevice(
                      context,
                      mobile: 6.0,
                      desktop: 10.0,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.getCaptionFontSize(context) + 3,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getValueForDevice(
                    context,
                    mobile: 16.0,
                    desktop: 24.0,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveUtils.getValueForDevice(
                      context,
                      mobile: 32.0,
                      tablet: 42.0,
                      desktop: 56.0,
                    ),
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getValueForDevice(
                    context,
                    mobile: 12.0,
                    desktop: 20.0,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveUtils.getValueForDevice(
                      context,
                      mobile: 14.0,
                      tablet: 16.0,
                      desktop: 20.0,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getValueForDevice(
                    context,
                    mobile: 24.0,
                    desktop: 40.0,
                  ),
                ),
                Wrap(
                  spacing: ResponsiveUtils.getValueForDevice(
                    context,
                    mobile: 8.0,
                    desktop: 16.0,
                  ),
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getValueForDevice(
                            context,
                            mobile: 24.0,
                            desktop: 40.0,
                          ),
                          vertical: ResponsiveUtils.getValueForDevice(
                            context,
                            mobile: 12.0,
                            desktop: 20.0,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonText,
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.getBodyFontSize(context) + 4,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: ResponsiveUtils.getIconSize(context),
                          ),
                        ],
                      ),
                    ),
                    if (!isMobile)
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.getValueForDevice(
                              context,
                              mobile: 20.0,
                              desktop: 32.0,
                            ),
                            vertical: ResponsiveUtils.getValueForDevice(
                              context,
                              mobile: 12.0,
                              desktop: 20.0,
                            ),
                          ),
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Daha Fazla',
                          style: TextStyle(
                            fontSize:
                                ResponsiveUtils.getBodyFontSize(context) + 4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildValueProposition(final BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return SliverToBoxAdapter(
      child: Container(
        margin: ResponsiveUtils.getScreenPadding(context).copyWith(
          top: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 16.0,
            desktop: 20.0,
          ),
          bottom: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 16.0,
            desktop: 20.0,
          ),
        ),
        padding: ResponsiveUtils.getCardPadding(context).copyWith(
          top: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 20.0,
            desktop: 32.0,
          ),
          bottom: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 20.0,
            desktop: 32.0,
          ),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, scale: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isMobile
            ? Column(
                children: [
                  _buildValueItem(context, Icons.verified_outlined, 'Güvenilir',
                      'Kalite garantisi', AppColors.success),
                  const SizedBox(height: 16),
                  _buildValueItem(context, Icons.local_shipping_outlined,
                      'Hızlı Teslimat', 'Ücretsiz kargo', AppColors.info),
                  const SizedBox(height: 16),
                  _buildValueItem(context, Icons.attach_money_outlined,
                      'En İyi Fiyat', 'Uygun ödeme', AppColors.warning),
                  const SizedBox(height: 16),
                  _buildValueItem(
                      context,
                      Icons.access_time_outlined,
                      '9:00 - 22:00',
                      'Müşteri hizmetleri',
                      AppColors.secondary),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildValueItem(context, Icons.verified_outlined,
                        'Güvenilir', 'Kalite garantisi', AppColors.success),
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: AppColors.border,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  Expanded(
                    child: _buildValueItem(
                        context,
                        Icons.local_shipping_outlined,
                        'Hızlı Teslimat',
                        'Ücretsiz kargo',
                        AppColors.info),
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: AppColors.border,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  Expanded(
                    child: _buildValueItem(context, Icons.attach_money_outlined,
                        'En İyi Fiyat', 'Uygun ödeme', AppColors.warning),
                  ),
                  Container(
                    width: 1,
                    height: 60,
                    color: AppColors.border,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  Expanded(
                    child: _buildValueItem(
                        context,
                        Icons.access_time_outlined,
                        '9:00 - 22:00',
                        'Müşteri hizmetleri',
                        AppColors.secondary),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildValueItem(
    final BuildContext context,
    final IconData icon,
    final String title,
    final String subtitle,
    final Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.getValueForDevice(
              context,
              mobile: 12.0,
              desktop: 16.0,
            ),
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: color,
            size: ResponsiveUtils.getIconSize(context, scale: 1.6),
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 8.0,
            desktop: 12.0,
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveUtils.getTitleFontSize(context) + 2,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveUtils.getBodyFontSize(context),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildCategoriesSection(final BuildContext context) {
    const categories = [
      {
        'icon': Icons.chair_outlined,
        'label': 'Sandalye',
        'count': '234+',
        'color': AppColors.primary
      },
      {
        'icon': Icons.weekend_outlined,
        'label': 'Kanepe',
        'count': '156+',
        'color': AppColors.secondary
      },
      {
        'icon': Icons.bed_outlined,
        'label': 'Yatak',
        'count': '189+',
        'color': AppColors.accent
      },
      {
        'icon': Icons.table_restaurant_outlined,
        'label': 'Masa',
        'count': '278+',
        'color': AppColors.info
      },
      {
        'icon': Icons.tv_outlined,
        'label': 'TV Ünitesi',
        'count': '145+',
        'color': AppColors.warning
      },
      {
        'icon': Icons.light_outlined,
        'label': 'Aydınlatma',
        'count': '92+',
        'color': AppColors.success
      },
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: ResponsiveUtils.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Kategoriler',
              subtitle: 'İhtiyacınıza uygun mobilyaları keşfedin',
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 16.0,
                desktop: 24.0,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 2,
                  tablet: 3,
                  desktop: 6,
                ),
                crossAxisSpacing: ResponsiveUtils.getGridSpacing(context),
                mainAxisSpacing: ResponsiveUtils.getGridSpacing(context),
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (final context, final index) {
                final category = categories[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      print('${category['label']} tıklandı');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.getBorderRadius(context, scale: 1.25),
                        ),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (category['color'] as Color).withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              ResponsiveUtils.getValueForDevice(
                                context,
                                mobile: 12.0,
                                desktop: 16.0,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (category['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: category['color'] as Color,
                              size: ResponsiveUtils.getIconSize(context,
                                  scale: 1.6),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveUtils.getValueForDevice(
                              context,
                              mobile: 8.0,
                              desktop: 12.0,
                            ),
                          ),
                          Text(
                            category['label'] as String,
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.getTitleFontSize(context),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category['count'] as String,
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.getBodyFontSize(context),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 32.0,
                desktop: 48.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturedProducts(
    final BuildContext context,
    final ProductState productState,
  ) {
    final featuredProducts = productState.dataList?.take(6).toList() ?? [];

    if (featuredProducts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: ResponsiveUtils.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Öne Çıkan Ürünler',
              subtitle: 'En çok beğenilen mobilyalar',
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 16.0,
                desktop: 20.0,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 280.0,
                desktop: 320.0,
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredProducts.length,
                separatorBuilder: (final context, final index) => SizedBox(
                  width: ResponsiveUtils.getGridSpacing(context),
                ),
                itemBuilder: (final context, final index) {
                  final product = featuredProducts[index];
                  return SizedBox(
                    width: ResponsiveUtils.getValueForDevice(
                      context,
                      mobile: 220.0,
                      tablet: 250.0,
                      desktop: 280.0,
                    ),
                    child: ModernProductCard(product: product),
                  );
                },
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 24.0,
                desktop: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBusinessIntroduction(final BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return SliverToBoxAdapter(
      child: Container(
        margin: ResponsiveUtils.getScreenPadding(context).copyWith(
          top: 16,
          bottom: 16,
        ),
        padding: ResponsiveUtils.getCardPadding(context).copyWith(
          top: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 24.0,
            desktop: 40.0,
          ),
          bottom: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 24.0,
            desktop: 40.0,
          ),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, scale: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isMobile
            ? Column(
                children: [
                  Container(
                    width: ResponsiveUtils.getValueForDevice(
                      context,
                      mobile: 80.0,
                      desktop: 120.0,
                    ),
                    height: ResponsiveUtils.getValueForDevice(
                      context,
                      mobile: 80.0,
                      desktop: 120.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      color: AppColors.primary,
                      size: ResponsiveUtils.getIconSize(context, scale: 2.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '20 Yıllık Esnaf Güvencesi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getValueForDevice(
                            context,
                            mobile: 20.0,
                            desktop: 28.0,
                          ),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '2003\'ten beri İstanbul\'da hizmet veren köklü bir esnaf firmasıyız. '
                        'Müşteri memnuniyetini her zaman ön planda tutarak, kaliteli ve güvenilir '
                        'alışverişin adresi olduk.',
                        style: TextStyle(
                          fontSize:
                              ResponsiveUtils.getBodyFontSize(context) + 2,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildBusinessFeature(context, '✓ Kalite Garantisi'),
                          _buildBusinessFeature(
                              context, '✓ Profesyonel Montaj'),
                          _buildBusinessFeature(
                              context, '✓ Geri Alım Garantisi'),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(
                      Icons.storefront_outlined,
                      color: AppColors.primary,
                      size: 50,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '20 Yıllık Esnaf Güvencesi',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getValueForDevice(
                              context,
                              mobile: 20.0,
                              desktop: 28.0,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '2003\'ten beri İstanbul\'da hizmet veren köklü bir esnaf firmasıyız. '
                          'Müşteri memnuniyetini her zaman ön planda tutarak, kaliteli ve güvenilir '
                          'alışverişin adresi olduk.',
                          style: TextStyle(
                            fontSize:
                                ResponsiveUtils.getBodyFontSize(context) + 2,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: ResponsiveUtils.getValueForDevice(
                            context,
                            mobile: 8.0,
                            desktop: 20.0,
                          ),
                          runSpacing: 12,
                          children: [
                            _buildBusinessFeature(
                                context, '✓ Kalite Garantisi'),
                            _buildBusinessFeature(
                                context, '✓ Profesyonel Montaj'),
                            _buildBusinessFeature(
                                context, '✓ Geri Alım Garantisi'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBusinessFeature(final BuildContext context, final String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 10.0,
          desktop: 12.0,
        ),
        vertical: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 4.0,
          desktop: 6.0,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
          fontSize: ResponsiveUtils.getBodyFontSize(context),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSpecialOffers(final BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return SliverToBoxAdapter(
      child: Container(
        margin: ResponsiveUtils.getScreenPadding(context).copyWith(
          top: 16,
          bottom: 16,
        ),
        padding: ResponsiveUtils.getCardPadding(context).copyWith(
          top: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 24.0,
            desktop: 40.0,
          ),
          bottom: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 24.0,
            desktop: 40.0,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, scale: 1.5),
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B6B).withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: isMobile
            ? Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.getValueForDevice(
                            context,
                            mobile: 12.0,
                            desktop: 16.0,
                          ),
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🔥 Sınırlı Süre',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveUtils.getBodyFontSize(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Süper İndirimler!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveUtils.getValueForDevice(
                            context,
                            mobile: 28.0,
                            desktop: 36.0,
                          ),
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Seçili ürünlerde %70\'e varan indirim fırsatı. Kaçırmayın!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              ResponsiveUtils.getBodyFontSize(context) + 2,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFFF6B6B),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.getValueForDevice(
                              context,
                              mobile: 24.0,
                              desktop: 32.0,
                            ),
                            vertical: ResponsiveUtils.getValueForDevice(
                              context,
                              mobile: 12.0,
                              desktop: 16.0,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Fırsatları Gör',
                          style: TextStyle(
                            fontSize:
                                ResponsiveUtils.getBodyFontSize(context) + 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_offer_outlined,
                      color: Colors.white.withOpacity(0.7),
                      size: 50,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '🔥 Sınırlı Süre',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  ResponsiveUtils.getBodyFontSize(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Süper İndirimler!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveUtils.getValueForDevice(
                              context,
                              mobile: 28.0,
                              desktop: 36.0,
                            ),
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Seçili ürünlerde %70\'e varan indirim fırsatı. Kaçırmayın!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                ResponsiveUtils.getBodyFontSize(context) + 2,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFFF6B6B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Fırsatları Gör',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.getBodyFontSize(context) + 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_offer_outlined,
                      color: Colors.white.withOpacity(0.7),
                      size: 50,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  SliverToBoxAdapter _buildNewArrivals(
    final BuildContext context,
    final ProductState productState,
  ) {
    final newArrivals = productState.dataList ?? [];
    if (newArrivals.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: ResponsiveUtils.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Yeni Gelenler',
              subtitle: 'En yeni mobilya tasarımları',
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 16.0,
                desktop: 20.0,
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
                crossAxisSpacing: ResponsiveUtils.getGridSpacing(context),
                mainAxisSpacing: ResponsiveUtils.getGridSpacing(context),
                childAspectRatio: ResponsiveUtils.getCardAspectRatio(context),
              ),
              itemCount: newArrivals.length.clamp(0, 8),
              itemBuilder: (final context, final index) {
                final product = newArrivals[index];
                return ModernProductCard(product: product);
              },
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 24.0,
                desktop: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDeliveryMapSection(final BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return SliverToBoxAdapter(
      child: Container(
        margin: ResponsiveUtils.getScreenPadding(context).copyWith(
          top: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, scale: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: ResponsiveUtils.getCardPadding(context).copyWith(
            top: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 20.0,
              desktop: 32.0,
            ),
            bottom: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 20.0,
              desktop: 32.0,
            ),
          ),
          child: isMobile
              ? Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teslimat Bilgileri',
                          style: TextStyle(
                            fontSize:
                                ResponsiveUtils.getTitleFontSize(context) + 4,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDeliveryInfo(
                          context,
                          '🚚 Ücretsiz Teslimat',
                          'İstanbul İçerenköy ve yakın mahalleleri',
                        ),
                        _buildDeliveryInfo(
                          context,
                          '⏰ Teslimat Saatleri',
                          '09:00 - 22:00',
                        ),
                        _buildDeliveryInfo(
                          context,
                          '📍 Hizmet Verilen Semtler',
                          'İçerenköy, Küçükbakkalköy, Kayışdağı',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.getValueForDevice(
                          context,
                          mobile: 20.0,
                          desktop: 24.0,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: AppColors.primary,
                            size:
                                ResponsiveUtils.getIconSize(context, scale: 2),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Çalışma Saatleri',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.getTitleFontSize(context),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pazartesi - Cumartesi\n09:00 - 22:00',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  ResponsiveUtils.getBodyFontSize(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pazar: 12:00 - 20:00',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize:
                                  ResponsiveUtils.getCaptionFontSize(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Teslimat Bilgileri',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.getTitleFontSize(context) + 4,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDeliveryInfo(
                            context,
                            '🚚 Ücretsiz Teslimat',
                            'İstanbul İçerenköy ve yakın mahalleleri',
                          ),
                          _buildDeliveryInfo(
                            context,
                            '⏰ Teslimat Saatleri',
                            '09:00 - 22:00',
                          ),
                          _buildDeliveryInfo(
                            context,
                            '📍 Hizmet Verilen Semtler',
                            'İçerenköy, Küçükbakkalköy, Kayışdağı, Fındıklı',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.access_time_filled,
                            color: AppColors.primary,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Çalışma Saatleri',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.getTitleFontSize(context),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Pazartesi - Cumartesi\n09:00 - 22:00',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Pazar: 12:00 - 20:00',
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(
    final BuildContext context,
    final String title,
    final String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outlined,
            color: AppColors.success,
            size: ResponsiveUtils.getIconSize(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveUtils.getBodyFontSize(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: ResponsiveUtils.getBodyFontSize(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildTestimonials(final BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final crossAxisCount = ResponsiveUtils.getValueForDevice(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );

    return SliverToBoxAdapter(
      child: Container(
        margin: ResponsiveUtils.getScreenPadding(context).copyWith(
          top: 16,
          bottom: 16,
        ),
        padding: ResponsiveUtils.getCardPadding(context).copyWith(
          top: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 32.0,
            desktop: 48.0,
          ),
          bottom: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 32.0,
            desktop: 48.0,
          ),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, scale: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Müşterilerimiz Ne Diyor?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 24.0,
                  desktop: 32.0,
                ),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(
              height: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 24.0,
                desktop: 40.0,
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: ResponsiveUtils.getGridSpacing(context),
              mainAxisSpacing: ResponsiveUtils.getGridSpacing(context),
              childAspectRatio: isMobile ? 1.5 : 1.2,
              children: [
                _buildTestimonialCard(
                  context,
                  'Ürünler tam olarak görseldeki gibi.',
                  'Ayşe K.',
                  '⭐⭐⭐⭐⭐',
                ),
                _buildTestimonialCard(
                  context,
                  'Hızlı montaj. Kesinlikle tavsiye ederim.',
                  'Mehmet Y.',
                  '⭐⭐⭐⭐⭐',
                ),
                _buildTestimonialCard(
                  context,
                  'Fiyatlar çok uygun.',
                  'Zeynep A.',
                  '⭐⭐⭐⭐⭐',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(
    final BuildContext context,
    final String comment,
    final String name,
    final String rating,
  ) {
    return Container(
      padding: ResponsiveUtils.getCardPadding(context).copyWith(
        top: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 16.0,
          desktop: 24.0,
        ),
        bottom: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 16.0,
          desktop: 24.0,
        ),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context, scale: 1.25),
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rating,
            style: TextStyle(
              fontSize: ResponsiveUtils.getTitleFontSize(context) + 4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: TextStyle(
              fontSize: ResponsiveUtils.getBodyFontSize(context) + 2,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getBodyFontSize(context) + 2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildStatsSection(final BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return SliverToBoxAdapter(
      child: Container(
        margin: ResponsiveUtils.getScreenPadding(context).copyWith(
          top: 16,
          bottom: 16,
        ),
        padding: ResponsiveUtils.getCardPadding(context).copyWith(
          top: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 32.0,
            desktop: 48.0,
          ),
          bottom: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 32.0,
            desktop: 48.0,
          ),
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(context, scale: 2),
          ),
        ),
        child: isMobile
            ? Column(
                children: [
                  _buildStatItem(context, '2,500+', 'Mutlu Müşteri'),
                  const SizedBox(height: 24),
                  _buildStatItem(context, '5,000+', 'Satılan Ürün'),
                  const SizedBox(height: 24),
                  _buildStatItem(context, '97%', 'Memnuniyet Oranı'),
                  const SizedBox(height: 24),
                  _buildStatItem(context, '20+', 'Yıllık Deneyim'),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(context, '2,500+', 'Mutlu Müşteri'),
                  _buildStatItem(context, '5,000+', 'Satılan Ürün'),
                  _buildStatItem(context, '97%', 'Memnuniyet Oranı'),
                  _buildStatItem(context, '20+', 'Yıllık Deneyim'),
                ],
              ),
      ),
    );
  }

  Widget _buildStatItem(
      final BuildContext context, final String number, final String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 36.0,
              desktop: 48.0,
            ),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveUtils.getBodyFontSize(context) + 4,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
