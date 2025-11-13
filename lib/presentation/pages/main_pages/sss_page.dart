import 'package:flutter/material.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../add_product_page.dart';

class SSSPage extends StatefulWidget {
  const SSSPage({super.key});

  @override
  State<SSSPage> createState() => _SSSPageState();
}

class _SSSPageState extends State<SSSPage> {
  int? _expandedIndex;
  String _selectedCategory = 'Tümü';

  final List<String> _categories = [
    'Tümü',
    'Genel',
    'Ürün & Hizmet',
    'Teslimat & Montaj',
    'Ödeme & Sipariş',
    'İade & Garanti',
  ];

  final List<Map<String, String>> _faqs = [
    // GENEL SORULAR
    {
      'category': 'Genel',
      'question':
          'Ustanın çalışma hayatı ve tecrübesi hakkında bilgi verebilir misiniz?',
      'answer': "Ustamız, 1995 yılından beri bu sektörde aktif olarak çalışmaktadır. "
          "Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir. "
          "Çalışma hayatı boyunca, sürücülük, taşıma, montaj, müşteri karşılama gibi birçok iş pozisyonunda görev alarak çok yönlü bir deneyim kazanmıştır. "
          "Özellikle 2010 yılına kadar İstikbal'de çalışmış ve bu süreçte ürünlerin özellikleri, parçaları ve püf noktaları hakkında derinlemesine bilgi sahibi olmuştur. "
          "2010'dan sonra, yakın civardaki Işık Çeyiz'de çalışarak sektördeki yetkinliğini artırmıştır. "
          "2012 yılında ise kendi esnaf dükkanını açma kararı almış ve bu süreçte kaliteli hizmet anlayışını ön planda tutarak, sektördeki deneyimlerini müşterilerine en iyi şekilde aktarmayı hedeflemiştir.",
    },
    {
      'category': 'Genel',
      'question': 'Sağlam Spot güvenilir mi?',
      'answer':
          '2012\'den beri sektörde hizmet veren, binlerce mutlu müşterisi olan köklü bir esnafız.',
    },
    {
      'category': 'Genel',
      'question': 'Ürünleri incelemek için mağazanıza gelebilir miyim?',
      'answer':
          'Evet, ürünleri görmek için mağazamıza gelebilirsiniz. İçerenköy Mahallesi\'ndeki mağazamızı ziyaret edebilirsiniz.',
    },

    // ÜRÜN & HİZMET SORULARI
    {
      'category': 'Ürün & Hizmet',
      'question': 'İkinci el ürünlerin durumu nasıl kontrol ediliyor?',
      'answer':
          'Tüm ikinci el ürünlerimiz ustamız tarafından detaylı olarak incelenir, temizlenir ve gerekli bakımları yapılır. Ürünlerin fotoğrafları gerçek durumu yansıtır. Ama yine de mağazamıza incelemenizi öneriyoruz.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Mobilyaların malzeme kalitesi nedir?',
      'answer':
          'Ürünlerimizin açıklamalarında detaylı bilgiler yer almaktadır. Her ürünün malzeme bilgisi açıklamalar kısmında belirtilmiştir.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Ürün fiyatları nasıl belirleniyor?',
      'answer':
          'Benzer ürünlerin piyasa fiyatlarına göre rekabetçi bir fiyat belirliyoruz. Kalite-fiyat dengesini gözetiyoruz.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Ürünlerinizde renk seçenekleri var mı?',
      'answer':
          'Hayır, renk seçeneği sunamayız. Mevcut ürünlerimizin renkleri sabittir.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Özel sipariş alıyor musunuz?',
      'answer':
          'Hayır, özel tasarım siparişler almıyoruz. Mevcut ürün yelpazemizden seçim yapabilirsiniz.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Ürün açıklamalarında nelere dikkat etmeliyim?',
      'answer':
          'Ürünün kapladığı alan bilgilerini evinizin ölçüleri ile karşılaştırın. Malzeme bilgisi ve ürün durumunu dikkatlice okuyun.',
    },

    // TESLİMAT & MONTAJ SORULARI
    {
      'category': 'Teslimat & Montaj',
      'question': 'Taşıma hizmeti sağlıyor musunuz?',
      'answer':
          'Evet, İçerenköy Mahallesi ve yakın çevrelerine (Bostancı ve Kozyatağı hariç) ücretsiz taşıma hizmeti sunuyoruz. Genellikle: İçerenköy, Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü, Bostancı Sanayi kısımları',
    },
    {
      'category': 'Teslimat & Montaj',
      'question': 'Teslimat süresi ne kadar?',
      'answer':
          'Stokta bulunan ürünler en kısa sürede adresinize teslim edilir. Montaj hizmeti genellikle ürünler getirldiği an ile  birlikte aynı gün içerisinde yapılmaktadır',
    },
    {
      'category': 'Teslimat & Montaj',
      'question': 'Montaj hizmeti veriyor musunuz?',
      'answer':
          'Evet, tüm büyük mobilyalar için profesyonel montaj hizmeti sunuyoruz. Montaj ücretsizdir.',
    },
    {
      'category': 'Teslimat & Montaj',
      'question': 'Mobilya siparişi ne kadar sürede teslim edilir?',
      'answer':
          'Siparişiniz, ödemeden sonra sözlü iletişmler ile her iki tarafa uygun vakit ve saatte teslim  ve montaj yapılır. Genellikle 1-3 iş günü içinde teslimat yapıyoruz.',
    },

    // ÖDEME & SİPARİŞ SORULARI
    {
      'category': 'Ödeme & Sipariş',
      'question': 'Veresiye sipraiş verebilir miyim?',
      'answer':
          'Maalesef. Lütfen veresiye teklif etmeyiniz. Ayrıca lütfen eşyaları kapınıza getirdiğimizde anlaştığımız ücreti daha sonra vereceğinizi söylemeyiniz.',
    },
    {
      'category': 'Ödeme & Sipariş',
      'question': 'Nasıl sipariş verebilirim?',
      'answer':
          'Web sitemizden beğendiğiniz ürünü mağazamıza gelip ürünü inceleyerek sipariş vermenizi öneriyoruz. En sağlıklı adımları tercih ediyoruz.',
    },

    // İADE & GARANTİ SORULARI
    {
      'category': 'İade & Garanti',
      'question': 'Ürün iade politikası nedir?',
      'answer':
          'Ürün iade politikamız bulunmamaktadır. Satın almadan önce ürünleri detaylı incelemenizi öneririz.',
    },
    {
      'category': 'İade & Garanti',
      'question': 'Ürünlerin garanti süresi var mı?',
      'answer':
          'Hayır, garantimiz yoktur.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_selectedCategory == 'Tümü') return _faqs;
    return _faqs
        .where((final faq) => faq['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero Section
        _buildHeroSection(context),

        // Category Filters
        _buildCategoryFilters(context),

        // Quick Help
        _buildQuickHelp(context),

        // FAQ List
        _buildFAQList(context),

        // Contact CTA
        _buildContactCTA(context),

        // Ürün Ekle Butonu
        _buildAddProductButton(context),

        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }

  Widget _buildHeroSection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(24),
        ),
        height: context.responsive(mobile: 250, desktop: 350),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.info, Color(0xFF0EA5E9)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              bottom: -50,
              child: Icon(
                Icons.help_outline_rounded,
                size: context.responsive(mobile: 200, desktop: 300),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: context.responsive(
                mobile: const EdgeInsets.all(24),
                desktop: const EdgeInsets.all(60),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24)),
                    child: Text('YARDIM MERKEZİ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                context.responsive(mobile: 12, desktop: 14),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5)),
                  ),
                  const SizedBox(height: 24),
                  Text('Sıkça Sorulan\nSorular',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: context.responsive(mobile: 32, desktop: 52),
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          letterSpacing: -1)),
                  const SizedBox(height: 20),
                  Text('Merak ettiğiniz her şeyin cevabı burada',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: context.responsive(mobile: 16, desktop: 20),
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(24),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 16.0, desktop: 24.0),
          ),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.map((final category) {
            final isSelected = _selectedCategory == category;
            final count = category == 'Tümü'
                ? _faqs.length
                : _faqs.where((final f) => f['category'] == category).length;

            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(category),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textTertiary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (final selected) {
                setState(() {
                  _selectedCategory = category;
                  _expandedIndex = null;
                });
              },
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary.withOpacity(0.15),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: context.responsive(mobile: 14, desktop: 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              padding: context.responsive(
                mobile:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                desktop:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildQuickHelp(final BuildContext context) {
    final children = [
      Expanded(
        child: _buildQuickHelpCard(
          context,
          Icons.phone_outlined,
          'Telefon Desteği',
          '+90 5392019961',
          AppColors.success,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 16),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildQuickHelpCard(
          context,
          Icons.access_time_outlined,
          'Çalışma Saatleri',
          '09:00 - 22:00',
          AppColors.info,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 16),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildQuickHelpCard(
          context,
          Icons.location_on_outlined,
          'Mağaza Adresi',
          'İçerenköy Mahallesi Buket Sok. No:6',
          AppColors.secondary,
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: context.responsive<Widget>(
          mobile: Column(children: children),
          desktop: Row(children: children),
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard(
    final BuildContext context,
    final IconData icon,
    final String title,
    final String subtitle,
    final Color color,
  ) {
    return Container(
      padding: context.responsive(
        mobile: const EdgeInsets.all(16),
        desktop: const EdgeInsets.all(24),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          context.responsive(mobile: 16.0, desktop: 20.0),
        ),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: context.responsive(mobile: 28, desktop: 32),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: context.responsive(mobile: 14, desktop: 16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.responsive(mobile: 14, desktop: 14),
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList(final BuildContext context) {
    final filteredFaqs = _filteredFaqs;

    return SliverPadding(
      padding: context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            final faq = filteredFaqs[index];
            final isExpanded = _expandedIndex == index;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(
                  context.responsive(mobile: 16.0, desktop: 20.0),
                ),
                border: Border.all(
                  color: isExpanded ? AppColors.primary : AppColors.border,
                  width: isExpanded ? 2 : 1,
                ),
                boxShadow: isExpanded
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? null : index;
                      });
                    },
                    borderRadius: BorderRadius.circular(
                      context.responsive(mobile: 16.0, desktop: 20.0),
                    ),
                    child: Padding(
                      padding: context.responsive(
                        mobile: const EdgeInsets.all(16),
                        desktop: const EdgeInsets.all(24),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(faq['category']!)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              faq['category']!,
                              style: TextStyle(
                                fontSize: context.captionSize,
                                fontWeight: FontWeight.w600,
                                color: _getCategoryColor(faq['category']!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              faq['question']!,
                              style: TextStyle(
                                fontSize: context.titleSize,
                                fontWeight: FontWeight.w600,
                                color: isExpanded
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            color: isExpanded
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Container(
                      padding: context.responsive(
                        mobile: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        desktop: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 1),
                          const SizedBox(height: 20),
                          Text(
                            faq['answer']!,
                            style: TextStyle(
                              fontSize: context.bodySize,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
          childCount: filteredFaqs.length,
        ),
      ),
    );
  }

  Widget _buildContactCTA(final BuildContext context) {
    final buttonPadding = context.responsive(
      mobile: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      desktop: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    );
    final buttonTextStyle = TextStyle(
      fontSize: context.responsive(mobile: 16, desktop: 18),
      fontWeight: FontWeight.bold,
    );

    final buttons = [
      FilledButton(
        onPressed: () => _launchPhone(),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone),
            const SizedBox(width: 12),
            Text('Bizi Arayın', style: buttonTextStyle),
          ],
        ),
      ),
      SizedBox(
        height: context.responsive(mobile: 12, desktop: 16),
        width: context.responsive(mobile: 0, desktop: 16),
      ),
      OutlinedButton(
        onPressed: () => _launchMaps(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          padding: buttonPadding,
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined),
            const SizedBox(width: 12),
            Text(
              'Mağazaya Gel',
              style: buttonTextStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.support_agent_outlined,
              size: context.responsive(mobile: 48, desktop: 80),
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Sorunuz Yanıt Bulamadı mı?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsive(mobile: 24, desktop: 32),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Müşteri hizmetleri ekibimiz size yardımcı olmak için hazır',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            context.responsive<Widget>(
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buttons,
              ),
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttons,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProductButton(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: Center(
          child: FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) => const AddProductPage(),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: context.responsive(
                mobile:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                desktop:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_circle_outline),
                const SizedBox(width: 12),
                Text(
                  'Ürün Ekle Sayfasına Git',
                  style: TextStyle(
                    fontSize: context.responsive(mobile: 16, desktop: 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchPhone() async {
    const phoneNumber = 'tel:+905539201996';
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    }
  }

  Future<void> _launchMaps() async {
    const mapsUrl =
        'https://www.google.com/maps/place/Sa%C4%9Flam+Spot/@40.9699248,29.1146853,21z/data=!4m6!3m5!1s0x14cac64216b4ccb7:0x49124944b40496f6!8m2!3d40.9699196!4d29.1148379!16s%2Fg%2F11dxc20095?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D';
    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl));
    }
  }

  Color _getCategoryColor(final String category) {
    switch (category) {
      case 'Genel':
        return AppColors.primary;
      case 'Ürün & Hizmet':
        return AppColors.info;
      case 'Teslimat & Montaj':
        return AppColors.success;
      case 'Ödeme & Sipariş':
        return AppColors.warning;
      case 'İade & Garanti':
        return AppColors.secondary;
      default:
        return AppColors.textSecondary;
    }
  }
}
