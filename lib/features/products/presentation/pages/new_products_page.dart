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

class _NewProductsPageState extends ConsumerState<NewProductsPage>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'Tümü';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.scaffoldBackgroundColor,
      endDrawer: const Drawer(child: Center(child: Text("Gelişmiş Filtreler"))),
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final e, final _) => Center(child: Text('Hata: $e')),
        data: (final _) {
          final products = ref.watch(newDealsProductsProvider);
          final filtered = products
              .where((e) =>
                  _selectedCategory == 'Tümü' ||
                  e.category == _selectedCategory)
              .toList();

          return Stack(
            children: [
              // 1. KATMAN: Grift Graffiti & Geometrik Arkaplan
              _buildGraffitiBackground(context),

              // 2. KATMAN: İçerik
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ARTISTIC HEADER
                  _buildArtisticHeader(context),

                  // YENİ ÖZELLİK: İSTATİSTİK ŞERİDİ (Girift Tasarım)
                  _buildGlitchStats(context),

                  // MOZAİK KATEGORİ SEÇİCİ
                  _buildMosaicCategoryBar(context),

                  // WEB REKLAM ALANI
                  _buildSliverAd(100),

                  // ANA ÜRÜN GRID (Asimetrik Mozaik)
                  _buildGriftGrid(context, filtered),

                  // ALT REKLAM VE BOŞLUK
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

  // --- 🎨 GRAFFITI & GRIFT ARKAPLAN ---
  Widget _buildGraffitiBackground(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Dinamik Çizgiler ve Graffiti Formları
          CustomPaint(
            size: Size.infinite,
            painter: _GraffitiPainter(
              lineColor: context.primaryColor.withOpacity(0.04),
              shapeOn: context.secondaryColor.withOpacity(0.02),
            ),
          ),
          // Derinlik katan büyük flu küreler
          Positioned(
            top: -50,
            left: -100,
            child: _buildBlurOrb(400, context.primaryColor.withOpacity(0.05)),
          ),
          Positioned(
            bottom: 200,
            right: -150,
            child: _buildBlurOrb(500, context.secondaryColor.withOpacity(0.03)),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container()),
    );
  }

  // --- 🎭 ARTISTIC HEADER (Grift Tasarım) ---
  Widget _buildArtisticHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 280,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Header Arkası Mozaik Desen
            CustomPaint(
                painter: _HeaderPatternPainter(
                    color: context.secondaryColor.withOpacity(0.1))),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.scaffoldBackgroundColor.withOpacity(0.2),
                        context.scaffoldBackgroundColor
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: context.pagePadding.left,
              bottom: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NEW ARRIVALS',
                      style: TextStyle(
                          color: context.secondaryColor,
                          letterSpacing: 8,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                  const SizedBox(height: 10),
                  Text('YENİ\nKOLEKSİYON',
                      style: TextStyle(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: context.h1Size,
                          height: 0.9)),
                  const SizedBox(height: 15),
                  Container(
                      height: 4, width: 80, color: context.secondaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ⚡ YENİ ÖZELLİK: GLITCH STATS BAR ---
  Widget _buildGlitchStats(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.pagePadding.copyWith(top: 20, bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.primaryColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.primaryColor.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem("100%", "ORİJİNAL"),
            _statItem("24h", "KARGO"),
            _statItem("LÜKS", "TASARIM"),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String top, String bottom) {
    return Column(
      children: [
        Text(top,
            style:
                const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        Text(bottom,
            style: TextStyle(
                fontSize: 10, color: Colors.grey.shade500, letterSpacing: 2)),
      ],
    );
  }

  // --- 🧩 MOZAİK KATEGORİ BAR ---
  Widget _buildMosaicCategoryBar(BuildContext context) {
    final cats = [
      'Tümü',
      'Koltuk',
      'Masa',
      'Dekor',
      'Ofis',
      'Yatak',
      'Aydınlatma'
    ];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: context.pagePadding.left, top: 20),
          itemCount: cats.length,
          itemBuilder: (context, i) {
            final active = _selectedCategory == cats[i];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 15, bottom: 10),
              child: OutlinedButton(
                onPressed: () => setState(() => _selectedCategory = cats[i]),
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      active ? context.primaryColor : Colors.transparent,
                  side: BorderSide(
                      color: active
                          ? context.primaryColor
                          : context.primaryColor.withOpacity(0.2)),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0)), // Keskin mozaik hatlar
                ),
                child: Text(cats[i],
                    style: TextStyle(
                        color: active ? Colors.white : context.primaryColor,
                        fontWeight: FontWeight.bold)),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 📐 GRIFT MOZAİK GRID ---
  Widget _buildGriftGrid(BuildContext context, List<Product> products) {
    return SliverPadding(
      padding: context.pagePadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: context.responsive(mobile: 220.0, desktop: 360.0),
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          childAspectRatio:
              context.responsive(mobile: 0.65, tablet: 0.75, desktop: 0.82),
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => CustomProductCard(product: products[index]),
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildSliverAd(double h) => SliverToBoxAdapter(
        child: Padding(
            padding: context.pagePadding.copyWith(top: 20, bottom: 20),
            child: AdsenseBanner(height: h)),
      );
}

// --- 🖌️ GRAFFITI & GRIFT LINE PAINTER ---
class _GraffitiPainter extends CustomPainter {
  final Color lineColor;
  final Color shapeOn;

  _GraffitiPainter({required this.lineColor, required this.shapeOn});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final shapePaint = Paint()
      ..color = shapeOn
      ..style = PaintingStyle.fill;

    // Girift graffiti çizgileri
    for (var i = 0; i < size.width; i += 80) {
      canvas.drawLine(
          Offset(i.toDouble(), 0), Offset(i - 200, size.height), paint);
      if (i % 240 == 0) {
        canvas.drawRect(
            Rect.fromLTWH(i.toDouble(), i % size.height, 40, 40), shapePaint);
      }
    }

    // Rastgele graffiti daireleri
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.4), 100, paint);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.7), 150, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- 📐 HEADER PATTERN PAINTER ---
class _HeaderPatternPainter extends CustomPainter {
  final Color color;

  _HeaderPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < size.width; i += 30) {
      canvas.drawLine(
          Offset(i.toDouble(), 0), Offset(i + 50, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
