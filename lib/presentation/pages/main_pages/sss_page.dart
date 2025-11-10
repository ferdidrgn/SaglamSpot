import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
    'Sipariş',
    'Ödeme',
    'Teslimat',
    'İade',
  ];

  final List<Map<String, String>> _faqs = [
    {
      'category': 'Genel',
      'question': 'MobilyaEvim güvenilir mi?',
      'answer':
          '15 yıldır sektörde hizmet veren, binlerce mutlu müşterisi olan köklü bir firmayız. Tüm ürünlerimiz için garanti sağlıyoruz ve müşteri memnuniyeti bizim için her şeyden önemlidir.',
    },
    {
      'category': 'Genel',
      'question': 'İkinci el ürünlerin durumu nasıl kontrol ediliyor?',
      'answer':
          'Tüm ikinci el ürünlerimiz uzman ekibimiz tarafından detaylı olarak incelenir, temizlenir ve gerekli bakımları yapılır. Ürünlerin fotoğrafları gerçek durumu yansıtır ve detaylı açıklamalar eklenir.',
    },
    {
      'category': 'Sipariş',
      'question': 'Nasıl sipariş verebilirim?',
      'answer':
          'Web sitemizden beğendiğiniz ürünü seçin, sepete ekleyin ve ödeme adımlarını tamamlayın. Alternatif olarak telefon ile de sipariş verebilirsiniz: +90 (212) 555 0123',
    },
    {
      'category': 'Sipariş',
      'question': 'Siparişimi iptal edebilir miyim?',
      'answer':
          'Ürün henüz kargoya verilmemişse siparişinizi ücretsiz iptal edebilirsiniz. Müşteri hizmetlerimizle iletişime geçmeniz yeterli. Kargo sürecindeki siparişler için iade prosedürü uygulanır.',
    },
    {
      'category': 'Sipariş',
      'question': 'Stoğu olmayan ürünleri sipariş edebilir miyim?',
      'answer':
          'Stoğu tükenen ürünler için "Beni Haberdar Et" butonunu kullanabilirsiniz. Ürün tekrar stoğa girdiğinde e-posta ile bilgilendirilirsiniz.',
    },
    {
      'category': 'Ödeme',
      'question': 'Hangi ödeme yöntemlerini kabul ediyorsunuz?',
      'answer':
          'Kredi kartı (tek çekim ve taksit), banka kartı, havale/EFT ve kapıda ödeme seçeneklerimiz mevcuttur. Taksit seçenekleri için bankanızla görüşebilirsiniz.',
    },
    {
      'category': 'Ödeme',
      'question': 'Taksit imkanı var mı?',
      'answer':
          'Evet! Tüm kredi kartlarına 9 taksit imkanı sunuyoruz. Bazı kampanyalı dönemlerde taksit sayısı artabilmektedir.',
    },
    {
      'category': 'Ödeme',
      'question': 'Faturamı nasıl alabilirim?',
      'answer':
          'Faturanız sipariş tamamlandığında e-posta adresinize otomatik gönderilir. Ayrıca hesabınızdan "Siparişlerim" bölümünden faturanızı indirebilirsiniz.',
    },
    {
      'category': 'Teslimat',
      'question': 'Kargo ücreti ne kadar?',
      'answer':
          '500 TL ve üzeri alışverişlerde kargo ücretsizdir. 500 TL altı siparişlerde bölgeye göre 50-100 TL kargo ücreti uygulanır.',
    },
    {
      'category': 'Teslimat',
      'question': 'Teslimat süresi ne kadar?',
      'answer':
          'Stokta bulunan ürünler 2-5 iş günü içinde adresinize teslim edilir. Büyük boy mobilyalar için montaj hizmeti talep ederseniz, uygun bir tarih planlanır ve size bildirilir.',
    },
    {
      'category': 'Teslimat',
      'question': 'Montaj hizmeti veriyor musunuz?',
      'answer':
          'Evet, tüm büyük mobilyalar için profesyonel montaj hizmeti sunuyoruz. Montaj ücreti ürüne göre değişiklik gösterir ve sipariş sırasında size bildirilir.',
    },
    {
      'category': 'Teslimat',
      'question': 'Kargom nerede, nasıl takip edebilirim?',
      'answer':
          'Siparişiniz kargoya verildiğinde size SMS ve e-posta ile kargo takip numarası gönderilir. Bu numara ile kargo firmasının web sitesinden takip yapabilirsiniz.',
    },
    {
      'category': 'İade',
      'question': 'İade şartları nelerdir?',
      'answer':
          'Ürünü teslim aldıktan sonra 14 gün içinde iade edebilirsiniz. Ürün kullanılmamış, orijinal ambalajında ve etiketleri sağlam olmalıdır. İkinci el ürünlerde değişiklik yapılmamış olması gerekir.',
    },
    {
      'category': 'İade',
      'question': 'İade kargo ücreti kim tarafından karşılanır?',
      'answer':
          'Ürün kusurlu veya hatalı ise iade kargo ücreti tarafımızca karşılanır. Cayma hakkı kullanımında iade kargo ücreti müşteriye aittir.',
    },
    {
      'category': 'İade',
      'question': 'İade sürecim ne kadar sürer?',
      'answer':
          'Ürün tarafımıza ulaştıktan sonra 2-3 iş günü içinde kontrol edilir. Onay durumunda ödeme iadesi 5-7 iş günü içinde hesabınıza yansır.',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_selectedCategory == 'Tümü') {
      return _faqs;
    }
    return _faqs.where((faq) => faq['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero Section
        _buildHeroSection(),

        // Category Filters
        _buildCategoryFilters(),

        // Quick Help
        _buildQuickHelp(),

        // FAQ List
        _buildFAQList(),

        // Contact CTA
        _buildContactCTA(),

        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
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
                size: 300,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      'YARDIM MERKEZİ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sıkça Sorulan\nSorular',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Merak ettiğiniz her şeyin cevabı burada',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            final count = category == 'Tümü'
                ? _faqs.length
                : _faqs.where((f) => f['category'] == category).length;

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
              onSelected: (selected) {
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
                fontSize: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildQuickHelp() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildQuickHelpCard(
                Icons.phone_outlined,
                'Telefon Desteği',
                '+90 (212) 555 0123',
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickHelpCard(
                Icons.email_outlined,
                'E-posta Desteği',
                'destek@mobilyaevim.com',
                AppColors.info,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickHelpCard(
                Icons.chat_bubble_outline,
                'Canlı Sohbet',
                'Hemen Başlat',
                AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
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
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList() {
    final filteredFaqs = _filteredFaqs;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final faq = filteredFaqs[index];
            final isExpanded = _expandedIndex == index;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
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
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
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
                                fontSize: 12,
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
                                fontSize: 18,
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
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 1),
                          const SizedBox(height: 20),
                          Text(
                            faq['answer']!,
                            style: const TextStyle(
                              fontSize: 16,
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

  Widget _buildContactCTA() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.support_agent_outlined,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sorunuz Yanıt Bulamadı mı?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Müşteri hizmetleri ekibimiz size yardımcı olmak için hazır',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 12),
                      Text(
                        'Bizi Arayın',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.email_outlined),
                      SizedBox(width: 12),
                      Text(
                        'E-posta Gönderin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Genel':
        return AppColors.primary;
      case 'Sipariş':
        return AppColors.info;
      case 'Ödeme':
        return AppColors.success;
      case 'Teslimat':
        return AppColors.warning;
      case 'İade':
        return AppColors.secondary;
      default:
        return AppColors.textSecondary;
    }
  }
}
