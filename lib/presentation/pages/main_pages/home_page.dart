import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/modern_category_card.dart';
import '../../../core/widgets/modern_product_card.dart';
import '../../../core/widgets/section_header.dart';
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
        // Hero Section
        _buildEnhancedHeroSection(context),

        // Value Proposition
        _buildValueProposition(),

        // Categories Section
        _buildCategoriesSection(),

        // Featured Products
        _buildFeaturedProducts(productState),

        // Esnaf Tanıtımı
        _buildBusinessIntroduction(),

        // Special Offers - DÜZELTİLDİ
        _buildSpecialOffers(),

        // New Arrivals
        _buildNewArrivals(productState),

        // Google Maps & Teslimat Bilgisi
        _buildDeliveryMapSection(),

        // Testimonials
        _buildTestimonials(),

        // Stats Section
        _buildStatsSection(),

        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }

  SliverToBoxAdapter _buildEnhancedHeroSection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 550,
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
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
    required final Gradient gradient,
    required final IconData icon,
    required final String badge,
    required final String title,
    required final String subtitle,
    required final String buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: gradient,
      ),
      child: Stack(
        children: [
          // Decorative circles
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
            padding: const EdgeInsets.all(60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
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
                      child: const Text(
                        'Daha Fazla',
                        style: TextStyle(
                          fontSize: 18,
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
  SliverToBoxAdapter _buildValueProposition() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: const EdgeInsets.all(32),
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
        child: Row(
          children: [
            Expanded(
              child: _buildValueItem(
                Icons.verified_outlined,
                'Güvenilir',
                'Kalite garantisi',
                AppColors.success,
              ),
            ),
            Container(width: 1, height: 60, color: AppColors.border),
            Expanded(
              child: _buildValueItem(
                Icons.local_shipping_outlined,
                'Hızlı Teslimat',
                'Ücretsiz kargo',
                AppColors.info,
              ),
            ),
            Container(width: 1, height: 60, color: AppColors.border),
            Expanded(
              child: _buildValueItem(
                Icons.attach_money_outlined,
                'En İyi Fiyat',
                'Uygun ödeme seçenekleri',
                AppColors.warning,
              ),
            ),
            Container(width: 1, height: 60, color: AppColors.border),
            Expanded(
              child: _buildValueItem(
                Icons.access_time_outlined, // Değişti
                '9:00 - 22:00',
                'Müşteri hizmetleri',
                AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(
    final IconData icon,
    final String title,
    final String subtitle,
    final Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildCategoriesSection() {
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
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
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
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  (category['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              color: category['color'] as Color,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category['label'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category['count'] as String,
                            style: const TextStyle(
                              fontSize: 14,
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
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFeaturedProducts(final ProductState productState) {
    final featuredProducts = productState.dataList?.take(6).toList() ?? [];

    if (featuredProducts.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Öne Çıkan Ürünler',
              subtitle: 'En çok beğenilen mobilyalar',
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 320,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredProducts.length,
                separatorBuilder: (final context, final index) =>
                    const SizedBox(width: 20),
                itemBuilder: (final context, final index) {
                  final product = featuredProducts[index];
                  return ModernProductCard(product: product, width: 280);
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBusinessIntroduction() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: const EdgeInsets.all(40),
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
        child: Row(
          children: [
            // Esnaf Fotoğrafı/Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Icon(Icons.storefront_outlined,
                  color: AppColors.primary, size: 50),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '20 Yıllık Esnaf Güvencesi',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '2003\'ten beri İstanbul\'da hizmet veren köklü bir esnaf firmasıyız. '
                    'Müşteri memnuniyetini her zaman ön planda tutarak, kaliteli ve güvenilir '
                    'alışverişin adresi olduk.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildBusinessFeature('✓ Kalite Garantisi'),
                      const SizedBox(width: 20),
                      _buildBusinessFeature('✓ Profesyonel Montaj'),
                      const SizedBox(width: 20),
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

  // SPECIAL OFFERS - DÜZELTİLDİ (UI Sığma Sorunu Çözüldü)
  SliverToBoxAdapter _buildSpecialOffers() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: const EdgeInsets.all(40),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '🔥 Sınırlı Süre',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Süper İndirimler!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Seçili ürünlerde %70\'e varan indirim fırsatı. '
                    'Kaçırmayın!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Fırsatları Gör',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            // Daha küçük ve uyumlu ikon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.local_offer_outlined,
                  color: Colors.white.withOpacity(0.7), size: 50),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildNewArrivals(final ProductState productState) {
    final newArrivals = productState.dataList ?? [];
    if (newArrivals.isEmpty) return const SliverToBoxAdapter(child: SizedBox());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              itemCount: newArrivals.length.clamp(0, 8),
              itemBuilder: (final context, final index) {
                final product = newArrivals[index];
                return ModernProductCard(product: product);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDeliveryMapSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Teslimat Bilgileri',
                      style: TextStyle(
                          fontSize: 20,
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
              const SizedBox(width: 40),
              // Çalışma Saatleri
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
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

  SliverToBoxAdapter _buildTestimonials() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: const EdgeInsets.all(48),
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
            const Text('Müşterilerimiz Ne Diyor?',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                    child: _buildTestimonialCard(
                        'Ürünler tam olarak görseldeki gibi.',
                        'Ayşe K.',
                        '⭐⭐⭐⭐⭐')),
                const SizedBox(width: 24),
                Expanded(
                    child: _buildTestimonialCard(
                        'Hızlı montaj. Kesinlikle tavsiye ederim.',
                        'Mehmet Y.',
                        '⭐⭐⭐⭐⭐')),
                const SizedBox(width: 24),
                Expanded(
                    child: _buildTestimonialCard(
                        'Fiyatlar çok uygun.', 'Zeynep A.', '⭐⭐⭐⭐⭐')),
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

  SliverToBoxAdapter _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('2,500+', 'Mutlu Müşteri'),
            _buildStatItem('5,000+', 'Satılan Ürün'),
            _buildStatItem('97%', 'Memnuniyet Oranı'),
            _buildStatItem('20+', 'Yıllık Deneyim'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(final String number, final String label) {
    return Column(
      children: [
        Text(number,
            style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
