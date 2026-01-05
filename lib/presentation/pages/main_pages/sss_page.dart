import 'package:flutter/material.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/seo_helper.dart';
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
    'İkinci El Alım Süreci'
  ];

  final List<Map<String, String>> _faqs = [
    // GENEL SORULAR
    {
      'category': 'Genel',
      'question':
          'Ustanın çalışma hayatı ve tecrübesi hakkında bilgi verebilir misiniz?',
      'answer': "Ustamız, 1995 yılından beri bu sektörde aktif olarak çalışmaktadır. "
          "Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir. "
          "Çalışma hayatı boyunca, teslimatlar için sürücülük, taşıma, montaj, müşteri karşılama gibi birçok iş pozisyonunda görev alarak çok yönlü bir deneyim kazanmıştır. "
          "Özellikle 2010 yılına kadar İstikbal'de çalışmış ve bu süreçte ürünlerin özellikleri, parçaları ve püf noktaları hakkında derinlemesine bilgi sahibi olmuştur. "
          "2010'dan sonra, yakın civardaki Işık Çeyiz'de çalışarak sektördeki yetkinliğini artırmıştır. "
          "2012 yılında ise kendi esnaf dükkanını açma kararı almış ve bu süreçte kaliteli hizmet anlayışını ön planda tutarak, sektördeki deneyimlerini müşterilerine en iyi şekilde aktarmayı hedeflemiştir.",
    },
    {
      'category': 'Genel',
      'question': 'Sağlam Spot güvenilir mi?',
      'answer':
          '2012 yılından beri İçerenköy\'de, komşularımıza hizmet veriyoruz. Sayısızca evlere konuk olduk ve hâlâ konuk olmaya devam ediyoruz.',
    },
    {
      'category': 'Genel',
      'question': 'Ürünleri incelemek için mağazanıza gelebilir miyim?',
      'answer':
          'Elbette! Hatta biz de özellikle bunu tavsiye ediyoruz. Çayımızı içerken ürünleri canlı canlı görmeniz, dokunmanız ve içinize sinmesi en sağlıklısı. İçerenköy Mahallesi\'ndeki dükkanımıza her zaman bekleriz.',
    },

    // ÜRÜN & HİZMET SORULARI
    {
      'category': 'Ürün & Hizmet',
      'question': 'İkinci el ürünlerin durumu nasıl kontrol ediliyor?',
      'answer':
          "Bizim için ikinci el, 'ikinci kalite' demek değildir. Her ürün ustamızın titiz kontrolünden geçer; temizliği, bakımı ve gerekli onarımları eksiksiz yapılır. Fotoğraflarda ne görüyorsanız o, ama biz yine de 'gelin, bir de siz görün' deriz. Gözünüzle görmeniz her zaman en iyisidir.",
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Mobilyaların malzeme kalitesi nedir?',
      'answer':
          'Şeffaflığı önemsiyoruz. Her ürünün kendine ait bir hikayesi ve malzemesi var. Bu yüzden tüm detayları, malzeme kalitesini ve özelliklerini ürün açıklama bölümlerine net bir şekilde yazıyoruz. Aklınıza takılan bir şey olursa sormaktan çekinmeyin.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Ürün fiyatları nasıl belirleniyor?',
      'answer':
          'Fiyatlarımızı belirlerken hem ürünün kalitesine hem de piyasa koşullarına adil bir şekilde bakıyoruz. Amacımız, bütçenizi zorlamadan, kaliteli ve uzun ömürlü ürünlere ulaşmanızı sağlamaktır. Hakkı neyse, o.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Ürünlerinizde renk seçenekleri var mı?',
      'answer':
          'Ürünlerimiz genellikle anlık ve tek parçalar olduğu için, mevcut renkleri neyse o şekilde sunuyoruz. Maalesef farklı renk seçenekleri yapamıyoruz. Beğendiğiniz ürünün rengi, gördüğünüz renktir.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Özel sipariş alıyor musunuz?',
      'answer':
          'Keşke yapabilsek! Ancak biz daha çok mevcut, özenle seçilmiş ürünlerimize odaklanıyoruz. Özel üretim veya tasarım siparişi şu an için maalesef alamıyoruz. Hazırdaki ürünlerimizi incelemenizi öneririz.',
    },
    {
      'category': 'Ürün & Hizmet',
      'question': 'Ürün açıklamalarında nelere dikkat etmeliyim?',
      'answer':
          'En önemli tavsiyemiz: Mezura! Lütfen ürün açıklamasındaki ölçüleri, evinize koyacağınız yerle dikkatlice karşılaştırın. \'Acaba sığar mı?\' sorusunu en başta çözmek, sonradan yaşanacak sıkıntıları önler. Ayrıca ölçü Alırken Koridoru Unutmayın: Sadece mobilyayı koyacağınız yeri değil, o mobilyanın kapıdan, koridordan ve merdivenden nasıl geçeceğini de ölçün. Malzeme ve durum bilgilerini de mutlaka okuyun.',
    },

    // TESLİMAT & MONTAJ SORULARI
    {
      'category': 'Teslimat & Montaj',
      'question':
          'Asansör olmayan binalara veya yüksek katlara teslimat yapıyor musunuz?',
      'answer':
          "Bu, bizim için en hassas ve önemli konulardan biri. Biz, işini bizzat yapan küçük bir esnafız. Ustamız, yılların tecrübesiyle birlikte artık genç olmadığı için sağlığını da düşünmek zorundayız. Anlayışınıza sığınarak, asansör olmayan binalarda yüksek katlara (örneğin 2. kat ve üzeri) **eşya çıkarma ve indirme hizmeti kesinlikle veremiyoruz**. Lütfen siparişinizi vermeden önce bu konuyu netleştirelim, size mahcup olmak istemeyiz."
    },
    {
      'category': 'Teslimat & Montaj',
      'question': 'Taşıma hizmeti sağlıyor musunuz?',
      'answer':
          'Elbette, komşularımıza yardımcı oluyoruz. İçerenköy başta olmak üzere Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü ve Bostancı Sanayi gibi yakın çevremize ücretsiz nakliye hizmetimiz var. (Bostancı ve Kozyatağı\'nın bazı bölgeleri hariç, ve yaşlılık açısından yüksek katlara asansörsüz taşıyamıyoruz, onu ayrıca konuşuruz).',
    },
    {
      'category': 'Teslimat & Montaj',
      'question': 'Teslimat süresi ne kadar?',
      'answer':
          'Siparişi verdiğiniz an sizinle iletişime geçeriz. \'Ne zaman müsaitsiniz?\' diye sorarız. Hem size hem bize uyan en yakın vakit için sözleşiriz. Genellikle 1-3 gün içinde, anlaştığımız saatte teslimatı ve montajı tamamlamış oluruz.',
    },
    {
      'category': 'Teslimat & Montaj',
      'question': 'Montaj hizmeti veriyor musunuz?',
      'answer':
          'Tabii ki. Mobilyayı alıp kapıya bırakmak bizim tarzımız değil. Büyük ürünlerin hepsini ustamız bizzat kurar ve bu hizmet için ekstra bir ücret talep etmeyiz. Siz sadece yerini gösterin, gerisi bizde.',
    },
    {
      'category': 'Teslimat & Montaj',
      'question': 'Mobilya siparişi ne kadar sürede teslim edilir?',
      'answer':
          'Ürün hazırsa, sizinle ortak belirlediğimiz bir zamanda en kısa sürede kapınızdayız. Montajı da dert etmeyin; getirdiğimiz gibi kurar, öyle teslim ederiz. Genellikle aynı gün içinde her şey biter.',
    },

    // ÖDEME & SİPARİŞ SORULARI
    {
      'category': 'Ödeme & Sipariş',
      'question': 'Veresiye sipariş verebilir miyim?',
      'answer':
          'Bu konuda anlayışınızı rica ediyoruz. Bir esnaf olarak ayakta kalabilmemiz için \'veresiye\' veya \'sonra ödeme\' gibi yöntemlerle maalesef çalışamıyoruz. Anlaştığımız ücreti, ürünü teslim ederken peşin olarak almamız gerekiyor. Size mahcup olmamak için bu kuralımızı baştan belirtmeyi tercih ediyoruz.',
    },
    {
      'category': 'Ödeme & Sipariş',
      'question': 'Nasıl sipariş verebilirim?',
      'answer':
          'En sağlıklı yöntem, her zaman yüz yüze olandır. Siteden beğendiğiniz ürünü not edin, sonra dükkanımıza gelin. Ürünü canlı görün, aklınızdaki soruları sorun, içinize sinerse siparişinizi orada tamamlayalım. Böylece hiçbir şüphe kalmaz.',
    },

    // İADE & GARANTİ SORULARI
    {
      'category': 'İade & Garanti',
      'question': 'Ürün iade politikası nedir?',
      'answer':
          'İkinci el ürünlerin doğası gereği ve esnaf usulü çalıştığımız için maalesef iade kabul edemiyoruz. Bu yüzden \'gelin, görün, çayımızı için\' diye ısrar ediyoruz. Almadan önce ürünü detaylıca incelemeniz, ölçüp biçmeniz en doğrusu. Emin olmadan alışverişi tamamlamayalım.',
    },
    {
      'category': 'İade & Garanti',
      'question': 'Ürünlerin garanti süresi var mı?',
      'answer':
          'Ürünlerimiz ikinci el olduğu için, bir markanın sunduğu gibi resmi bir garanti süremiz maalesef yok. Ancak biz \'sattık, bitti\' diyenlerden değiliz. Teslimat ve montaj sırasında her şeyin düzgün çalıştığından emin oluruz.',
    },

// === YENİ KATEGORİ: İKİNCİ EL ALIM SÜRECİ ===
    {
      'category': 'İkinci El Alım Süreci',
      'question':
          'Evimdeki eşyaları satmak istiyorum, ikinci el alımı yapıyor musunuz?',
      'answer': 'Evet, dükkanımızda sergileyebileceğimize inandığımız, temiz ve yeniden satılabilir durumdaki seçili ürünleri alıyoruz. Ancak, dükkanımızın yeri gerçekten çok küçük olduğu için bu konuda maalesef çok seçici davranmak zorundayız. \n\n'
          'Bu konuda baştan dürüst olmayı severiz: Bizden alacağınız teklif, muhtemelen Letgo gibi platformlarda kendinizin satabileceğiniz rakamdan biraz daha düşük olabilir. Bunun sebebi şudur: Biz esnaf olarak o eşyayı almak için **benzin yakıyor, taşıma için emek harcıyor** ve en önemlisi, onu satmak için **dükkanımızda sergileyip tüm müşteri süreciyle (pazarlık, sorular vs.) biz ilgileniyoruz.** \n\n'
          'Siz o platformlarda satarken bu süreçlerin tamamını kendiniz üstlenirsiniz. Biz ise sizden bu zahmeti de devralmış oluyoruz. Teklifimizi bu hizmeti de içerecek şekilde veriyoruz. Anlayışınız için teşekkür ederiz.',
    },
    {
      'category': 'İkinci El Alım Süreci',
      'question':
          'Komple takım mobilyaları (Yatak odası, salon takımı vb.) alıyor musunuz?',
      'answer':
          'Dükkanımızın küçük olmasından dolayı, maalesef komple yatak odası, koltuk takımı gibi **büyük setleri alamıyoruz**. Yerimiz çok kısıtlı. Biz daha çok tek parça, satışı daha kolay olan (konsol, dolap, masa, sandalye gibi) ürünlere odaklanıyoruz.'
    },
    {
      'category': 'İkinci El Alım Süreci',
      'question':
          'Eşyalarım yüksek katta ve binada asansör yok. Alım yapar mısınız?',
      'answer':
          'Tıpkı teslimat konusunda olduğu gibi, bu bizim için en net kuralımız. Ustamızın sağlık durumu nedeniyle, asansör olmayan binalarda **yüksek katlardan eşya indirme işlemi kesinlikle yapamıyoruz**. Eşyalarınız zemin/giriş kata yakın ise veya binada yük asansörü varsa ancak o zaman değerlendirebiliriz.'
    },
    {
      'category': 'İkinci El Alım Süreci',
      'question': 'Her zaman eşya alımı yapıyor musunuz?',
      'answer':
          'Bu tamamen dükkanımızdaki boşluğa bağlı. Dükkanımız küçük olduğu için, \'sat-al\' dengesiyle çalışıyoruz. Bazen bir ürünü çok beğensek de yerimiz olmadığı için alamayabiliyoruz. En sağlıklısı, bize satmak istediğiniz ürünün fotoğraflarını göndermenizdir. Size dürüstçe \'şu an yerimiz var\' veya \'maalesef bu ara doluyuz\' diye bilgi veririz.'
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_selectedCategory == 'Tümü') return _faqs;
    return _faqs
        .where((final faq) => faq['category'] == _selectedCategory)
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setSeo(
      title: 'Sıkça Sorulan Sorular | Sağlam Spot',
      description:
      'Sağlam Spot SSS sayfasında teslimat, montaj, ödeme, iade, ikinci el alım süreci ve tüm merak edilen soruların cevaplarını bulun.',
    );
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
        //_buildAddProductButton(context),

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
              'Bize Ulaşabilirsiniz',
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

  Future<void> _launchPhone() async {
    const phoneNumber = 'tel:+905539201996';
    if (await canLaunchUrl(Uri.parse(phoneNumber)))
      await launchUrl(Uri.parse(phoneNumber));
  }

  Future<void> _launchMaps() async {
    const mapsUrl =
        'https://www.google.com/maps/place/Sa%C4%9Flam+Spot/@40.9699248,29.1146853,21z/data=!4m6!3m5!1s0x14cac64216b4ccb7:0x49124944b40496f6!8m2!3d40.9699196!4d29.1148379!16s%2Fg%2F11dxc20095?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D';
    if (await canLaunchUrl(Uri.parse(mapsUrl)))
      await launchUrl(Uri.parse(mapsUrl));
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
      case 'İkinci El Alım Süreci':
        return AppColors.textPrimary;
      default:
        return AppColors.textSecondary;
    }
  }
}
