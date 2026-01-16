import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Kendi dosya yollarını projenin yapısına göre güncelle
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_context_extension.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin, ResponsiveUtils {
  // --- ANIMASYON KONTROLLERİ (Senin sistemin) ---
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  // --- KONTROLLER VE STATE (Ortak yapı) ---
  int _currentHeroPage = 0;
  Timer? _heroTimer;
  String _activeCategory = 'Tümü';
  final PageController _heroPageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Arkaplan Orb Animasyonu
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    // Butonlar için süzülme efekti
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // İkonlar ve bildirimler için nabız efekti
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _startHeroTimer();
  }

  void _startHeroTimer() {
    _heroTimer = Timer.periodic(const Duration(seconds: 6), (final timer) {
      if (mounted && _heroPageController.hasClients) {
        _currentHeroPage = (_currentHeroPage + 1) % 3;
        _heroPageController.animateToPage(
          _currentHeroPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutQuint,
        );
      }
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _heroPageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. DİNAMİK ARKA PLAN (Senin Painter'ın lüks renklerle)
          _buildAnimatedBackground(),

          // 2. ANA İÇERİK (Responsive Max Width)
          ResponsiveUtils.maxWidthContainer(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // GLASSMORPHIC APP BAR
                _buildGlassmorphicAppBar(),

                // HERO SLIDER
                _buildHeroSliderSection(),

                // QUICK FEATURES (Hızlı İkonlar)
                _buildQuickFeatures(),

                // KATEGORİ SEÇİCİ
                _buildCategoriesSection(),

                // ÖNE ÇIKANLAR (Bento Grid Mantığı)
                _buildFeaturedGrid(),

                // MEKANA GÖRE KEŞFET (Scroll Oyunlu)
                _buildRoomsSection(),

                // İSTATİSTİKLER
                _buildStatsSection(),

                // FOOTER
                _buildFooter(),
              ],
            ),
          ),

          // 3. FLOATING ACTIONS (Senin animasyonlarınla)
          _buildAnimatedFloatingButtons(),
        ],
      ),
    );
  }

  // --- COMPONENTLER ---

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _heroController,
      builder: (final context, final child) => CustomPaint(
        painter: _OrbPainter(
          animation: _heroController.value,
          color1: context.primaryColor.withOpacity(0.05),
          color2: context.secondaryColor.withOpacity(0.03),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildGlassmorphicAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: context.responsive(mobile: 80, tablet: 100, desktop: 110),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor.withOpacity(0.7),
              border: Border(
                  bottom: BorderSide(
                      color: context.primaryColor.withOpacity(0.05))),
            ),
            child: SafeArea(
              child: Padding(
                padding: context.pagePadding,
                child: Row(
                  children: [
                    Text("SAĞLAM SPOT",
                        style: AppTextStyles.h3.copyWith(
                            color: context.primaryColor, letterSpacing: 2)),
                    const Spacer(),
                    if (!context.isMobile) ...[
                      _navItem('Koleksiyon'),
                      _navItem('Hakkımızda'),
                      _navItem('İletişim'),
                      SizedBox(width: context.spacingLarge),
                    ],
                    _buildActionIcons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(final String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(title,
          style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildActionIcons() {
    return Row(
      children: [
        _buildAnimatedIcon(Icons.favorite_border),
        const SizedBox(width: 15),
        _buildAnimatedIcon(Icons.shopping_bag_outlined, hasBadge: true),
      ],
    );
  }

  Widget _buildAnimatedIcon(final IconData icon,
      {final bool hasBadge = false}) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (final context, final child) => Stack(
        children: [
          Icon(icon, color: context.primaryColor, size: 28),
          if (hasBadge)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: context.secondaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroSliderSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: context.hp(65),
        margin: context.pagePadding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.borderRadius(1.5)),
          child: PageView.builder(
            controller: _heroPageController,
            itemCount: 3,
            itemBuilder: (final context, final index) => _heroSlide(index),
          ),
        ),
      ),
    );
  }

  Widget _heroSlide(final int index) {
    final List<String> images = [
      "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1600",
      "https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1600",
      "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1600"
    ];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(images[index]), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.primaryColor.withOpacity(0.8), Colors.transparent],
            begin: Alignment.centerLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("YENİ SEZON",
                style: TextStyle(
                    color: context.secondaryColor,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("Minimalist\nKonforun Zirvesi",
                style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: context.heroSize,
                    height: 1.1)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: context.secondaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
              child: const Text("KOLEKSİYONU GÖR"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFeatures() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.sectionPadding,
        child: Center(
          child: Wrap(
            // Satır sığmazsa aşağı kayması için Wrap daha güvenlidir
            alignment: WrapAlignment.center,
            spacing: context.responsive(mobile: 20, desktop: 60),
            runSpacing: 20,
            children: [
              _featureItem(Icons.volunteer_activism_rounded, "Samimi Esnaflık"),
              _featureItem(Icons.verified_user_rounded, "Güvenli Teslimat"),
              _featureItem(
                  Icons.sentiment_very_satisfied_rounded, "Güler Yüzlü Hizmet"),
              _featureItem(Icons.local_shipping_rounded, "Hızlı Nakliye"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureItem(final IconData icon, final String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: context.primaryColor, size: context.iconMedium),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: context.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize:
                context.bodySize, // Senin extension'ından gelen dinamik font
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    final List<String> cats = [
      "Tümü",
      "Masalar",
      "Dolaplar",
      "Koltuklar",
      "Yataklar",
      "Mutfak",
      "Sandalyeler"
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: context.responsive(mobile: 60, tablet: 70, desktop: 80),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: context.paddingHorizontal,
          itemCount: cats.length,
          itemBuilder: (final context, final i) {
            final isSelected = _activeCategory == cats[i];
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () => setState(() => _activeCategory = cats[i]),
                borderRadius: BorderRadius.circular(context.borderRadius(2)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        context.responsive(mobile: 25, tablet: 35, desktop: 45),
                  ),
                  decoration: BoxDecoration(
                    // Gradyan efekti: Seçiliyse senin Primary renklerin, değilse hafif beyaz/mint geçişi
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              context.primaryColor,
                              context.primaryColor.withOpacity(0.8)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              context.surfaceColor,
                              context.surfaceColor.withOpacity(0.5)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius:
                        BorderRadius.circular(context.borderRadius(2)),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: context.primaryColor.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                    border: Border.all(
                      color: isSelected
                          ? context.primaryColor
                          : context.primaryColor.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      cats[i],
                      style: TextStyle(
                        // SENİN CONTEXT KODLARIN: Mobil/Tablet/Desktop'a göre yazı büyür/küçülür
                        fontSize: context.responsive(
                            mobile: 14,
                            tablet: 16,
                            desktop: 18,
                            largeDesktop: 20),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : context.primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedGrid() {
    return SliverPadding(
      padding: context.pagePadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: context.cardAspectRatio(),
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) => _productCard(index),
          childCount: 8,
        ),
      ),
    );
  }

  Widget _productCard(final int index) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(context.borderRadius()),
        border: Border.all(color: context.primaryColor.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: context.sageGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(context.borderRadius()))))),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Modern Koltuk $index", style: AppTextStyles.subtitle1),
                Text("₺12.450",
                    style: AppTextStyles.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.primaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 400,
        margin: context.sectionPadding,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _roomCard("Salon",
                "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?q=80&w=800"),
            _roomCard("Yatak Odası",
                "https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=800"),
          ],
        ),
      ),
    );
  }

  Widget _roomCard(final String title, final String img) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(30),
      child: Text(title, style: AppTextStyles.h2.copyWith(color: Colors.white)),
    );
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(60),
        margin: context.pagePadding,
        decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem("2500+", "Müşteri"),
            _statItem("20+", "Yıl"),
            _statItem("%100", "Güven"),
          ],
        ),
      ),
    );
  }

  Widget _statItem(final String val, final String label) {
    return Column(
      children: [
        Text(val, style: AppTextStyles.h2.copyWith(color: Colors.white)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildFooter() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(80),
        color: context.primaryColor,
        child: Column(
          children: [
            Text("SAĞLAM SPOT",
                style: AppTextStyles.h1
                    .copyWith(color: Colors.white, fontSize: 32)),
            const SizedBox(height: 20),
            Text("© 2026 Tüm Hakları Saklıdır.",
                style: TextStyle(color: Colors.white.withOpacity(0.3))),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedFloatingButtons() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (final context, final child) => Transform.translate(
          offset: Offset(0, -10 * _floatingController.value),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: context.secondaryColor,
            child: const Icon(Icons.chat_bubble_outline),
          ),
        ),
      ),
    );
  }
}

// ARKAPLAN PAINTER (Senin Kodun)
class _OrbPainter extends CustomPainter {
  final double animation;
  final Color color1;
  final Color color2;

  _OrbPainter(
      {required this.animation, required this.color1, required this.color2});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint1 = Paint()
      ..color = color1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    final paint2 = Paint()
      ..color = color2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    canvas.drawCircle(
        Offset(size.width * 0.2 + animation * 40, size.height * 0.3),
        size.width * 0.2,
        paint1);
    canvas.drawCircle(
        Offset(size.width * 0.8 - animation * 30, size.height * 0.7),
        size.width * 0.25,
        paint2);
  }

  @override
  bool shouldRepaint(final _OrbPainter oldDelegate) => true;
}
