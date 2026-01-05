import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../domain/entities/product.dart';
import 'dart:ui'; // Glassmorphism efekti için

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends ConsumerState<NewProductsPage> {
  String _selectedLocalCategory = "Tümü";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final newProducts = ref.watch(newProductsProvider);
    final isLoading = ref.watch(productProvider).isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3), // Daha zengin bir zemin
      body: Stack(
        children: [
          // 1. Arka Plan Dekorasyonu (Floating Typography)
          Positioned(
            top: 100,
            right: -50,
            child: Opacity(
              opacity: 0.03,
              child: Text("LUXURY",
                  style: TextStyle(
                      fontSize: 180,
                      fontWeight: FontWeight.w900,
                      color: Colors.black)),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 2. Debdebeli Header (SliverAppBar Tarzı)
              _buildMajesticHeader(context, newProducts.length),

              // 3. İhtişamlı Kategori Kartları
              _buildMajesticCategories(context),

              // 4. İçerik Durumları
              if (isLoading)
                _buildGlowingLoading()
              else if (newProducts.isEmpty)
                _buildEmptySliver(context)
              else
                _buildPremiumProductGrid(context, newProducts),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ],
      ),
    );
  }

  // --- İHTİŞAMLI HEADER ---
  SliverToBoxAdapter _buildMajesticHeader(BuildContext context, int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.responsive(mobile: 24.0, desktop: 60.0),
          80,
          context.responsive(mobile: 24.0, desktop: 60.0),
          40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 2,
                  color: const Color(0xFFC9A227), // Altın rengi çizgi
                ),
                const SizedBox(width: 10),
                const Text("NEW ARRIVALS 2024",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: Color(0xFFC9A227))),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                      "Kusursuzluğun\nYeni Adresi", // Daha etkileyici metin
                      style: TextStyle(
                          fontSize:
                              context.responsive(mobile: 40.0, desktop: 64.0),
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -2)),
                ),
                _buildCountBadge(count),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
                "Sıfır kilometre ihtişam, yaşam alanlarınız için yeniden tanımlandı.",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black, // Güçlü kontrast
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10))
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$count",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            const Text("PIECES",
                style: TextStyle(
                    color: Colors.white54, fontSize: 10, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  // --- İHTİŞAMLI KATEGORİLER ---
  SliverToBoxAdapter _buildMajesticCategories(BuildContext context) {
    final Map<String, IconData> cats = {
      "Tümü": Icons.auto_awesome_mosaic_rounded,
      "Koltuk": Icons.chair_rounded,
      "Masa": Icons.table_restaurant_rounded,
      "Yatak": Icons.bed_rounded,
      "Dolap": Icons.door_sliding_rounded
    };

    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
              left: context.responsive(mobile: 24.0, desktop: 60.0)),
          itemCount: cats.length,
          itemBuilder: (context, i) {
            final key = cats.keys.elementAt(i);
            final isActive = _selectedLocalCategory == key;
            return GestureDetector(
              onTap: () => setState(() => _selectedLocalCategory = key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 130,
                margin: const EdgeInsets.only(right: 15, bottom: 20),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 8))
                        ]
                      : [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10)
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cats[key],
                        color: isActive ? Colors.white : Colors.black,
                        size: 20),
                    const SizedBox(width: 10),
                    Text(key,
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

  // --- PREMIUM PRODUCT GRID ---
  SliverPadding _buildPremiumProductGrid(
      BuildContext context, List<Product> products) {
    final filtered = _selectedLocalCategory == "Tümü"
        ? products
        : products.where((p) => p.category == _selectedLocalCategory).toList();

    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 24.0, desktop: 60.0)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(),
          childAspectRatio:
              context.responsive(mobile: 0.7, tablet: 0.75, desktop: 0.82),
          crossAxisSpacing: 30,
          mainAxisSpacing: 40,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Animated Slide-Up Efekti gibi bir CustomProductCard beklentisi
            return CustomProductCard(product: filtered[index]);
          },
          childCount: filtered.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildGlowingLoading() {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 1),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildEmptySliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Icon(Icons.auto_awesome_rounded,
                size: 80, color: Colors.black.withOpacity(0.1)),
            const SizedBox(height: 24),
            const Text("Sessizlik ve Zerafet",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            const Text("Bu koleksiyon yakında sizlerle buluşacak."),
          ],
        ),
      ),
    );
  }
}
