import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_section_header.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../data/providers/product/product_state.dart';

// RESPONSIVE UTILS İÇİN EKLENDİ
import '../../../core/util/responsive_utils.dart';

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
      // initState içinde ref.read kullanmak best practice'dir.
      if (mounted) {
        ref.read(productProvider.notifier).loadProducts();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);
    // Responsive extension'dan isMobile bilgisini alıyoruz
    final isMobile = context.isMobile;

    return CustomScrollView(
      slivers: [
        // Hero Section
        _buildEnhancedHeroSection(context, isMobile),

        // Value Proposition
        _buildValueProposition(context, isMobile),

        // Categories Section
        _buildCategoriesSection(context),

        // Featured Products (İsteğiniz üzerine 10 ürün gösterecek şekilde güncellendi)
        _buildFeaturedProducts(context, productState),

        // Esnaf Tanıtımı
        _buildBusinessIntroduction(context, isMobile),

        // Special Offers
        _buildSpecialOffers(context, isMobile),

        // New Arrivals
        _buildNewArrivals(context, productState),

        // Google Maps & Teslimat Bilgisi
        _buildDeliveryMapSection(context, isMobile),

        // Testimonials
        _buildTestimonials(context, isMobile),

        // Stats Section
        _buildStatsSection(context, isMobile),

        // Alt boşluk
        SliverToBoxAdapter(
            child: SizedBox(
                height: context.responsive(mobile: 30.0, desktop: 60.0))),
      ],
    );
  }

  SliverToBoxAdapter _buildEnhancedHeroSection(
      final BuildContext context, final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        height: context.responsive(mobile: 400.0, desktop: 550.0),
        margin: EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 24.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 24.0, desktop: 32.0)),
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
              context: context,
              isMobile: isMobile,
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
              context: context,
              isMobile: isMobile,
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
            _buildHeroSlide(
              context: context,
              isMobile: isMobile,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.accent, Color(0xFF7C3AED)],
              ),
              icon: Icons.recycling_outlined,
              badge: 'İkinci El Ürünler',
              title: 'Sürdürülebilir\nAlaşveriş',
              subtitle:
                  'Çevre dostu seçeneklerle hem tasarruf edin hem doğayı koruyun',
              buttonText: 'İncele',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSlide({
    required final BuildContext context,
    required final bool isMobile,
    required final Gradient gradient,
    required final IconData icon,
    required final String badge,
    required final String title,
    required final String subtitle,
    required final String buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0)),
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: context.responsive(mobile: -80.0, desktop: -50.0),
            top: context.responsive(mobile: -80.0, desktop: -50.0),
            child: Container(
              width: context.responsive(mobile: 250.0, desktop: 400.0),
              height: context.responsive(mobile: 250.0, desktop: 400.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: context.responsive(mobile: 20.0, desktop: 40.0),
            bottom: context.responsive(mobile: 20.0, desktop: 40.0),
            child: Container(
              width: context.responsive(mobile: 200.0, desktop: 300.0),
              height: context.responsive(mobile: 200.0, desktop: 300.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(150),
              ),
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.3),
                size: context.responsive(mobile: 80.0, desktop: 140.0),
              ),
            ),
          ),
          // Content
          Padding(
            padding:
                EdgeInsets.all(context.responsive(mobile: 24.0, desktop: 60.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsive(mobile: 16.0, desktop: 20.0),
                    vertical: context.responsive(mobile: 8.0, desktop: 10.0),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(
                        context.responsive(mobile: 16.0, desktop: 24.0)),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.responsive(mobile: 13.0, desktop: 15.0),
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
                    fontSize: context.responsive(mobile: 32.0, desktop: 56.0),
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
                    fontSize: context.responsive(mobile: 16.0, desktop: 20.0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                    height: context.responsive(mobile: 24.0, desktop: 40.0)),
                // Butonları mobil için alt alta, desktop için yan yana getir
                Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
                                  mobile: 16.0, desktop: 18.0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: isMobile ? 0 : 16.0,
                      height: isMobile ? 12.0 : 0,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              context.responsive(mobile: 24.0, desktop: 32.0),
                          vertical:
                              context.responsive(mobile: 16.0, desktop: 20.0),
                        ),
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              context.responsive(mobile: 12.0, desktop: 16.0)),
                        ),
                      ),
                      child: Text(
                        'Daha Fazla',
                        style: TextStyle(
                          fontSize:
                              context.responsive(mobile: 16.0, desktop: 18.0),
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

  // Value Proposition Section
  SliverToBoxAdapter _buildValueProposition(
      final BuildContext context, final bool isMobile) {
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
          vertical: context.responsive(mobile: 12.0, desktop: 20.0),
        ),
        padding:
            EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 32.0)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 16.0, desktop: 24.0)),
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
                  items[0],
                  const Divider(indent: 20, endIndent: 20),
                  items[1],
                  const Divider(indent: 20, endIndent: 20),
                  items[2],
                  const Divider(indent: 20, endIndent: 20),
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
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: context.responsive(mobile: 16.0, desktop: 0.0)),
      child: Column(
        children: [
          Container(
            padding:
                EdgeInsets.all(context.responsive(mobile: 12.0, desktop: 16.0)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                  context.responsive(mobile: 12.0, desktop: 16.0)),
            ),
            child: Icon(icon,
                color: color,
                size: context.responsive(mobile: 28.0, desktop: 32.0)),
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
              fontSize: context.responsive(mobile: 13.0, desktop: 14.0),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildCategoriesSection(final BuildContext context) {
    const categories = [
      {
        'icon': Icons.chair_outlined,
        'label': 'Sandalye',
        'color': AppColors.primary
      },
      {
        'icon': Icons.weekend_outlined,
        'label': 'Kanepe',
        'color': AppColors.secondary
      },
      {'icon': Icons.bed_outlined, 'label': 'Yatak', 'color': AppColors.accent},
      {
        'icon': Icons.table_restaurant_outlined,
        'label': 'Masa',
        'color': AppColors.info
      },
      {
        'icon': Icons.tv_outlined,
        'label': 'TV Ünitesi',
        'color': AppColors.warning
      },
      // 6. kategoriyi ekleyelim ki grid dolsun
      {
        'icon': Icons.storage_outlined,
        'label': 'Dolap',
        'color': AppColors.success
      },
    ];

    final double spacing = context.responsive(mobile: 12.0, desktop: 16.0);

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
            SizedBox(height: context.responsive(mobile: 16.0, desktop: 24.0)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.responsive(mobile: 3, desktop: 6),
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: context.responsive(mobile: 0.9, desktop: 1.0),
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
                            context.responsive(mobile: 16.0, desktop: 20.0)),
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
                              borderRadius: BorderRadius.circular(context
                                  .responsive(mobile: 12.0, desktop: 16.0)),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: category['color'] as Color,
                              size: context.responsive(
                                  mobile: 28.0, desktop: 32.0),
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
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // --- DÜZELTME ---
                          // Bu alan 'categories' listesinde tanımlı değil, çökme hatasına neden olur.
                          // Bu yüzden kaldırıldı.
                          // const SizedBox(height: 4),
                          // Text(
                          //   category['count'] as String,
                          //   style: const TextStyle(
                          //     fontSize: 14,
                          //     color: AppColors.textSecondary,
                          //   ),
                          // ),
                          // --- DÜZELTME SONU ---
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: context.responsive(mobile: 32.0, desktop: 48.0)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturedProducts(
      final BuildContext context, final ProductState productState) {
    // --- İSTEK ÜZERİNE GÜNCELLEME ---
    // Ürün sayısı 6'dan 10'a çıkarıldı.
    final featuredProducts = productState.dataList?.take(10).toList() ?? [];
    // --- GÜNCELLEME SONU ---

    if (featuredProducts.isEmpty && productState.isLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: context.responsive(mobile: 300.0, desktop: 320.0),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (featuredProducts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Öne Çıkan Ürünler',
              subtitle: 'En çok beğenilen mobilyalar',
            ),
            SizedBox(height: context.responsive(mobile: 16.0, desktop: 20.0)),
            SizedBox(
              height: context.responsive(mobile: 300.0, desktop: 320.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredProducts.length,
                separatorBuilder: (final context, final index) => SizedBox(
                    width: context.responsive(mobile: 12.0, desktop: 20.0)),
                itemBuilder: (final context, final index) {
                  final product = featuredProducts[index];
                  // CustomProductCard zaten responsive
                  return SizedBox(
                    width: context.responsive(mobile: 200.0, desktop: 220.0),
                    child: CustomProductCard(product: product),
                  );
                },
              ),
            ),
            SizedBox(height: context.responsive(mobile: 24.0, desktop: 40.0)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBusinessIntroduction(
      final BuildContext context, final bool isMobile) {
    final double iconSize = context.responsive(mobile: 80.0, desktop: 120.0);

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
          vertical: context.responsive(mobile: 12.0, desktop: 20.0),
        ),
        padding:
            EdgeInsets.all(context.responsive(mobile: 20.0, desktop: 40.0)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 16.0, desktop: 24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            // Esnaf Fotoğrafı/Logo
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(iconSize / 2),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Icon(Icons.storefront_outlined,
                  color: AppColors.primary,
                  size: context.responsive(mobile: 32.0, desktop: 50.0)),
            ),
            SizedBox(
              width: isMobile ? 0 : 32.0,
              height: isMobile ? 24.0 : 0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    '20 Yıllık Esnaf Güvencesi',
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 22.0, desktop: 28.0),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '2003\'ten beri İstanbul\'da hizmet veren köklü bir esnaf firmasıyız. '
                    'Müşteri memnuniyetini her zaman ön planda tutarak, kaliteli ve güvenilir '
                    'alışverişin adresi olduk.',
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment:
                        isMobile ? WrapAlignment.center : WrapAlignment.start,
                    children: [
                      _buildBusinessFeature('✓ Kalite Garantisi'),
                      _buildBusinessFeature('✓ Profesyonel Montaj'),
                      _buildBusinessFeature('✓ Geri Alım Garantisi'),
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

  SliverToBoxAdapter _buildSpecialOffers(
      final BuildContext context, final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
          vertical: context.responsive(mobile: 12.0, desktop: 20.0),
        ),
        padding:
            EdgeInsets.all(context.responsive(mobile: 20.0, desktop: 40.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 16.0, desktop: 24.0)),
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
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          context.responsive(mobile: 12.0, desktop: 16.0),
                      vertical: context.responsive(mobile: 6.0, desktop: 8.0),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(
                          context.responsive(mobile: 16.0, desktop: 20.0)),
                    ),
                    child: Text(
                      '🔥 Sınırlı Süre',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            context.responsive(mobile: 12.0, desktop: 14.0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Süper İndirimler!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.responsive(mobile: 28.0, desktop: 36.0),
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Seçili ürünlerde %70\'e varan indirim fırsatı. '
                    'Kaçırmayın!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
                      height: 1.4,
                    ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF6B6B),
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            context.responsive(mobile: 24.0, desktop: 32.0),
                        vertical:
                            context.responsive(mobile: 14.0, desktop: 16.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            context.responsive(mobile: 10.0, desktop: 12.0)),
                      ),
                    ),
                    child: Text(
                      'Fırsatları Gör',
                      style: TextStyle(
                          fontSize:
                              context.responsive(mobile: 14.0, desktop: 16.0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: isMobile ? 0 : 40.0,
              height: isMobile ? 24.0 : 0,
            ),
            if (!isMobile) // Mobil cihazda bu ikonu gizle
              Container(
                width: context.responsive(mobile: 80.0, desktop: 120.0),
                height: context.responsive(mobile: 80.0, desktop: 120.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_offer_outlined,
                    color: Colors.white.withOpacity(0.7),
                    size: context.responsive(mobile: 32.0, desktop: 50.0)),
              ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildNewArrivals(
      final BuildContext context, final ProductState productState) {
    final newArrivals = productState.dataList ?? [];

    if (newArrivals.isEmpty && productState.isLoading) {
      return const SliverToBoxAdapter(
        child: Center(heightFactor: 5, child: CircularProgressIndicator()),
      );
    }
    if (newArrivals.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

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
            SizedBox(height: context.responsive(mobile: 16.0, desktop: 20.0)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // responsive_utils.dart'tan context.gridColumns() extension'ını kullan
                crossAxisCount: context.gridColumns(),
                // responsive_utils.dart'tan context.gridSpacing extension'ını kullan
                crossAxisSpacing: context.gridSpacing,
                mainAxisSpacing: context.gridSpacing,
                // Kartların aspect ratio'sunu ayarla
                childAspectRatio: context.responsive(
                    mobile: 0.72, tablet: 0.78, desktop: 0.75),
              ),
              itemCount: newArrivals.length.clamp(0, 8),
              itemBuilder: (final context, final index) {
                final product = newArrivals[index];
                // CustomProductCard zaten responsive
                return CustomProductCard(product: product);
              },
            ),
            SizedBox(height: context.responsive(mobile: 24.0, desktop: 40.0)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDeliveryMapSection(
      final BuildContext context, final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
          vertical: context.responsive(mobile: 12.0, desktop: 20.0),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 16.0, desktop: 24.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Container(
          padding:
              EdgeInsets.all(context.responsive(mobile: 20.0, desktop: 32.0)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                  context.responsive(mobile: 16.0, desktop: 24.0)),
              bottomRight: Radius.circular(
                  context.responsive(mobile: 16.0, desktop: 24.0)),
            ),
          ),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teslimat Bilgileri',
                      style: TextStyle(
                          fontSize:
                              context.responsive(mobile: 18.0, desktop: 20.0),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    _buildDeliveryInfo('🚚 Ücretsiz Teslimat',
                        'İstanbul İçerenköy ve yakın mahalleleri'),
                    _buildDeliveryInfo('⏰ Teslimat Saatleri', '09:00 - 22:00'),
                    _buildDeliveryInfo('📍 Hizmet Verilen Semtler',
                        'İçerenköy, Küçükbakkalköy, Kayışdağı, Fındıklı, İnönü, Bostancı Sanayi'),
                  ],
                ),
              ),
              SizedBox(
                width: isMobile ? 0 : 40.0,
                height: isMobile ? 24.0 : 0,
              ),
              // Çalışma Saatleri
              Container(
                width: isMobile ? double.infinity : null,
                // Mobilse tam genişlik
                padding: EdgeInsets.all(
                    context.responsive(mobile: 20.0, desktop: 24.0)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                      context.responsive(mobile: 12.0, desktop: 16.0)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.access_time_filled,
                        color: AppColors.primary, size: 40),
                    SizedBox(height: 12),
                    Text(
                      'Çalışma Saatleri',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pazartesi - Cumartesi\n09:00 - 22:00',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
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

  Widget _buildDeliveryInfo(final String title, final String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outlined,
              color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildTestimonials(
      final BuildContext context, final bool isMobile) {
    final items = [
      _buildTestimonialCard(
          'Ürünler tam olarak görseldeki gibi.', 'Ayşe K.', '⭐⭐⭐⭐⭐'),
      _buildTestimonialCard(
          'Hızlı montaj. Kesinlikle tavsiye ederim.', 'Mehmet Y.', '⭐⭐⭐⭐⭐'),
      _buildTestimonialCard('Fiyatlar çok uygun.', 'Zeynep A.', '⭐⭐⭐⭐⭐'),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
          vertical: context.responsive(mobile: 12.0, desktop: 20.0),
        ),
        padding:
            EdgeInsets.all(context.responsive(mobile: 20.0, desktop: 48.0)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 16.0, desktop: 32.0)),
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
                style: TextStyle(
                    fontSize: context.responsive(mobile: 24.0, desktop: 32.0),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 40),
            isMobile
                ? Column(
                    children: [
                      items[0],
                      SizedBox(
                          height:
                              context.responsive(mobile: 16.0, desktop: 24.0)),
                      items[1],
                      SizedBox(
                          height:
                              context.responsive(mobile: 16.0, desktop: 24.0)),
                      items[2],
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: items[0]),
                      SizedBox(
                          width:
                              context.responsive(mobile: 16.0, desktop: 24.0)),
                      Expanded(child: items[1]),
                      SizedBox(
                          width:
                              context.responsive(mobile: 16.0, desktop: 24.0)),
                      Expanded(child: items[2]),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(
      final String comment, final String name, final String rating) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rating, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 12),
          Text(comment,
              style: const TextStyle(
                  fontSize: 16, color: AppColors.textSecondary, height: 1.5)),
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
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildStatsSection(
      final BuildContext context, final bool isMobile) {
    final items = [
      _buildStatItem(context, '2,500+', 'Mutlu Müşteri'),
      _buildStatItem(context, '5,000+', 'Satılan Ürün'),
      _buildStatItem(context, '97%', 'Memnuniyet Oranı'),
      _buildStatItem(context, '20+', 'Yıllık Deneyim'),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
          vertical: context.responsive(mobile: 12.0, desktop: 20.0),
        ),
        padding:
            EdgeInsets.all(context.responsive(mobile: 32.0, desktop: 48.0)),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 16.0, desktop: 32.0)),
        ),
        child: isMobile
            ? Column(
                children: [
                  items[0],
                  SizedBox(
                      height: context.responsive(mobile: 24.0, desktop: 0.0)),
                  items[1],
                  SizedBox(
                      height: context.responsive(mobile: 24.0, desktop: 0.0)),
                  items[2],
                  SizedBox(
                      height: context.responsive(mobile: 24.0, desktop: 0.0)),
                  items[3],
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items,
              ),
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
                fontSize: context.responsive(mobile: 14.0, desktop: 18.0),
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
