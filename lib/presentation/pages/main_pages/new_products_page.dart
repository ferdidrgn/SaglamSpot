import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../domain/entities/product.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import '../../../core/theme/app_colors.dart';

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends ConsumerState<NewProductsPage> {
  String _selectedLocalCategory = "Tümü";
  int _hoveredIndex = -1; // Hover index for Web/Desktop

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newProducts = ref.watch(newProductsProvider);
    final isLoading = ref.watch(productProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Floating Typography (Background)
          Positioned(
            top: 100,
            right: -50,
            child: Opacity(
              opacity: 0.05,
              child: Text(
                "Stylish",
                style: TextStyle(
                  fontSize: 180,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textSecondary.withOpacity(0.15),
                ),
              ),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(context, newProducts.length),
              _buildCategories(context),
              if (isLoading)
                _buildLoading()
              else if (newProducts.isEmpty)
                _buildEmpty()
              else
                _buildProductGrid(context, newProducts),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ],
      ),
    );
  }

  // --- HEADER ---
  SliverToBoxAdapter _buildHeader(BuildContext context, int count) {
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
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                const Text(
                  "NEW ARRIVALS 2024",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Kusursuzluğun\nYeni Adresi",
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 40.0, desktop: 64.0),
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _buildCountBadge(count),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "Sıfır kilometre ihtişam, yaşam alanlarınız için yeniden tanımlandı.",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
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
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
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

  // --- KATEGORİLER ---
  SliverToBoxAdapter _buildCategories(BuildContext context) {
    final Map<String, IconData> cats = {
      "Tümü": Icons.auto_awesome_mosaic_rounded,
      "Koltuk": Icons.chair_rounded,
      "Masa": Icons.table_restaurant_rounded,
      "Yatak": Icons.bed_rounded,
      "Dolap": Icons.door_sliding_rounded
    };

    return SliverToBoxAdapter(
      child: SizedBox(
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
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isActive ? 0.15 : 0.05),
                      blurRadius: isActive ? 20 : 10,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cats[key],
                        color: isActive ? Colors.white : AppColors.textPrimary,
                        size: 20),
                    const SizedBox(width: 10),
                    Text(key,
                        style: TextStyle(
                            color:
                                isActive ? Colors.white : AppColors.textPrimary,
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

  // --- ÜRÜN GRID ---
  SliverPadding _buildProductGrid(
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
            final isHovered = _hoveredIndex == index;

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = -1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isHovered ? 0.2 : 0.05),
                      blurRadius: isHovered ? 25 : 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Transform.translate(
                  offset: Offset(0, isHovered ? -10 : 0),
                  child: Transform.scale(
                    scale: isHovered ? 1.03 : 1.0,
                    child: CustomProductCard(product: filtered[index]),
                  ),
                ),
              ),
            );
          },
          childCount: filtered.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildLoading() => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        ),
      );

  SliverToBoxAdapter _buildEmpty() => SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Icon(Icons.auto_awesome_rounded,
                  size: 80, color: AppColors.textSecondary.withOpacity(0.2)),
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
