import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'widgets/furniture_tips_section.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../data/providers/product/product_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (final timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);
    final isMobile = MediaQuery.of(context).size.width < 900;
    const bgMint = Color(0xFFE8F1EF); // Görseldeki Soft Mint

    return Scaffold(
      backgroundColor: bgMint,
      body: CustomScrollView(
        slivers: [
          // 1. Üst Başlık Bölümü (Discover Your Furniture Space)
          _buildDiscoveryHeader(isMobile),

          // 2. Custom Search Bar
          _buildCustomSearchBar(isMobile),

          // 3. Hero Slider (Görseldeki gibi başlığın altında konumlandırıldı)
          _buildWebHeroSection(isMobile),

          _buildModernCategories(),
          _buildWebProductGrid(productState, isMobile),
          _buildBusinessIntroduction(isMobile),
          const FurnitureTipsSection(),
          _buildStatsSection(isMobile),
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }

  // GÖRSELDEKİ DISCOVERY BAŞLIĞI
  SliverToBoxAdapter _buildDiscoveryHeader(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            isMobile ? 24 : 48, isMobile ? 40 : 60, isMobile ? 24 : 48, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Discover Your",
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Furniture Space",
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            // Görseldeki profil/ikon alanı
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child:
                  const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // MODERN CUSTOM SEARCH BAR
  SliverToBoxAdapter _buildCustomSearchBar(final bool isMobile) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48, vertical: 10),
        child: Container(
          width: isMobile ? double.infinity : 600,
          // Web'de çok uzamaması için sınırladık
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search furniture...",
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onSubmitted: (final value) {
                context.push('/search?q=$value');
              },
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
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 40,
                offset: const Offset(0, 20))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (final i) => setState(() => _currentPage = i),
                children: [
                  _buildHeroSlide(
                    color: const Color(0xFF103E35),
                    badge: 'Yeni Koleksiyon',
                    title: 'Modern Mobilyalar\nEviniz İçin',
                    subtitle:
                        'Kaliteli ve şık mobilyalarla yaşam alanınızı yenileyin',
                  ),
                  _buildHeroSlide(
                    color: const Color(0xFF3E2D10),
                    badge: 'Spot Ürünler',
                    title: 'İnanılmaz Fırsatlar\nSizi Bekliyor',
                    subtitle: '%70\'e varan indirimlerle kaliteli mobilyalar',
                  ),
                  _buildHeroSlide(
                    color: const Color(0xFF1B0F34),
                    badge: 'İkinci El Ürünler',
                    title: 'Sürdürülebilir\nAlışveriş',
                    subtitle:
                        'Çevre dostu seçeneklerle hem tasarruf edin hem doğayı koruyun',
                  ),
                ],
              ),
              Positioned(
                bottom: 30,
                right: 80,
                child: Row(
                  children: List.generate(
                      3,
                      (final i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(4),
                            width: _currentPage == i ? 30 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSlide(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20)),
            child: Text(badge,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Keşfet",
                style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
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
          mainAxisExtent: 360,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) =>
              CustomProductCard(product: products[index]),
          childCount: products.length > 10 ? 10 : products.length,
        ),
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

  SliverToBoxAdapter _buildModernCategories() {
    return const SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.all(40),
            child: Text("Kategoriler",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))));
  }
}
