import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import 'package:saglamspot/presentation/pages/main_pages/home/widgets/furniture_tips_section.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/providers/product/product_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Chairs';

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
    final isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: AppColors.background, // Görseldeki Soft Mint
      body: CustomScrollView(
        slivers: [
          // 1. NAVIGATION BAR (Sliver kalarak çift barı önler)
          _buildSliverAppBar(context),

          // 2. HERO TITLE (Görseldeki meşhur başlık)
          _buildHeroHeader(context),

          // 3. SEARCH BAR (Kapsül Tasarım)
          _buildSearchBar(context),

          // 4. CATEGORIES (Siyah/Beyaz Oval Butonlar)
          _buildCategoryPills(context),

          // 5. FEATURED PRODUCTS (Yatay Scroll & Yeni Kartlar)
          _buildHorizontalProducts(context, productState),

          // 6. SPECIAL OFFER BANNER
          _buildSpecialOfferBanner(context, isMobile),

          // 7. BUSINESS SECTION (Esnaf Tanıtımı)
          _buildBusinessIntro(context, isMobile),

          // 8. TIPS SECTION
          const FurnitureTipsSection(),

          // 9. STATS (Siyah Premium Kart)
          _buildPremiumStats(context, isMobile),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(final BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      title: Row(
        children: [
          const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/profile.jpg')),
          const SizedBox(width: 12),
          Text('SağlamSpot',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: context.h4Size,
                  fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined,
                color: Colors.black, size: 28)),
        const SizedBox(width: 16),
      ],
    );
  }

  SliverToBoxAdapter _buildHeroHeader(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            context.responsive(mobile: 20, desktop: 40), 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Discover Your',
                style: TextStyle(
                    fontSize: context.heroSize,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textPrimary,
                    letterSpacing: -1)),
            Text('Furniture Space',
                style: TextStyle(
                    fontSize: context.heroSize,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    color: AppColors.textPrimary,
                    letterSpacing: -1.5)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSearchBar(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.black.withOpacity(0.05))),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search, color: Colors.black45),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15)),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoryPills(final BuildContext context) {
    final cats = [
      {'id': 'All', 'icon': Icons.apps, 'label': 'All'},
      {'id': 'Tables', 'icon': Icons.table_bar, 'label': 'Tables'},
      {'id': 'Chairs', 'icon': Icons.chair, 'label': 'Chairs'},
      {'id': 'Sofas', 'icon': Icons.weekend, 'label': 'Sofas'},
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cats.length,
          itemBuilder: (final context, final index) {
            final cat = cats[index];
            final isSelected = _selectedCategory == cat['id'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: ActionChip(
                onPressed: () =>
                    setState(() => _selectedCategory = cat['id'] as String),
                avatar: Icon(cat['icon'] as IconData,
                    size: 18, color: isSelected ? Colors.white : Colors.black),
                label: Text(cat['label'] as String),
                backgroundColor: isSelected ? Colors.black : Colors.white,
                labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
                shape: StadiumBorder(
                    side: BorderSide(
                        color: isSelected ? Colors.black : Colors.black12)),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHorizontalProducts(
      final BuildContext context, final dynamic state) {
    final prods = state.dataList ?? [];
    return SliverToBoxAdapter(
      child: Container(
        height: 380,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: prods.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: prods.length,
                separatorBuilder: (final _, final __) =>
                    const SizedBox(width: 20),
                itemBuilder: (final context, final index) => SizedBox(
                    width: 240,
                    child: CustomProductCard(product: prods[index])),
              ),
      ),
    );
  }

  SliverToBoxAdapter _buildSpecialOfferBanner(
      final BuildContext context, final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
            borderRadius: BorderRadius.circular(32)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Süper İndirim!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Seçili ürünlerde %70 indirim.',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 16)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBusinessIntro(
      final BuildContext context, final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: [
            const Icon(Icons.storefront_outlined,
                size: 48, color: Colors.black),
            const SizedBox(height: 16),
            const Text('20 Yıllık Esnaf Güvencesi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('2003\'ten beri kaliteli hizmetin adresi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPremiumStats(
      final BuildContext context, final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('2,500+', 'Happy Clients'),
            _buildStatItem('5,000+', 'Items Sold'),
            _buildStatItem('20+', 'Years Exp.'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(final String val, final String label) {
    return Column(
      children: [
        Text(val,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        Text(label,
            style:
                TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
      ],
    );
  }
}
