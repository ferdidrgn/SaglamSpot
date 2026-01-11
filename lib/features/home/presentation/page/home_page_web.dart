import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/widgets/custom_search_bar.dart';
import 'package:saglamspot/features/products/presentation/providers/product_notifier.dart';
import 'package:saglamspot/features/products/presentation/providers/product_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/interactive_magic_spotlight.dart';
import '../../../products/domain/entites/product.dart';
import '../widgets/furniture_tips_section.dart';

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

  // Renk Paleti Tanımı
  final Color _bgMint = const Color(0xFFF1F7F6);
  final Color _darkMint = const Color(0xFF103E35);

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
    _timer = Timer.periodic(const Duration(seconds: 7), (final _) {
      if (_heroController.hasClients) {
        final int nextPage = (_currentHeroPage + 1) % 3;
        _heroController.animateToPage(nextPage,
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOutCubic);
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
    final state = ref.watch(productProvider) as ProductState;
    final allProducts = state.dataList ?? [];
    final availableProducts =
        allProducts.where((final p) => !p.isSold).take(10).toList();

    return Scaffold(
      backgroundColor: _bgMint,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1920),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildDiscoveryHeader(context),

              // 3. Search & Quick Features (İkonlarla samimi vurgu)
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.paddingHorizontal,
                  child: Column(
                    children: [
                      CustomSearchBar(
                        controller: _searchController,
                        onSearch: (final query) => context
                            .push('/search?q=${Uri.encodeComponent(query)}'),
                      ),
                      const SizedBox(height: 30),
                      _buildQuickFeatures(context),
                    ],
                  ),
                ),
              ),

              _buildDynamicCategorySection(context),

              // 6. Slider Kartları (Samimi & Resmi Metinler)
              _buildHeroSection(context),

              // 5. Inverse Showcase (Yenilenmiş Ferah Görsel)
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.sectionPadding,
                  child: const InsaneMagicShowcase(
                    imageUrl:
                        "https://images.unsplash.com/photo-1594026112284-02bb6f3352fe?q=80&w=1200",
                    // Ferah Salon
                    imageScale: 1.1,
                  ),
                ),
              ),

              _buildSectionHeader(context, "Yeni Koleksiyon",
                  "Evinizin ferahlığına şık bir dokunuş"),
              _buildProductGrid(context, availableProducts),
              _buildSeeAllButton(context),

              // 4. Odaya Göre Keşfet (Tam Ekran Yayılmış)
              _buildSectionHeader(context, "Yaşam Alanına Göre",
                  "Evinizin her köşesi için bir hikayemiz var"),
              _buildFullWidthRoomSection(context),

              // 2. Stats Section (Derinlikli & Yeni Kart Tasarımı)
              _buildEnhancedStats(context),

              const FurnitureTipsSection(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
              _buildModernFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // =================== 3. QUICK FEATURES (SAMİMİ VURGU) ===================
  Widget _buildQuickFeatures(final BuildContext context) {
    return Flex(
      direction: context.isMobile ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _featureItem(
            context, Icons.volunteer_activism_rounded, "Samimi Esnaflık"),
        _featureItem(context, Icons.verified_user_rounded, "Güvenli Teslimat"),
        _featureItem(context, Icons.sentiment_very_satisfied_rounded,
            "Güler Yüzlü Hizmet"),
        _featureItem(context, Icons.local_shipping_rounded, "Hızlı Nakliye"),
      ],
    );
  }

  Widget _featureItem(final BuildContext context, final IconData icon, final String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _darkMint, size: context.iconMedium),
          const SizedBox(width: 10),
          Text(text,
              style: TextStyle(
                  color: _darkMint, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  // =================== 6. SLIDER KARTLARI (METİNLER GÜNCELLENDİ) ===================
  SliverToBoxAdapter _buildHeroSection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 400,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: PageView(
          controller: _heroController,
          onPageChanged: (final i) => setState(() => _currentHeroPage = i),
          children: [
            _heroSlide(
                context,
                const Color(0xFFCDE2DE),
                "Sizin İçin Buradayız",
                "Samimiyetle Seçilen\nModern Parçalar",
                "Mağazamızın sıcaklığını evinize taşıyan, özenle seçilmiş mobilyalarla tanışın."),
            _heroSlide(
                context,
                const Color(0xFFD9E2D5),
                "Fırsat Köşesi",
                "Bütçe Dostu\nKaliteli Yaşam",
                "Sağlam Spot güvencesiyle, cebinizi yormadan yaşam alanınızı baştan aşağı yenileme fırsatı."),
            _heroSlide(
                context,
                const Color(0xFFE2DDD9),
                "Sınırlı Seri",
                "Eşsiz Dokunuşlar\nNet Çözümler",
                "Sektördeki 20 yıllık tecrübemizle, her zevke hitap eden en nadide parçaları beğeninize sunuyoruz."),
          ],
        ),
      ),
    );
  }

  Widget _heroSlide(final BuildContext context, final Color color, final String badge,
      final String title, final String sub) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(badge,
              style: TextStyle(
                  color: _darkMint,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2)),
          const SizedBox(height: 15),
          Text(title,
              style: TextStyle(
                  color: _darkMint,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  height: 1.1)),
          const SizedBox(height: 15),
          SizedBox(
              width: 600,
              child: Text(sub,
                  style: TextStyle(
                      color: _darkMint.withOpacity(0.7), fontSize: 18))),
        ],
      ),
    );
  }

  // =================== 4. ODAYA GÖRE KEŞFET (TAM EKRAN) ===================
  Widget _buildFullWidthRoomSection(final BuildContext context) {
    final rooms = [
      {
        "name": "Konforlu Salonlar",
        "img":
            "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?q=80&w=1200"
      },
      {
        "name": "Huzurlu Uykular",
        "img":
            "https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=1200"
      },
      {
        "name": "Keyifli Mutfaklar",
        "img":
            "https://images.unsplash.com/photo-1556911220-e15224bbaf40?q=80&w=1200"
      },
    ];
    return SliverToBoxAdapter(
      child: Container(
        height: 500,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Flex(
          direction: context.isMobile ? Axis.vertical : Axis.horizontal,
          children: rooms
              .map((final room) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: NetworkImage(room["img"]!),
                            fit: BoxFit.cover),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent
                              ]),
                        ),
                        padding: const EdgeInsets.all(40),
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

  // =================== 2. ENHANCED STATS (DERİNLİK HİSSİ) ===================
  Widget _buildEnhancedStats(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding,
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
                color: _darkMint.withOpacity(0.05),
                blurRadius: 50,
                offset: const Offset(0, 20)),
            BoxShadow(
                color: Colors.white,
                blurRadius: 10,
                offset: const Offset(0, -5)),
          ],
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          runSpacing: 40,
          children: [
            _statItem("2.5K+", "Mutlu Yuva", Icons.maps_home_work_rounded),
            _statItem("20+ Yıl", "Kadim Tecrübe", Icons.history_edu_rounded),
            _statItem("15K+", "Tam Zamanında", Icons.timer_rounded),
            _statItem("%100", "Müşteri Memnuniyeti", Icons.verified_rounded),
          ],
        ),
      ),
    );
  }

  Widget _statItem(final String val, final String label, final IconData icon) {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: _bgMint, shape: BoxShape.circle),
            child: Icon(icon, color: _darkMint, size: 40),
          ),
          const SizedBox(height: 15),
          Text(val,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w900, color: _darkMint)),
          Text(label,
              style: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // =================== 1. PROFESYONEL FOOTER ===================
  SliverToBoxAdapter _buildModernFooter(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(100, 80, 100, 40),
        color: _darkMint,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SAĞLAM SPOT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 20),
                        Text(
                            "İstanbul genelinde 20 yılı aşkın süredir ikinci el ve spot eşyada kaliteyi samimiyetle buluşturuyoruz. Ekspertiz hizmetimizden nakliye sürecine kadar her adımda aile sıcaklığını hissedeceksiniz.",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                height: 1.8,
                                fontSize: 15)),
                      ],
                    )),
                if (!context.isMobile) const Spacer(),
                if (!context.isMobile)
                  _footerColumn("Hızlı Keşif", [
                    "Yeni Koleksiyon",
                    "Popüler Ürünler",
                    "Mutfak Ürünleri",
                    "Mağaza Konumu"
                  ]),
                if (!context.isMobile) const SizedBox(width: 80),
                if (!context.isMobile)
                  _footerColumn("Kurumsal", [
                    "Hizmet Şartlarımız",
                    "Güvenlik Politikası",
                    "Nasıl Satın Alırım?",
                    "Bize Ulaşın"
                  ]),
              ],
            ),
            const SizedBox(height: 80),
            const Divider(color: Colors.white10),
            const SizedBox(height: 30),
            const Text(
                "© 2026 Sağlam Spot Ticaret - Samimiyet ve Güvenin İstanbul'daki Adresi.",
                style: TextStyle(
                    color: Colors.white24, fontSize: 13, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _footerColumn(final String title, final List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 25),
        ...links
            .map((final link) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(link,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 14)),
                ))
            .toList(),
      ],
    );
  }

  // --- Yardımcı Metodlar (Dokunulmadı Ama Renkleri Uyarlandı) ---
  SliverToBoxAdapter _buildDiscoveryHeader(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text("SAĞLAM SPOT",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: _darkMint)),
            const SizedBox(height: 10),
            Text("Evinizi Yeniden\nKeşfetme Zamanı.",
                style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -2,
                    color: _darkMint)),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDynamicCategorySection(final BuildContext context) {
    final cats = ["Tümü", "Masalar", "Sandalyeler", "Koltuklar", "Yataklar"];
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: context.paddingHorizontal.left),
          itemCount: cats.length,
          itemBuilder: (final context, final i) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(cats[i]),
              selected: _activeCategory == cats[i],
              onSelected: (final val) => setState(() => _activeCategory = cats[i]),
              selectedColor: _darkMint,
              labelStyle: TextStyle(
                  color: _activeCategory == cats[i] ? Colors.white : _darkMint),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding _buildProductGrid(
      final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: context.pagePadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          childAspectRatio: context.cardAspectRatio(),
        ),
        delegate: SliverChildBuilderDelegate(
            (final _, final i) => CustomProductCard(product: products[i]),
            childCount: products.length),
      ),
    );
  }

  Widget _buildSeeAllButton(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: OutlinedButton(
            onPressed: () => context.push('/search'),
            style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                side: BorderSide(color: _darkMint.withOpacity(0.2)),
                foregroundColor: _darkMint,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: const Text("TÜM KOLEKSİYONU GÖR"),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader(
      final BuildContext context, final String t, final String s) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t,
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: _darkMint)),
          Text(s, style: const TextStyle(color: Colors.black45)),
        ]),
      ),
    );
  }

  SliverToBoxAdapter _buildBusinessIntroduction(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding,
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Text(
            "Hızlı Nakliye ve Uzman Ekibimizle\nİstanbul'un Her Noktasındayız.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _darkMint,
                height: 1.4)),
      ),
    );
  }

  SliverToBoxAdapter _buildCTASection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding,
        padding: const EdgeInsets.all(80),
        decoration: BoxDecoration(
            color: _bgMint,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: _darkMint.withOpacity(0.1))),
        child: Row(
          children: [
            Expanded(
                child: Text("Hemen Mağazamıza Gelin,\nSıcak Bir Çayımızı İçin!",
                    style: TextStyle(
                        color: _darkMint,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1.1))),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: _darkMint,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(25)),
                child: const Text("YOL TARİFİ AL"))
          ],
        ),
      ),
    );
  }
}
