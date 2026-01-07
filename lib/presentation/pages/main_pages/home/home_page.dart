import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/widgets/custom_search_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/responsive_utils.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    const bgMint = Color(0xFFE8F1EF);

    // ResponsiveUtils: MaxWidthContainer ile web'de içeriğin çok yayılmasını önlüyoruz
    return Scaffold(
      backgroundColor: bgMint,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1920),
          // ResponsiveUtils.maxContentWidth
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildDiscoveryHeader(context),

              SliverToBoxAdapter(
                child: Padding(
                  padding: context.paddingHorizontal,
                  child: CustomSearchBar(
                    controller: _searchController,
                    onSearch: (final query) {
                      context.push('/search?q=${Uri.encodeComponent(query)}');
                    },
                  ),
                ),
              ),

              _buildDynamicCategorySection(context),
              _buildHeroSection(context),

              _buildSectionHeader(context, "Tüm Koleksiyon",
                  "Kalite ve estetiğin buluştuğu nokta"),
              _buildProductGrid(context, productState),

              _buildSectionHeader(context, "Odaya Göre Keşfet",
                  "Yaşam alanınıza en uygun parçaları seçin"),
              _buildShopByRoomSection(context),

              _buildBusinessIntroduction(context),

              const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),

              // FurnitureTipsSection zaten kendi içinde responsive ise dokunmuyoruz,
              // değilse padding ile sarmalayabiliriz.
              const FurnitureTipsSection(),

              _buildSectionHeader(context, "Müşteri Yorumları",
                  "Mutlu evlerden gelen geri bildirimler"),
              _buildTestimonialsSection(context),

              _buildStatsSection(context),
              _buildCTASection(context),

              const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),
              _buildModernFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER (RESPONSIVE) =================
  SliverToBoxAdapter _buildDiscoveryHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding, // Responsive padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- SOL TARAFTAKİ METİN ALANI ---
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          fontSize: context.heroSize,
                          // Responsive Font Size
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                          height: 1.0,
                          color: const Color(0xFF1E293B))),
                  const SizedBox(height: 20),
                  Text(
                      "En özel mobilyalarla evinizde unutulmaz bir atmosfer yaratın.",
                      style: TextStyle(
                          fontSize: context.subtitleSize,
                          // Responsive Font Size
                          color: Colors.black45,
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),

            // --- SAĞ TARAFTAKİ LOGO ALANI ---
            // Mobilde gizle, Tablet ve Desktopta göster
            if (!context.isMobile) ...[
              SizedBox(width: context.spacingLarge),
              Expanded(
                flex: 2,
                child: Container(
                  height: context.responsive(
                      mobile: 0.0, tablet: 200.0, desktop: 300.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF103E35).withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                    image: const DecorationImage(
                      image: AssetImage("assets/images/saglam_spot_logo.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================= DYNAMIC CATEGORY =================
  SliverToBoxAdapter _buildDynamicCategorySection(BuildContext context) {
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
        margin: EdgeInsets.symmetric(vertical: context.spacingLarge),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: context.paddingHorizontal.left),
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
                        size: context.iconSmall),
                    const SizedBox(width: 10),
                    Text(categories[i]["name"] as String,
                        style: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                            fontSize: context.bodySize,
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

  // ================= HERO SECTION =================
  SliverToBoxAdapter _buildHeroSection(BuildContext context) {
    // Mobilde daha yüksek, desktopta daha yatay bir oran
    final height =
        context.responsive(mobile: 450.0, tablet: 400.0, desktop: 380.0);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            PageView(
              controller: _heroController,
              onPageChanged: (final i) => setState(() => _currentHeroPage = i),
              children: [
                _heroSlide(
                  context: context,
                  color: const Color(0xFF103E35),
                  badge: 'Yeni Koleksiyon',
                  title: 'Modern Mobilyalar\nEviniz İçin',
                  subtitle:
                      'Kaliteli ve şık tasarımlarla yaşam alanınızı yenileyin',
                ),
                _heroSlide(
                  context: context,
                  color: const Color(0xFF3E2D10),
                  badge: 'Spot Ürünler',
                  title: 'İnanılmaz Fırsatlar\nSizi Bekliyor',
                  subtitle: '%70\'e varan indirimlerle bütçe dostu mobilyalar',
                ),
                _heroSlide(
                  context: context,
                  color: const Color(0xFF1B0F34),
                  badge: 'İkinci El Güvencesi',
                  title: 'Sürdürülebilir\nAlışveriş',
                  subtitle:
                      'Çevre dostu seçeneklerle hem tasarruf edin hem doğayı koruyun',
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: context.paddingHorizontal.right,
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
    required BuildContext context,
    required final Color color,
    required final String badge,
    required final String title,
    required final String subtitle,
  }) {
    bool _isHovered = false;

    return StatefulBuilder(
      builder: (final context, final setState) => MouseRegion(
        onEnter: (final _) => setState(() => _isHovered = true),
        onExit: (final _) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          // Responsive Margin ve Padding
          margin: EdgeInsets.symmetric(
              horizontal: context.isMobile ? 16 : 40,
              vertical: _isHovered ? 0 : 10),
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.02))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(context.borderRadius(1.5)),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [color.withOpacity(0.95), color.withOpacity(0.8)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.25 : 0.12),
                blurRadius: _isHovered ? 30 : 15,
                offset: Offset(0, _isHovered ? 15 : 8),
              )
            ],
          ),
          padding:
              EdgeInsets.all(context.responsive(mobile: 24.0, desktop: 60.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: context.spacing),
              Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: context.h2Size,
                      // Responsive H2
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(1, 1))
                      ])),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: context.bodySize, // Responsive Body
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(1, 1))
                    ],
                  )),
              SizedBox(height: context.spacingLarge),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            context.responsive(mobile: 20.0, desktop: 36.0),
                        vertical:
                            context.responsive(mobile: 14.0, desktop: 20.0)),
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

  // ================= SECTION HEADER =================
  SliverToBoxAdapter _buildSectionHeader(
      BuildContext context, final String title, final String subtitle) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            context.paddingHorizontal.left + (context.isMobile ? 0 : 20),
            context.spacingLarge * 2,
            context.paddingHorizontal.right,
            context.spacingLarge),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: TextStyle(
                  fontSize: context.h2Size,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(
                  fontSize: context.subtitleSize, color: Colors.black45)),
        ]),
      ),
    );
  }

  // =================== PRODUCT GRID (FIXED RESPONSIVE) ===================
  SliverPadding _buildProductGrid(BuildContext context, final dynamic state) {
    final products = state.dataList ?? [];
    return SliverPadding(
      padding: context.pagePadding, // Tutarlı padding
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          // Utils'den gelen dinamik kolon sayısı
          mainAxisSpacing: context.gridSpacing,
          crossAxisSpacing: context.gridSpacing,
          childAspectRatio:
              context.cardAspectRatio(), // Utils'den gelen aspect ratio
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
  SliverToBoxAdapter _buildShopByRoomSection(BuildContext context) {
    final rooms = [
      {
        "name": "Oturma Odası",
        "img":
            "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1200",
        "count": "25+ Ürün"
      },
      {
        "name": "Yatak Odası",
        "img":
            "https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=800",
        "count": "20+ Ürün"
      },
      {
        "name": "Mutfak",
        "img":
            "https://images.pexels.com/photos/2724748/pexels-photo-2724748.jpeg?auto=compress&cs=tinysrgb&w=1200",
        "count": "10+ Ürün"
      },
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height:
            context.responsive(mobile: 350.0, tablet: 400.0, desktop: 450.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding:
              EdgeInsets.symmetric(horizontal: context.paddingHorizontal.left),
          itemCount: rooms.length,
          itemBuilder: (final context, final index) => Container(
            width: context.responsive(
                mobile: 280.0, tablet: 350.0, desktop: 400.0),
            margin: EdgeInsets.only(right: context.spacingLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.borderRadius(2)),
              image: DecorationImage(
                  image: NetworkImage(rooms[index]["img"]!), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.borderRadius(2)),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent
                    ]),
              ),
              padding: EdgeInsets.all(context.spacingLarge),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rooms[index]["count"]!,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: context.captionSize)),
                  Text(rooms[index]["name"]!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: context.h2Size,
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
  SliverToBoxAdapter _buildBusinessIntroduction(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding,
        padding: context.paddingAll * 2, // İç boşluğu artır
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.borderRadius(2)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 40)
            ]),
        child: Text("20 Yıllık Esnaf Güvencesi",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: context.h2Size, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // =================== TESTIMONIALS ===================
  SliverToBoxAdapter _buildTestimonialsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 240, // Yüksekliği biraz artırdık
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: context.paddingHorizontal.left),
          itemCount: 5,
          itemBuilder: (final context, final i) => Container(
            width: context.responsive(mobile: 300.0, desktop: 350.0),
            margin: EdgeInsets.only(right: context.spacingLarge),
            padding: EdgeInsets.all(context.spacingLarge),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.borderRadius(1.5)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.03), blurRadius: 20)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  for (int i = 0; i < 5; i++)
                    Icon(Icons.star,
                        color: Colors.orange, size: context.iconSmall),
                ]),
                SizedBox(height: context.spacing),
                Text(
                    "Ürün kalitesi beklediğimden çok daha iyi çıktı. Esnafımızın dürüstlüğü ve hızı için teşekkürler.",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: context.bodySize,
                        height: 1.4)),
                const Spacer(),
                Text("Ayşe Y. - Müşteri",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                        fontSize: context.captionSize)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =================== STATS SECTION (REFACTORED) ===================
  SliverToBoxAdapter _buildStatsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding,
        padding: EdgeInsets.symmetric(
            vertical: context.responsive(mobile: 60.0, desktop: 100.0)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(context.borderRadius(2)),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF103E35).withOpacity(0.05),
              blurRadius: 50,
              offset: const Offset(0, 20),
            )
          ],
        ),
        // Flex widget ile responsive yönlendirme (Column vs Row)
        child: Flex(
          direction: context.isMobile ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildStatItems(context)
              .map((item) => Padding(
                    padding: EdgeInsets.only(bottom: context.isMobile ? 40 : 0),
                    child: item,
                  ))
              .toList(),
        ),
      ),
    );
  }

  List<Widget> _buildStatItems(BuildContext context) {
    return [
      _statItem(
          context, "2.5K", "Mutlu Müşteri", Icons.face_retouching_natural),
      _statItem(context, "20 Yıl", "Deneyim", Icons.verified_user_outlined),
      _statItem(context, "15K+", "Teslimat", Icons.local_shipping_outlined),
    ];
  }

  Widget _statItem(BuildContext context, final String val, final String label,
      final IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(context.spacingLarge),
          decoration: const BoxDecoration(
            color: Color(0xFFE8F1EF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: const Color(0xFF103E35), size: context.iconLarge),
        ),
        SizedBox(height: context.spacing),
        Text(val,
            style: TextStyle(
                color: const Color(0xFF1E293B),
                fontSize: context.h1Size, // Responsive Font
                fontWeight: FontWeight.w900,
                letterSpacing: -2)),
        Text(label,
            style: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontSize: context.bodySize,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
      ],
    );
  }

  // =================== CALL TO ACTION ===================
  SliverToBoxAdapter _buildCTASection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding,
        padding:
            EdgeInsets.all(context.responsive(mobile: 30.0, desktop: 60.0)),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(context.borderRadius(2)),
          image: const DecorationImage(
            image: NetworkImage(
                "https://www.transparenttextures.com/patterns/cubes.png"),
            opacity: 0.05,
          ),
        ),
        child: Flex(
          direction: context.isMobile ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: context.isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text("Showroom Deneyimi",
                    textAlign:
                        context.isMobile ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: context.h2Size,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Text("Eviniz için en kaliteli parçaları yerinde görün.",
                    textAlign:
                        context.isMobile ? TextAlign.center : TextAlign.start,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: context.bodySize)),
              ],
            ),
            if (context.isMobile) const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8F1EF),
                foregroundColor: const Color(0xFF103E35),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Text("MUTLAKA GEL",
                  style:
                      TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
          ],
        ),
      ),
    );
  }

  // =================== MODERN FOOTER ===================
  SliverToBoxAdapter _buildModernFooter(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(24, 60, 24, 40),
        padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal.left, vertical: 60),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1EF).withOpacity(0.5),
          borderRadius: BorderRadius.circular(48),
        ),
        child: Column(
          children: [
            // Mobilde footer elemanlarını alt alta, desktopta yan yana
            Flex(
              direction: context.isMobile ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SAĞLAM SPOT",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.black.withOpacity(0.8))),
                if (context.isMobile) const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Mobilde ortala
                  children: [
                    _footerSocial(Icons.facebook),
                    const SizedBox(width: 15),
                    _footerSocial(Icons.camera_alt),
                  ],
                )
              ],
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.black12),
            const SizedBox(height: 40),
            Text("© 2026 Sağlam Spot. Zerafet ve Güvenin Buluştuğu Nokta.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: context.captionSize,
                    fontWeight: FontWeight.w500)),
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
