import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/widgets/custom_search_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../data/providers/product/product_provider.dart';
import 'widgets/furniture_tips_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late PageController _heroController;
  int _currentHeroPage = 0;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  String _activeCategory = "Tümü";

  // Trend slider state
  final ScrollController _trendController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heroController = PageController();
    _startHeroTimer();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  void _startHeroTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (final _) {
      if (_heroController.hasClients) {
        final int nextPage = (_currentHeroPage + 1) % 3;
        _heroController.animateToPage(nextPage,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuart);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _heroController.dispose();
    _searchController.dispose();
    _trendController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);
    final isMobile = MediaQuery.of(context).size.width < 900;
    const bgMint = Color(0xFFE8F1EF);

    return Scaffold(
      backgroundColor: bgMint,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildDiscoveryHeader(isMobile),
          SliverToBoxAdapter(
            child: CustomSearchBar(
              controller: _searchController,
              onSearch: (final query) {
                context.push('/search?q=${Uri.encodeComponent(query)}');
              },
            ),
          ),
          _buildDynamicCategorySection(isMobile),
          _buildHeroSection(isMobile),
          _buildSectionHeader(
              "Tüm Koleksiyon", "Kalite ve estetiğin buluştuğu nokta"),
          _buildProductGrid(productState, isMobile),
          _buildSectionHeader(
              "Odaya Göre Keşfet", "Yaşam alanınıza en uygun parçaları seçin"),
          _buildShopByRoomSection(isMobile),
          _buildBusinessIntroduction(isMobile),
          const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),
          const FurnitureTipsSection(),
          _buildSectionHeader(
              "Müşteri Yorumları", "Mutlu evlerden gelen geri bildirimler"),
          _buildTestimonialsSection(isMobile),
          _buildStatsSection(isMobile),
          _buildCTASection(isMobile),
          _buildModernFooter(isMobile),
        ],
      ),
    );
  }

// ================= HERO =================
  SliverToBoxAdapter _buildHeroSection(final bool isMobile) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 380,
        child: Stack(
          children: [
            PageView(
              controller: _heroController,
              onPageChanged: (final i) => setState(() => _currentHeroPage = i),
              children: [
                _heroSlide(
                    color: const Color(0xFF103E35),
                    badge: 'Yeni Koleksiyon',
                    title: 'Modern Mobilyalar\nEviniz İçin',
                    subtitle:
                        'Kaliteli ve şık tasarımlarla yaşam alanınızı yenileyin',
                    isMobile: isMobile),
                _heroSlide(
                    color: const Color(0xFF3E2D10),
                    badge: 'Spot Ürünler',
                    title: 'İnanılmaz Fırsatlar\nSizi Bekliyor',
                    subtitle:
                        '%70\'e varan indirimlerle bütçe dostu mobilyalar',
                    isMobile: isMobile),
                _heroSlide(
                    color: const Color(0xFF1B0F34),
                    badge: 'İkinci El Güvencesi',
                    title: 'Sürdürülebilir\nAlışveriş',
                    subtitle:
                        'Çevre dostu seçeneklerle hem tasarruf edin hem doğayı koruyun',
                    isMobile: isMobile),
              ],
            ),

            // ------------------- INDICATOR -------------------
            Positioned(
              bottom: 20,
              right: 30,
              child: Row(
                children: List.generate(3, (final index) {
                  final bool isActive = _currentHeroPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(left: 6),
                    width: isActive ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroSlide({
    required final Color color,
    required final String badge,
    required final String title,
    required final String subtitle,
    required final bool isMobile,
  }) {
    bool _isHovered = false;

    return StatefulBuilder(
      builder: (final context, final setState) => MouseRegion(
        onEnter: (final _) => setState(() => _isHovered = true),
        onExit: (final _) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 40, vertical: _isHovered ? 0 : 10),
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.03))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                color.withOpacity(0.95),
                color.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.25 : 0.12),
                blurRadius: _isHovered ? 30 : 15,
                offset: Offset(0, _isHovered ? 15 : 8),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 60, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ]),
                child: Text(badge,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              // Title
              Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 28 : 40,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(1, 1))
                      ])),
              const SizedBox(height: 8),
              // Subtitle
              Text(subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isMobile ? 14 : 18,
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(1, 1))
                    ],
                  )),
              const SizedBox(height: 24),
              // Keşfet Butonu
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 36,
                        vertical: isMobile ? 14 : 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    shadowColor: Colors.black.withOpacity(0.15),
                    elevation: _isHovered ? 16 : 6),
                child: const Text(
                  "Keşfet",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  SliverToBoxAdapter _buildDiscoveryHeader(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(isMobile ? 24 : 60, 40, isMobile ? 24 : 60, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF103E35).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("HOŞ GELDİNİZ",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Color(0xFF103E35))),
            ),
            const SizedBox(height: 20),
            Text("Hayalinizdeki Sahneyi\nBurada Kurun.",
                style: TextStyle(
                    fontSize: isMobile ? 38 : 68,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -2,
                    height: 1.0,
                    color: const Color(0xFF1E293B))),
            const SizedBox(height: 20),
            const Text(
                "En özel mobilyalarla evinizde unutulmaz bir atmosfer yaratın.",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black45,
                    fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }

  // ================= DYNAMIC CATEGORY =================
  SliverToBoxAdapter _buildDynamicCategorySection(final bool isMobile) {
    final categories = [
      {"name": "Tümü", "icon": Icons.grid_view_rounded},
      {"name": "Masalar", "icon": Icons.table_restaurant_outlined},
      {"name": "Sandalyeler", "icon": Icons.chair_alt_rounded},
      {"name": "Koltuklar", "icon": Icons.weekend_outlined},
      {"name": "Yataklar", "icon": Icons.bed_outlined},
    ];
    return SliverToBoxAdapter(
      child: Container(
        height: 110,
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: isMobile ? 24 : 60),
          itemCount: categories.length,
          itemBuilder: (final context, final i) {
            final bool isActive = _activeCategory == categories[i]["name"];
            return GestureDetector(
              onTap: () => setState(
                  () => _activeCategory = categories[i]["name"] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  children: [
                    Icon(categories[i]["icon"] as IconData,
                        color: isActive ? Colors.white : Colors.black,
                        size: 22),
                    const SizedBox(width: 10),
                    Text(categories[i]["name"] as String,
                        style: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= SECTION HEADER =================
  SliverToBoxAdapter _buildSectionHeader(
      final String title, final String subtitle) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(60, 80, 60, 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.black45)),
        ]),
      ),
    );
  }

  // =================== PRODUCT GRID ===================
  SliverPadding _buildProductGrid(final dynamic state, final bool isMobile) {
    final products = state.dataList ?? [];
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 4,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          mainAxisExtent: 420,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) =>
              CustomProductCard(product: products[index]),
          childCount: products.length > 8 ? 8 : products.length,
        ),
      ),
    );
  }

  // =================== SHOP BY ROOM ===================
  SliverToBoxAdapter _buildShopByRoomSection(final bool isMobile) {
    final rooms = [
      {
        "name": "Oturma Odası",
        "img":
            "https://images.unsplash.com/photo-1583847268964-b28dc2f51ac9?q=80&w=800",
        "count": "120+ Ürün"
      },
      {
        "name": "Yatak Odası",
        "img":
            "https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=800",
        "count": "80+ Ürün"
      },
      {
        "name": "Mutfak",
        "img":
            "https://images.unsplash.com/photo-1617806118233-f8e1374d6f9c?q=80&w=800",
        "count": "45+ Ürün"
      },
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 450,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
          itemCount: rooms.length,
          itemBuilder: (final context, final index) => Container(
            width: isMobile ? 300 : 400,
            margin: const EdgeInsets.only(right: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                  image: NetworkImage(rooms[index]["img"]!), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent
                    ]),
              ),
              padding: const EdgeInsets.all(35),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rooms[index]["count"]!,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 14)),
                  Text(rooms[index]["name"]!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =================== BUSINESS INTRO ===================
  SliverToBoxAdapter _buildBusinessIntroduction(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 40)
            ]),
        child: const Text("20 Yıllık Esnaf Güvencesi",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // =================== TESTIMONIALS ===================
  SliverToBoxAdapter _buildTestimonialsSection(final bool isMobile) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: isMobile ? 24 : 60),
          itemCount: 5,
          itemBuilder: (final context, final i) => Container(
            width: 350,
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03), blurRadius: 20)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  Icon(Icons.star, color: Colors.orange, size: 18),
                ]),
                const SizedBox(height: 15),
                const Text(
                    "Ürün kalitesi beklediğimden çok daha iyi çıktı. Esnafımızın dürüstlüğü ve hızı için teşekkürler.",
                    style: TextStyle(
                        color: Colors.black87, fontSize: 15, height: 1.4)),
                const Spacer(),
                Text("Ayşe Y. - Müşteri",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[400])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildStatsSection(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(isMobile ? 20 : 60),
        padding: EdgeInsets.all(isMobile ? 40 : 80),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(50),
        ),
        child: isMobile
            ? Column(children: _buildStatItems())
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildStatItems(),
              ),
      ),
    );
  }

  List<Widget> _buildStatItems() {
    return [
      _statItem("2.5K", "Mutlu Müşteri", Icons.face_retouching_natural),
      _statItem("20 Yıl", "Deneyim", Icons.verified_user_outlined),
      _statItem("15K+", "Teslimat", Icons.local_shipping_outlined),
    ];
  }

  Widget _statItem(final String val, final String label, final IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white38, size: 30),
        const SizedBox(height: 15),
        Text(val,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.w900)),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 16)),
      ],
    );
  }

  // =================== CALL TO ACTION ===================
  SliverToBoxAdapter _buildCTASection(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 40),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Evinizi Şimdi Yenileyin!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("En kaliteli ve şık mobilyalar sizi bekliyor.",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Keşfet",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  // =================== MODERN FOOTER ===================
  SliverToBoxAdapter _buildModernFooter(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LOGO + SOCIALS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sağlam Spot",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("Eviniz için en kaliteli parçaları keşfedin.",
                        style: TextStyle(color: Colors.white54)),
                  ],
                ),
                Row(
                  children: [
                    _footerSocial(Icons.facebook),
                    const SizedBox(width: 15),
                    _footerSocial(Icons.camera_alt),
                    const SizedBox(width: 15),
                    _footerSocial(Icons.send),
                  ],
                )
              ],
            ),
            const Divider(color: Colors.white12, height: 80),
            // COPYRIGHT + LINKS
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("© 2026 Sağlam Spot Mobilya. Tüm hakları saklıdır.",
                    style: TextStyle(color: Colors.white30)),
                Row(
                  children: [
                    Text("Gizlilik Politikası",
                        style: TextStyle(color: Colors.white30)),
                    SizedBox(width: 30),
                    Text("Kullanım Şartları",
                        style: TextStyle(color: Colors.white30)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerSocial(final IconData icon) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white12), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      );
}
