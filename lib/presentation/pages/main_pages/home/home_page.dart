import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'widgets/furniture_tips_section.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../data/providers/product/product_provider.dart';
import '../../../../core/theme/app_colors.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late PageController _heroController;
  int _currentPage = 0;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  String _activeCategory = "All";

  @override
  void initState() {
    super.initState();
    _heroController = PageController();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (final timer) {
      if (_heroController.hasClients) {
        int nextPage = (_currentPage + 1) % 3;
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
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);
    final isMobile = MediaQuery.of(context).size.width < 900;
    const bgMint = Color(0xFFE8F1EF); // Soft Mint

    return Scaffold(
      backgroundColor: bgMint,
      body: CustomScrollView(
        slivers: [
          // 1. YENİLENEN ÜST BAŞLIK (Discovery Header)
          _buildDiscoveryHeader(isMobile),

          // 2. ARAMA ÇUBUĞU
          _buildCustomSearchBar(isMobile),

          // 3. DİNAMİK KATEGORİ CHIPS (Görseldeki İkonlu Yapı)
          _buildDynamicCategorySection(isMobile),

          // 4. HERO SLIDER
          _buildWebHeroSection(isMobile),

          // 5. SHOP BY ROOM (Yeni Bölüm)
          _buildSectionHeader("Shop by Room", "Yaşam alanınıza göre keşfedin"),
          _buildShopByRoomSection(isMobile),

          // 6. TREND ÜRÜNLER SLIDER (Yeni Bölüm)
          _buildSectionHeader(
              "Trend Ürünler", "Bu haftanın en çok beğenilenleri"),
          _buildTrendSlider(productState, isMobile),

          // 7. ANA ÜRÜN GRİDİ
          _buildSectionHeader(
              "Koleksiyonun Tamamı", "Kalite ve estetik bir arada"),
          _buildWebProductGrid(productState, isMobile),

          // 8. ESNAF TANITIMI
          _buildBusinessIntroduction(isMobile),

          // 9. PÜF NOKTALARI
          const FurnitureTipsSection(),

          // 10. MÜŞTERİ YORUMLARI (Yeni Bölüm)
          _buildSectionHeader("Müşteri Deneyimleri", "Mutlu evlerden kareler"),
          _buildTestimonialsSection(isMobile),

          // 11. STATS SECTION
          _buildStatsSection(isMobile),

          // 12. MODERN FOOTER (Yeni Bölüm)
          _buildModernFooter(isMobile),
        ],
      ),
    );
  }

  // --- 1. DISCOVERY HEADER ---
  SliverToBoxAdapter _buildDiscoveryHeader(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.fromLTRB(isMobile ? 24 : 60, 60, isMobile ? 24 : 60, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Discover Your",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: Colors.black54)),
                Text("Furniture Space",
                    style: TextStyle(
                        fontSize: isMobile ? 36 : 52,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.5,
                        height: 1.1)),
              ],
            ),
            Row(
              children: [
                _buildCircularIconButton(Icons.notifications_none_rounded),
                const SizedBox(width: 12),
                _buildCircularIconButton(Icons.shopping_bag_outlined),
                const SizedBox(width: 12),
                const CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150?u=a")),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- 3. DİNAMİK KATEGORİ CHIPS ---
  SliverToBoxAdapter _buildDynamicCategorySection(final bool isMobile) {
    final categories = [
      {"name": "All", "icon": Icons.grid_view_rounded},
      {"name": "Tables", "icon": Icons.table_restaurant_outlined},
      {"name": "Chairs", "icon": Icons.chair_alt_rounded},
      {"name": "Sofas", "icon": Icons.weekend_outlined},
      {"name": "Beds", "icon": Icons.bed_outlined},
    ];
    return SliverToBoxAdapter(
      child: Container(
        height: 110,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: isMobile ? 24 : 60),
          itemCount: categories.length,
          itemBuilder: (final context, final i) {
            bool isActive = _activeCategory == categories[i]["name"];
            return GestureDetector(
              onTap: () => setState(
                  () => _activeCategory = categories[i]["name"] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black : Colors.white,
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

  // --- 5. SHOP BY ROOM SECTION ---
  SliverToBoxAdapter _buildShopByRoomSection(final bool isMobile) {
    final rooms = [
      {
        "name": "Living Room",
        "img":
            "https://images.unsplash.com/photo-1583847268964-b28dc2f51ac9?q=80&w=600"
      },
      {
        "name": "Bedroom",
        "img":
            "https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=600"
      },
      {
        "name": "Dining Room",
        "img":
            "https://images.unsplash.com/photo-1617806118233-f8e1374d6f9c?q=80&w=600"
      },
    ];
    return SliverToBoxAdapter(
      child: Container(
        height: 350,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 60),
        child: Row(
          children: rooms
              .map((final room) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        image: DecorationImage(
                            image: NetworkImage(room["img"]!),
                            fit: BoxFit.cover),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent
                              ]),
                        ),
                        padding: const EdgeInsets.all(30),
                        alignment: Alignment.bottomLeft,
                        child: Text(room["name"]!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // --- 10. TESTIMONIALS SECTION ---
  SliverToBoxAdapter _buildTestimonialsSection(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        height: 220,
        margin: const EdgeInsets.symmetric(vertical: 20),
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
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  Icon(Icons.star, color: Colors.orange, size: 18),
                  Icon(Icons.star, color: Colors.orange, size: 18)
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

  // --- 12. MODERN FOOTER ---
  SliverToBoxAdapter _buildModernFooter(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(40, 60, 40, 40),
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(50)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SaglamSpot",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Eviniz için en iyi parçaları keşfedin.",
                          style: TextStyle(color: Colors.white54)),
                    ]),
                Row(children: [
                  _footerSocial(Icons.facebook),
                  const SizedBox(width: 15),
                  _footerSocial(Icons.camera_alt),
                  const SizedBox(width: 15),
                  _footerSocial(Icons.send)
                ]),
              ],
            ),
            const Divider(color: Colors.white12, height: 80),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("© 2024 SaglamSpot Mobilya. Tüm hakları saklıdır.",
                    style: TextStyle(color: Colors.white30)),
                Row(children: [
                  Text("Gizlilik Politikası",
                      style: TextStyle(color: Colors.white30)),
                  SizedBox(width: 30),
                  Text("Kullanım Şartları",
                      style: TextStyle(color: Colors.white30))
                ]),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- YARDIMCI METODLAR ---
  Widget _buildCircularIconButton(final IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Icon(icon, color: Colors.black),
    );
  }

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
          Text(subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.black45)),
        ]),
      ),
    );
  }

  Widget _footerSocial(final IconData i) => Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white12), shape: BoxShape.circle),
      child: Icon(i, color: Colors.white, size: 20));

  // Mevcut Grid, Hero ve Stats metodlarını buraya aynen (veya gölgeleri güncelleyerek) dahil edebilirsin...
  // (Önceki kodundaki _buildWebHeroSection, _buildWebProductGrid, _buildStatsSection buraya gelecek)

  SliverToBoxAdapter _buildCustomSearchBar(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: isMobile ? 24 : 60, vertical: 10),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 650),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10))
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: "Search furniture...",
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildWebHeroSection(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        height: 500,
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40)
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: PageView(
            controller: _heroController,
            onPageChanged: (final i) => setState(() => _currentPage = i),
            children: [
              _heroSlide(
                  color: const Color(0xFF103E35),
                  badge: 'Yeni Koleksiyon',
                  title: 'Modern Mobilyalar\nEviniz İçin',
                  subtitle:
                      'Kaliteli ve şık mobilyalarla yaşam alanınızı yenileyin'),
              _heroSlide(
                  color: const Color(0xFF3E2D10),
                  badge: 'Spot Ürünler',
                  title: 'İnanılmaz Fırsatlar\nSizi Bekliyor',
                  subtitle: '%70\'e varan indirimlerle kaliteli mobilyalar'),
              _heroSlide(
                  color: const Color(0xFF1B0F34),
                  badge: 'İkinci El Ürünler',
                  title: 'Sürdürülebilir\nAlışveriş',
                  subtitle:
                      'Çevre dostu seçeneklerle hem tasarruf edin hem doğayı koruyun'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroSlide(
      {required final Color color,
      required final String badge,
      required final String title,
      required final String subtitle}) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(badge,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    height: 1.1)),
            const SizedBox(height: 12),
            Text(subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 20)),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                child: const Text("Keşfet",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
    );
  }

  SliverPadding _buildWebProductGrid(final dynamic state, final bool isMobile) {
    final products = state.dataList ?? [];
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 5,
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            mainAxisExtent: 360),
        delegate: SliverChildBuilderDelegate(
            (final context, final index) =>
                CustomProductCard(product: products[index]),
            childCount: products.length > 10 ? 10 : products.length),
      ),
    );
  }

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

  SliverToBoxAdapter _buildStatsSection(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(40),
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(48)),
        child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("2,500+ Müşteri",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              Text("20+ Yıl Tecrübe",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ]),
      ),
    );
  }

  Widget _buildTrendSlider(final dynamic state, final bool isMobile) {
    final products = state.dataList ?? [];
    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: isMobile ? 24 : 60),
          itemCount: products.length,
          itemBuilder: (final context, final i) => Container(
              width: 200,
              margin: const EdgeInsets.only(right: 20),
              child: CustomProductCard(product: products[i])),
        ),
      ),
    );
  }
}
