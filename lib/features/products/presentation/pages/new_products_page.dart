import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/theme/theme_context_extension.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../domain/entites/product.dart';

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends ConsumerState<NewProductsPage> {
  String _selectedCategory = 'Tümü';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.scaffoldBackgroundColor,
      endDrawer: _buildLuxeFilterDrawer(context),
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final e, final _) => Center(child: Text('Hata: $e')),
        data: (final _) {
          final products = ref.watch(newDealsProductsProvider);
          final filtered = _applyFilters(products);

          return Stack(
            children: [
              // 1. ARKA PLAN DERİNLİĞİ (Girift Mozaik Desenleri)
              _buildComplexBackground(context),

              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 2. CAM EFEKTLİ (GLASS) HEADER
                  _buildGlassHeader(context, filtered.length),

                  // 3. MOZAİK KATEGORİ SEÇİCİ
                  _buildMosaicCategoryBar(context),

                  // 4. WEB REKLAM ALANI 1
                  if (context.isDesktop) _buildSliverAd(100),

                  // 5. ANA MOZAİK GRID (İstediğin grift yapı)
                  _buildGriftMosaicGrid(context, filtered),

                  // 6. WEB REKLAM ALANI 2
                  _buildSliverAd(120),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // --- 🎨 ORIJİNAL MOZAİK GRID ---
  Widget _buildGriftMosaicGrid(final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: context.pagePadding,
      sliver: SliverGrid(
        // MaxCrossAxisExtent kullanarak kartların ekran genişliğine göre
        // asimetrik dizilmesini sağlıyoruz, bu mozaik havası katar.
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: context.responsive(mobile: 220.0, desktop: 380.0),
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          // Her ekran boyutunda farklı oranlar kullanarak tekdüzeliği kırıyoruz
          childAspectRatio: context.responsive(
              mobile: 0.65,
              tablet: 0.72,
              desktop: 0.82,
              largeDesktop: 0.88
          ),
        ),
        delegate: SliverChildBuilderDelegate(
              (final context, final index) {
            // Her kartın girişine hafif bir gecikme/animasyon eklenebilir
            return CustomProductCard(product: products[index]);
          },
          childCount: products.length,
        ),
      ),
    );
  }

  // --- 🌌 DERİNLİKLİ ARKA PLAN (Orijinal Tasarım) ---
  Widget _buildComplexBackground(final BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Katman 1: Soyut Geometrik Mozaikler
          CustomPaint(
            size: Size.infinite,
            painter: _MosaicBackgroundPainter(
              color: context.primaryColor.withOpacity(0.03),
            ),
          ),
          // Katman 2: Derinlik katan blur küreler
          Positioned(
            top: -100, right: -50,
            child: _buildDepthOrb(context, 300, context.secondaryColor.withOpacity(0.05)),
          ),
          Positioned(
            bottom: 100, left: -100,
            child: _buildDepthOrb(context, 400, context.primaryColor.withOpacity(0.04)),
          ),
        ],
      ),
    );
  }

  Widget _buildDepthOrb(final BuildContext context, final double size, final Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), child: Container()),
    );
  }

  // --- 🏗️ SLIVER REKLAM BİLEŞENİ ---
  Widget _buildSliverAd(final double h) => SliverToBoxAdapter(
    child: Padding(
      padding: context.pagePadding.copyWith(top: 20, bottom: 20),
      child: AdsenseBanner(height: h),
    ),
  );

  // --- 📐 MOZAİK KATEGORİ BUTONLARI ---
  Widget _buildMosaicCategoryBar(final BuildContext context) {
    final cats = ['Tümü', 'Koltuk', 'Masa', 'Yatak', 'Dolap', 'Mutfak', 'Aydınlatma'];
    return SliverToBoxAdapter(
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: context.pagePadding.left),
          itemCount: cats.length,
          itemBuilder: (final context, final i) {
            final active = _selectedCategory == cats[i];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.only(right: 15),
              child: ChoiceChip(
                label: Text(cats[i]),
                selected: active,
                onSelected: (final _) => setState(() => _selectedCategory = cats[i]),
                backgroundColor: context.surfaceColor,
                selectedColor: context.primaryColor,
                labelStyle: TextStyle(
                  color: active ? Colors.white : context.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            );
          },
        ),
      ),
    );
  }

  // Header ve Drawer kodları bir önceki stabil yapıyla aynıdır...
  SliverAppBar _buildGlassHeader(final BuildContext context, final int count) => SliverAppBar(
    pinned: true, expandedHeight: 220, backgroundColor: Colors.transparent,
    flexibleSpace: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: context.pagePadding.left, bottom: 30),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SIFIR ÜRÜNLER', style: TextStyle(color: context.secondaryColor, fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w900)),
              Text('Yeni Koleksiyon', style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.w900, fontSize: context.h2Size)),
              const SizedBox(height: 5),
              Container(height: 2, width: 40, color: context.secondaryColor),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildLuxeFilterDrawer(final BuildContext context) => Drawer(child: Center(child: Text("Filtreleme Özellikleri")));

  List<Product> _applyFilters(final List<Product> list) => _selectedCategory == 'Tümü' ? list : list.where((final e) => e.category == _selectedCategory).toList();
}

// --- 🖌️ ARKA PLAN MOZAİK PAINTER ---
class _MosaicBackgroundPainter extends CustomPainter {
  final Color color;
  _MosaicBackgroundPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.0;
    const double step = 60.0;

    // Girift çizgi ve mozaik desenleri çizimi
    for (double i = 0; i < size.width; i += step) {
      for (double j = 0; j < size.height; j += step) {
        if ((i + j) % (step * 3) == 0) {
          canvas.drawRect(Rect.fromLTWH(i, j, step * 0.5, step * 0.5), paint);
        }
        canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) => false;
}