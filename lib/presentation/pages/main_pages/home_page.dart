import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/util/responsive_utils.dart'; // Extension'lar için import gerekli
import '../../../core/widgets/custom_product_card.dart';
import '../../../core/widgets/custom_section_header.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../data/providers/product/product_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

// Mixin kaldırıldı, extension'lar kullanılacak
class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (mounted) {
        ref.read(productProvider.notifier).loadProducts();
      }
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
                height: context.responsive(mobile: 30.0, desktop: 60.0))),
      ],
    );
  }

  SliverToBoxAdapter _buildEnhancedHeroSection(final BuildContext context) {
    final bool mobile = context.isMobile; // Extension kullanımı

    return SliverToBoxAdapter(
      child: Container(
        height:
            context.responsive(mobile: 400.0, tablet: 500.0, desktop: 550.0),
        margin: EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 24.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 24.0, desktop: 32.0)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: context.responsive(mobile: 20.0, desktop: 40.0),
              offset:
                  Offset(0, context.responsive(mobile: 10.0, desktop: 20.0)),
            ),
          ],
        ),
        child: PageView(
          children: [
            _buildHeroSlide(
              context: context,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              icon: Icons.weekend_outlined,
              badge: 'Yeni Koleksiyon',
              title: mobile
                  ? 'Modern Mobilyalar'
                  : 'Modern Mobilyalar\nEviniz İçin',
              subtitle:
                  'Kaliteli ve şık mobilyalarla yaşam alanınızı yenileyin',
              buttonText: 'Keşfet',
            ),
            _buildHeroSlide(
              context: context,
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
              title: mobile
                  ? 'İnanılmaz Fırsatlar'
                  : 'İnanılmaz Fırsatlar\nSizi Bekliyor',
              subtitle: '%70\'e varan indirimlerle kaliteli mobilyalar',
              buttonText: 'Fırsatları Gör',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSlide({
    required final BuildContext context,
    required final Gradient gradient,
    required final IconData icon,
    required final String badge,
    required final String title,
    required final String subtitle,
    required final String buttonText,
  }) {
    final bool mobile = context.isMobile;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0)),
        gradient: gradient,
      ),
      child: Stack(
        children: [
          if (!mobile)
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (!mobile)
            Positioned(
              right: 40,
              bottom: 40,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(150),
                ),
                child: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.3),
                  size: 140,
                ),
              ),
            ),
          // Content
          Padding(
            padding: EdgeInsets.all(
                context.responsive(mobile: 24.0, tablet: 40.0, desktop: 60.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          context.responsive(mobile: 16.0, desktop: 20.0),
                      vertical: context.responsive(mobile: 8.0, desktop: 10.0)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.responsive(mobile: 12.0, desktop: 15.0),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(
                    height: context.responsive(mobile: 16.0, desktop: 24.0)),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.responsive(mobile: 28.0, desktop: 56.0),
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(
                    height: context.responsive(mobile: 12.0, desktop: 20.0)),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.responsive(mobile: 14.0, desktop: 20.0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                    height: context.responsive(mobile: 24.0, desktop: 40.0)),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              context.responsive(mobile: 24.0, desktop: 40.0),
                          vertical:
                              context.responsive(mobile: 16.0, desktop: 20.0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              context.responsive(mobile: 12.0, desktop: 16.0)),
                        ),
                        elevation: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonText,
                            style: TextStyle(
                              fontSize: context.responsive(
                                  mobile: 14.0, desktop: 18.0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded,
                              size: context.responsive(
                                  mobile: 16.0, desktop: 20.0)),
                        ],
                      ),
                    ),
                    if (!mobile)
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
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
                                context.responsive(mobile: 14.0, desktop: 18.0),
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
    final bool mobile = context.isMobile;

    final items = [
      _buildValueItem(
        context,
        Icons.verified_outlined,
        'Güvenilir',
        'Kalite garantisi',
        AppColors.success,
      ),
      _buildValueItem(
        context,
        Icons.local_shipping_outlined,
        'Hızlı Teslimat',
        'Ücretsiz kargo',
        AppColors.info,
      ),
      _buildValueItem(
        context,
        Icons.attach_money_outlined,
        'En İyi Fiyat',
        'Uygun ödeme seçenekleri',
        AppColors.warning,
      ),
      _buildValueItem(
        context,
        Icons.access_time_outlined,
        '9:00 - 22:00',
        'Müşteri hizmetleri',
        AppColors.secondary,
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: 20),
        padding:
            EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 32.0)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: mobile
            ? Column(
                children: [
                  items[0],
                  const SizedBox(height: 16),
                  items[1],
                  const SizedBox(height: 16),
                  items[2],
                  const SizedBox(height: 16),
                  items[3],
                ],
              )
            : Row(
                children: [
                  Expanded(child: items[0]),
                  Container(width: 1, height: 60, color: AppColors.border),
                  Expanded(child: items[1]),
                  Container(width: 1, height: 60, color: AppColors.border),
                  Expanded(child: items[2]),
                  Container(width: 1, height: 60, color: AppColors.border),
                  Expanded(child: items[3]),
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
          padding:
              EdgeInsets.all(context.responsive(mobile: 12.0, desktop: 16.0)),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon,
              color: color,
              size: context.responsive(mobile: 24.0, desktop: 32.0)),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: context.responsive(mobile: 16.0, desktop: 18.0),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: context.responsive(mobile: 12.0, desktop: 14.0),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildCategoriesSection(final BuildContext context) {
    const categories = [
      // ... (category data)
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Kategoriler',
              subtitle: 'İhtiyacınıza uygun mobilyaları keşfedin',
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.gridColumns(6), // Extension
                crossAxisSpacing: context.gridSpacing, // Extension
                mainAxisSpacing: context.gridSpacing, // Extension
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
                        borderRadius: BorderRadius.circular(20),
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
                            padding: EdgeInsets.all(context.responsive(
                                mobile: 12.0, desktop: 16.0)),
                            decoration: BoxDecoration(
                              color:
                                  (category['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: category['color'] as Color,
                              size: context.responsive(
                                  mobile: 24.0, desktop: 32.0),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category['label'] as String,
                            style: TextStyle(
                              fontSize: context.responsive(
                                  mobile: 14.0, desktop: 16.0),
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category['count'] as String,
                            style: TextStyle(
                              fontSize: context.responsive(
                                  mobile: 12.0, desktop: 14.0),
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
            SizedBox(height: context.responsive(mobile: 24.0, desktop: 48.0)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturedProducts(
      final BuildContext context, final ProductState productState) {
    final featuredProducts = productState.dataList?.take(6).toList() ?? [];

    if (featuredProducts.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox());

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
                title: 'Öne Çıkan Ürünler',
                subtitle: 'En çok beğenilen mobilyalar'),
            const SizedBox(height: 20),
            SizedBox(
              height: context.responsive(
                  mobile: 300.0, tablet: 320.0, desktop: 320.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredProducts.length,
                separatorBuilder: (final context, final index) =>
                    SizedBox(width: context.gridSpacing), // Extension
                itemBuilder: (final context, final index) {
                  final product = featuredProducts[index];
                  return CustomProductCard(product: product);
                },
              ),
            ),
            SizedBox(height: context.responsive(mobile: 20.0, desktop: 40.0)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBusinessIntroduction(final BuildContext context) {
    final bool mobile = context.isMobile;

    final widgetContent = [
      Container(
        width: context.responsive(mobile: 80.0, desktop: 120.0),
        height: context.responsive(mobile: 80.0, desktop: 120.0),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 40.0, desktop: 60.0)),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Icon(Icons.storefront_outlined,
            color: AppColors.primary,
            size: context.responsive(mobile: 30.0, desktop: 50.0)),
      ),
      SizedBox(
        width: mobile ? 0 : 32,
        height: mobile ? 20 : 0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment:
              mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              '20 Yıllık Esnaf Güvencesi',
              textAlign: mobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                fontSize: context.responsive(mobile: 20.0, desktop: 28.0),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '2003\'ten beri İstanbul\'da hizmet veren köklü bir esnaf firmasıyız. '
              'Müşteri memnuniyetini her zaman ön planda tutarak, kaliteli ve güvenilir '
              'alışverişin adresi olduk.',
              textAlign: mobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: mobile ? WrapAlignment.center : WrapAlignment.start,
              children: [
                _buildBusinessFeature('✓ Kalite Garantisi'),
                _buildBusinessFeature('✓ Profesyonel Montaj'),
                _buildBusinessFeature('✓ Geri Alım Garantisi'),
              ],
            ),
          ],
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: 20),
        padding:
            EdgeInsets.all(context.responsive(mobile: 24.0, desktop: 40.0)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4)),
          ],
        ),
        child: mobile
            ? Column(children: widgetContent)
            : Row(children: widgetContent),
      ),
    );
  }

  Widget _buildBusinessFeature(final String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSpecialOffers(final BuildContext context) {
    final bool mobile = context.isMobile;

    final content = [
      Expanded(
        child: Column(
          crossAxisAlignment:
              mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '🔥 Sınırlı Süre',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.responsive(mobile: 12.0, desktop: 14.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Süper İndirimler!',
              textAlign: mobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: context.responsive(mobile: 24.0, desktop: 36.0),
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Seçili ürünlerde %70\'e varan indirim fırsatı. Kaçırmayın!',
              textAlign: mobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
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
                    horizontal: context.responsive(mobile: 24.0, desktop: 32.0),
                    vertical: context.responsive(mobile: 14.0, desktop: 16.0)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Fırsatları Gör',
                style: TextStyle(
                    fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: mobile ? 0 : 40, height: mobile ? 20 : 0),
      Container(
        width: context.responsive(mobile: 80.0, desktop: 120.0),
        height: context.responsive(mobile: 80.0, desktop: 120.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.local_offer_outlined,
            color: Colors.white.withOpacity(0.7),
            size: context.responsive(mobile: 30.0, desktop: 50.0)),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: 20),
        padding:
            EdgeInsets.all(context.responsive(mobile: 24.0, desktop: 40.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
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
        child: mobile ? Column(children: content) : Row(children: content),
      ),
    );
  }

  SliverToBoxAdapter _buildNewArrivals(
      final BuildContext context, final ProductState productState) {
    final newArrivals = productState.dataList ?? [];
    if (newArrivals.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

    // getCardAspectRatio extension'da yok, bu yüzden responsive() kullandık
    final cardAspectRatio =
        context.responsive(mobile: 0.72, tablet: 0.78, desktop: 0.80);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
                title: 'Yeni Gelenler',
                subtitle: 'En yeni mobilya tasarımları'),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.gridColumns(4), // Extension
                crossAxisSpacing: context.gridSpacing, // Extension
                mainAxisSpacing: context.gridSpacing, // Extension
                childAspectRatio: cardAspectRatio,
              ),
              itemCount: newArrivals.length.clamp(0, context.isMobile ? 4 : 8),
              itemBuilder: (final context, final index) {
                final product = newArrivals[index];
                return CustomProductCard(product: product);
              },
            ),
            SizedBox(height: context.responsive(mobile: 20.0, desktop: 40.0)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDeliveryMapSection(final BuildContext context) {
    final bool mobile = context.isMobile;

    final content = [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teslimat Bilgileri',
              style: TextStyle(
                  fontSize: context.responsive(mobile: 18.0, desktop: 20.0),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildDeliveryInfo(context, '🚚 Ücretsiz Teslimat',
                'İstanbul İçerenköy ve yakın mahalleleri'),
            _buildDeliveryInfo(context, '⏰ Teslimat Saatleri', '09:00 - 22:00'),
            _buildDeliveryInfo(context, '📍 Hizmet Verilen Semtler',
                'İçerenköy, Küçükbakkalköy, Kayışdağı, Fındıklı, İnönü, Bostancı Sanayi'),
          ],
        ),
      ),
      SizedBox(width: mobile ? 0 : 40, height: mobile ? 24 : 0),
      Container(
        padding:
            EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 24.0)),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(Icons.access_time_filled,
                color: AppColors.primary,
                size: context.responsive(mobile: 30.0, desktop: 40.0)),
            const SizedBox(height: 12),
            Text(
              'Çalışma Saatleri',
              style: TextStyle(
                fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
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
                  fontSize: context.responsive(mobile: 12.0, desktop: 14.0)),
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
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: 20),
        padding:
            EdgeInsets.all(context.responsive(mobile: 20.0, desktop: 32.0)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4)),
          ],
        ),
        child: mobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: content)
            : Row(children: content),
      ),
    );
  }

  Widget _buildDeliveryInfo(
      final BuildContext context, final String title, final String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outlined,
              color: AppColors.success,
              size: context.responsive(mobile: 18.0, desktop: 20.0)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:
                            context.responsive(mobile: 14.0, desktop: 16.0),
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize:
                            context.responsive(mobile: 12.0, desktop: 14.0))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildTestimonials(final BuildContext context) {
    final bool mobile = context.isMobile;

    final items = [
      Expanded(
          child: _buildTestimonialCard(context,
              'Ürünler tam olarak görseldeki gibi.', 'Ayşe K.', '⭐⭐⭐⭐⭐')),
      SizedBox(width: mobile ? 0 : 24, height: mobile ? 16 : 0),
      Expanded(
          child: _buildTestimonialCard(
              context,
              'Hızlı montaj. Kesinlikle tavsiye ederim.',
              'Mehmet Y.',
              '⭐⭐⭐⭐⭐')),
      SizedBox(width: mobile ? 0 : 24, height: mobile ? 16 : 0),
      Expanded(
          child: _buildTestimonialCard(
              context, 'Fiyatlar çok uygun.', 'Zeynep A.', '⭐⭐⭐⭐⭐')),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: 20),
        padding:
            EdgeInsets.all(context.responsive(mobile: 24.0, desktop: 48.0)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Text('Müşterilerimiz Ne Diyor?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: context.responsive(mobile: 22.0, desktop: 32.0),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            SizedBox(height: context.responsive(mobile: 20.0, desktop: 40.0)),
            mobile ? Column(children: items) : Row(children: items),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(final BuildContext context, final String comment,
      final String name, final String rating) {
    return Container(
      padding: EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 24.0)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rating,
              style: TextStyle(
                  fontSize: context.responsive(mobile: 16.0, desktop: 20.0))),
          const SizedBox(height: 12),
          Text(comment,
              style: TextStyle(
                  fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
                  color: AppColors.textSecondary,
                  height: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(name,
                  style: TextStyle(
                      fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildStatsSection(final BuildContext context) {
    final bool mobile = context.isMobile;

    final items = [
      _buildStatItem(context, '2,500+', 'Mutlu Müşteri'),
      SizedBox(height: mobile ? 24 : 0),
      _buildStatItem(context, '5,000+', 'Satılan Ürün'),
      SizedBox(height: mobile ? 24 : 0),
      _buildStatItem(context, '97%', 'Memnuniyet Oranı'),
      SizedBox(height: mobile ? 24 : 0),
      _buildStatItem(context, '20+', 'Yıllık Deneyim'),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: 20),
        padding:
            EdgeInsets.all(context.responsive(mobile: 32.0, desktop: 48.0)),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: mobile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items),
      ),
    );
  }

  Widget _buildStatItem(
      final BuildContext context, final String number, final String label) {
    return Column(
      children: [
        Text(number,
            style: TextStyle(
                fontSize: context.responsive(mobile: 32.0, desktop: 48.0),
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                fontSize: context.responsive(mobile: 16.0, desktop: 18.0),
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
