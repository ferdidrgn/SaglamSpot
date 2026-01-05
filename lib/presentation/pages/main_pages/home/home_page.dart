import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(nextPage,
            duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
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
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final isMobile = MediaQuery.of(context).size.width < 900;
    const bgMint = Color(0xFFE8F1EF);

    return Scaffold(
      backgroundColor: bgMint,
      body: CustomScrollView(
        slivers: [
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

  SliverToBoxAdapter _buildWebHeroSection(bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        height: 500,
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 20))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildHeroSlide(
                    color: const Color(0xFF103E35),
                    badge: 'Yeni Koleksiyon',
                    title: 'Modern Mobilyalar\nEviniz İçin',
                    subtitle: 'Kaliteli ve şık mobilyalarla yaşam alanınızı yenileyin',
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
                    subtitle: 'Çevre dostu seçeneklerle hem tasarruf edin hem doğayı koruyun',
                  ),
                ],
              ),
              Positioned(
                bottom: 30, right: 80,
                child: Row(
                  children: List.generate(3, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(4),
                    width: _currentPage == i ? 30 : 8,
                    height: 8,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSlide({required Color color, required String badge, required String title, required String subtitle}) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: Text(badge, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold, height: 1.1)),
          const SizedBox(height: 12),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 20)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Keşfet", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  SliverPadding _buildWebProductGrid(dynamic state, bool isMobile) {
    final products = state.dataList ?? [];
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 5,
          mainAxisSpacing: 30, crossAxisSpacing: 30, mainAxisExtent: 360,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => CustomProductCard(product: products[index]),
          childCount: products.length > 10 ? 10 : products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBusinessIntroduction(bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(40), padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 40)]),
        child: const Text("20 Yıllık Esnaf Güvencesi", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ),
    );
  }

  SliverToBoxAdapter _buildStatsSection(bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(40), padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(48)),
        child: const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text("2,500+ Müşteri", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text("20+ Yıl Tecrübe", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  SliverToBoxAdapter _buildModernCategories() {
    return const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(40), child: Text("Kategoriler", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))));
  }
}
