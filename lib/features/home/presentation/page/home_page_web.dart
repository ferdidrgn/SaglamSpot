import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_context_extension.dart';
import '../../../../core/util/responsive_utils.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin, ResponsiveUtils {
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  int _currentHeroPage = 0;
  Timer? _heroTimer;
  String _activeCategory = 'Tümü';
  final PageController _heroPageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heroController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..repeat();
    _floatingController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _startHeroTimer();
  }

  void _startHeroTimer() {
    _heroTimer = Timer.periodic(const Duration(seconds: 6), (final timer) {
      if (mounted && _heroPageController.hasClients) {
        _currentHeroPage = (_currentHeroPage + 1) % 3;
        _heroPageController.animateToPage(_currentHeroPage,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuint);
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
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          ResponsiveUtils.maxWidthContainer(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. HERO SLIDER (Yükseklik HP ile responsive)
                _buildHeroSliderSection(),

                // 2. QUICK FEATURES (Wrap ile mobilde alta kayar)
                _buildQuickFeatures(),

                // 3. CATEGORIES (Hizalı ve şık)
                _buildCategoriesSection(),

                // 4. FEATURED GRID (Dinamik sütun sayısı)
                _buildFeaturedGrid(),

                // 5. ROOMS SECTION (Yatay Scroll)
                _buildRoomsSection(),

                // 6. ARTISAN INFO (Esnaf Bilgileri)
                _buildArtisanInfo(),

                // 7. STATS (Premium Dark)
                _buildStatsSection(),

                // 8. FOOTER
                _buildFooter(),
              ],
            ),
          ),
          _buildAnimatedFloatingButtons(),
        ],
      ),
    );
  }

  // --- RESPONSIVE BİLEŞENLER ---

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

  Widget _buildHeroSliderSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: context.hp(context.isMobile ? 50 : 65), // Mobilde daha kısa
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
        padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 60)),
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
                    letterSpacing: context.isMobile ? 2 : 4,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsive(mobile: 10, desktop: 14))),
            const SizedBox(height: 10),
            Text("Minimalist\nKonforun Zirvesi",
                style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: context.heroSize * 0.8,
                    // Context heroSize'ı biraz dengeledik
                    height: 1.1)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: context.secondaryColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.responsive(mobile: 20, desktop: 40),
                      vertical: context.responsive(mobile: 12, desktop: 20))),
              child: Text("KOLEKSİYONU GÖR",
                  style: TextStyle(fontSize: context.captionSize)),
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
            alignment: WrapAlignment.center,
            spacing: context.responsive(mobile: 20, tablet: 40, desktop: 60),
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
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                color: context.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: context.bodySize)),
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
        height: context.responsive(mobile: 50, desktop: 70),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
          // Sayfa paddingi ile hizalandı
          itemCount: cats.length,
          itemBuilder: (final context, final i) {
            final isSelected = _activeCategory == cats[i];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () => setState(() => _activeCategory = cats[i]),
                borderRadius: BorderRadius.circular(context.borderRadius(2)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                      horizontal: context.responsive(mobile: 20, desktop: 40)),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(colors: [
                            context.primaryColor,
                            context.primaryColor.withOpacity(0.8)
                          ])
                        : LinearGradient(colors: [
                            context.surfaceColor,
                            context.surfaceColor.withOpacity(0.5)
                          ]),
                    borderRadius:
                        BorderRadius.circular(context.borderRadius(2)),
                    border: Border.all(
                        color: isSelected
                            ? context.primaryColor
                            : context.primaryColor.withOpacity(0.1)),
                  ),
                  child: Center(
                    child: Text(cats[i],
                        style: TextStyle(
                            fontSize: context.responsive(
                                mobile: 12, tablet: 14, desktop: 16),
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : context.primaryColor)),
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
          // ResponsiveUtils: Mobile 2, Tablet 3, Desktop 4
          mainAxisSpacing: context.gridSpacing,
          crossAxisSpacing: context.gridSpacing,
          childAspectRatio: context.cardAspectRatio(),
        ),
        delegate: SliverChildBuilderDelegate(
            (final context, final index) => _productCard(index),
            childCount: 8),
      ),
    );
  }

  Widget _productCard(final int index) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(context.borderRadius()),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.sageGreen.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(context.borderRadius())),
              ),
              child: const Center(child: Icon(Icons.chair_outlined)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ürün Başlığı $index",
                    style: TextStyle(
                        fontSize: context.bodySize,
                        fontWeight: FontWeight.bold),
                    maxLines: 1),
                Text("₺12.450",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: context.primaryColor,
                        fontSize: context.priceSize)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsSection() {
    final List<Map<String, String>> rooms = [
      {
        "title": "Salon",
        "img":
            "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?q=80&w=800",
        "sub": "Konforun Merkezi"
      },
      {
        "title": "Yatak",
        "img":
            "https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=800",
        "sub": "Huzurlu Uykular"
      },
      {
        "title": "Mutfak",
        "img":
            "https://images.unsplash.com/photo-1556912178-8f4df6d97a33?q=80&w=800",
        "sub": "Pratik Çözümler"
      },
      {
        "title": "Ofis",
        "img":
            "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=800",
        "sub": "Verimli Çalışma"
      },
    ];

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              "Yaşam Alanına Göre", "Evinizin her köşesi için özel seçimler"),
          SizedBox(
            height: context.hp(context.isMobile ? 35 : 45),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.symmetric(horizontal: context.pagePadding.left),
              itemCount: rooms.length,
              itemBuilder: (final context, final index) => _roomCard(
                  rooms[index]["title"]!,
                  rooms[index]["img"]!,
                  rooms[index]["sub"]!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roomCard(final String title, final String img, final String sub) {
    return Container(
      width: context.wp(context.isMobile ? 70 : 25),
      // Mobilde ekranın %70'i kadar, desktopta %25
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.borderRadius(2)),
        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.borderRadius(2)),
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent]),
        ),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sub,
                style: TextStyle(
                    color: context.secondaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
            Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: context.h3Size,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding,
        padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 60)),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(context.borderRadius(2)),
          border: Border.all(color: context.primaryColor.withOpacity(0.05)),
        ),
        child: Flex(
          direction: context.isMobile ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              flex: context.isMobile ? 0 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BİZ KİMİZ?",
                      style: TextStyle(
                          color: context.secondaryColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                  const SizedBox(height: 15),
                  Text("20 Yıllık Samimi Esnaflık,\nModern Hizmet.",
                      style: TextStyle(
                          fontSize: context.h2Size,
                          fontWeight: FontWeight.w900,
                          height: 1.2)),
                  const SizedBox(height: 15),
                  Text(
                      "Mağazamıza gelin, bir çayımızı için; size en uygun mobilyayı birlikte seçelim.",
                      style: TextStyle(
                          color: context.primaryColor.withOpacity(0.6),
                          fontSize: context.bodySize)),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentDark),
                    child: const Text("BİZİ ZİYARET EDİN"),
                  )
                ],
              ),
            ),
            if (!context.isMobile) const SizedBox(width: 40),
            if (context.isMobile) const SizedBox(height: 30),
            Expanded(
              flex: context.isMobile ? 0 : 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                    "https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=800",
                    fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = [
      {"val": "2.5K+", "label": "Mutlu Müşteri", "icon": Icons.people_outline},
      {
        "val": "20+ Yıl",
        "label": "Tecrübe",
        "icon": Icons.workspace_premium_outlined
      },
      {
        "val": "15K+",
        "label": "Teslimat",
        "icon": Icons.local_shipping_outlined
      },
      {"val": "%100", "label": "Güven", "icon": Icons.verified_user_outlined},
    ];

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.hp(8)),
        decoration: const BoxDecoration(color: AppColors.backgroundDark),
        // Mat lüks siyah
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: stats
                .map((final s) => _buildStatCard(s["val"] as String,
                    s["label"] as String, s["icon"] as IconData))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      final String val, final String label, final IconData icon) {
    return Container(
      width:
          context.responsive(mobile: context.wp(42), tablet: 200, desktop: 250),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(context.borderRadius()),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.secondaryColor, size: 30),
          const SizedBox(height: 15),
          Text(val,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: context.h3Size,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(label.toUpperCase(),
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            context.pagePadding.left, 80, context.pagePadding.right, 40),
        color: AppColors.backgroundDark,
        child: Column(
          children: [
            // Ana Footer İçeriği
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 40,
              runSpacing: 50,
              children: [
                // 1. Marka Tanımı
                SizedBox(
                  width:
                      context.responsive(mobile: double.infinity, desktop: 300),
                  child: Column(
                    crossAxisAlignment: context.isMobile
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Text("SAĞLAM SPOT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 4,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 20),
                      Text(
                        "20 yılı aşkın tecrübemizle İstanbul'un her noktasına kaliteyi ve güveni taşıyoruz. Evinizin her köşesinde bir hikayemiz var.",
                        textAlign: context.isMobile
                            ? TextAlign.center
                            : TextAlign.start,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 14,
                            height: 1.6),
                      ),
                    ],
                  ),
                ),

                // 2. Hızlı Keşfet (Mobilde de görünür)
                _footerColumn("KEŞFET", [
                  "Koleksiyonlar",
                  "Oturma Grupları",
                  "Yatak Odası",
                  "Mutfak"
                ]),

                // 3. Kurumsal Bilgiler (Mobilde de görünür)
                _footerColumn("KURUMSAL",
                    ["Hakkımızda", "Mağazamız", "İletişim", "Kariyer"]),

                // 4. İletişim & Sosyal
                SizedBox(
                  width:
                      context.responsive(mobile: double.infinity, desktop: 250),
                  child: Column(
                    crossAxisAlignment: context.isMobile
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.end,
                    children: [
                      Text("BİZE ULAŞIN",
                          style: TextStyle(
                              color: context.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 2)),
                      const SizedBox(height: 20),
                      Text("info@saglamspot.com",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                      const SizedBox(height: 10),
                      Text("+90 212 000 00 00",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _socialCircle(Icons.facebook),
                          const SizedBox(width: 12),
                          _socialCircle(Icons.camera_alt_outlined),
                          const SizedBox(width: 12),
                          _socialCircle(Icons.location_on_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80),
            Divider(color: Colors.white.withOpacity(0.03)),
            const SizedBox(height: 30),

            // Alt Bilgi
            Text(
              "© 2026 SAĞLAM SPOT TİCARET. TÜM HAKLARI SAKLIDIR.",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.15),
                  fontSize: 10,
                  letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

// Yardımcı Kolon Yapısı (Responsive)
  Widget _footerColumn(final String title, final List<String> items) {
    return SizedBox(
      width: context.responsive(mobile: context.wp(40), desktop: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1)),
          const SizedBox(height: 25),
          ...items
              .map((final item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(item,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 13)),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _socialCircle(final IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: Colors.white.withOpacity(0.5), size: 18),
    );
  }

  Widget _buildSectionHeader(final String title, final String sub) {
    return Padding(
      padding: context.pagePadding.copyWith(bottom: 20, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: context.h2Size,
                  fontWeight: FontWeight.w900,
                  color: context.primaryColor)),
          const SizedBox(height: 4),
          Container(height: 3, width: 40, color: context.secondaryColor),
          const SizedBox(height: 8),
          Text(sub,
              style: TextStyle(
                  color: context.primaryColor.withOpacity(0.5),
                  fontSize: context.captionSize)),
        ],
      ),
    );
  }

  Widget _buildAnimatedFloatingButtons() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (final context, final child) => Transform.translate(
          offset: Offset(0, -10 * _floatingController.value),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: context.secondaryColor,
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

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
