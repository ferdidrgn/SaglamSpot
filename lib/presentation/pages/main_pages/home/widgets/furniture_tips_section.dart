import 'package:flutter/material.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_section_header.dart';

class FurnitureTipsSection extends StatelessWidget {
  const FurnitureTipsSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final isMobile = context.isMobile;

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
          vertical: context.responsive(mobile: 12.0, desktop: 20.0),
        ),
        child: Column(
          children: [
            const SectionHeader(
              title: 'Mobilya Uzmanından Püf Noktaları',
              subtitle: 'Mobilyalarınızın ömrünü uzatacak profesyonel ipuçları',
            ),
            SizedBox(height: context.responsive(mobile: 20.0, desktop: 32.0)),

            // Grid yerine ListView.builder kullanıyoruz
            SizedBox(
              height: context.responsive(mobile: 2200.0, desktop: 1200.0),
              // Sabit yükseklik veriyoruz
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                // Scroll'u devre dışı bırak
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing:
                      context.responsive(mobile: 16.0, desktop: 24.0),
                  mainAxisSpacing:
                      context.responsive(mobile: 16.0, desktop: 24.0),
                  childAspectRatio:
                      context.responsive(mobile: 3.5, desktop: 4.0),
                ),
                itemCount: _furnitureTips.length,
                itemBuilder: (final context, final index) {
                  final tip = _furnitureTips[index];
                  return _buildTipCard(context, tip, index + 1);
                },
              ),
            ),

            SizedBox(height: context.responsive(mobile: 24.0, desktop: 40.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(
      final BuildContext context, final FurnitureTip tip, final int number) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
            context.responsive(mobile: 16.0, desktop: 20.0)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding:
            EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 20.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Numara ve ikon
            Container(
              width: context.responsive(mobile: 50.0, desktop: 60.0),
              height: context.responsive(mobile: 50.0, desktop: 60.0),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                    context.responsive(mobile: 12.0, desktop: 16.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(tip.icon,
                      color: AppColors.primary,
                      size: context.responsive(mobile: 20.0, desktop: 24.0)),
                  const SizedBox(height: 4),
                  Text(
                    '#$number',
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 12.0, desktop: 14.0),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: context.responsive(mobile: 12.0, desktop: 16.0)),

            // İçerik
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori etiketi
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          context.responsive(mobile: 8.0, desktop: 12.0),
                      vertical: context.responsive(mobile: 4.0, desktop: 6.0),
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(tip.category),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tip.category,
                      style: TextStyle(
                        fontSize:
                            context.responsive(mobile: 10.0, desktop: 12.0),
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(
                      height: context.responsive(mobile: 8.0, desktop: 12.0)),

                  // Başlık
                  Text(
                    tip.title,
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 16.0, desktop: 18.0),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(
                      height: context.responsive(mobile: 8.0, desktop: 12.0)),

                  // Açıklama - overflow'u önlemek için maxLines ve overflow ekliyoruz
                  Text(
                    tip.description,
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 4, // Maksimum satır sayısı
                    overflow: TextOverflow.ellipsis, // Taşarsa ... ile göster
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kategoriye göre renk belirleme
  Color _getCategoryColor(final String category) {
    switch (category) {
      case 'Yerleştirme':
        return AppColors.primary;
      case 'Koruma':
        return AppColors.secondary;
      case 'Temizlik':
        return AppColors.success;
      case 'Bakım':
        return AppColors.info;
      case 'Kullanım':
        return AppColors.warning;
      case 'Taşıma':
        return AppColors.accent;
      case 'Güvenlik':
        return Colors.red;
      case 'Onarım':
        return Colors.orange;
      case 'Düzen':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }
}

// FurnitureTip sınıfı
class FurnitureTip {
  final IconData icon;
  final String title;
  final String description;
  final String category;

  FurnitureTip({
    required this.icon,
    required this.title,
    required this.description,
    required this.category,
  });
}

// Güncellenmiş püf noktaları listesi (30 adet)
final List<FurnitureTip> _furnitureTips = [
  FurnitureTip(
    icon: Icons.balance,
    title: 'Terazi Kontrolü Yapın',
    description:
        'Mobilyanızın tüm ayaklarının zemine tam bastığından emin olun. Eğimli zeminlerde keçe veya karton ile denge sağlayın. Aksi takdirde mobilya esner, kapaklar sarkar.',
    category: 'Yerleştirme',
  ),
  FurnitureTip(
    icon: Icons.space_bar,
    title: 'Duvarla Mesafe Bırakın',
    description:
        'Mobilya ile duvar arasında 1-2 cm boşluk bırakarak hava sirkülasyonu sağlayın. Bu önlem rutubet ve küf oluşumunu engeller.',
    category: 'Yerleştirme',
  ),
  FurnitureTip(
    icon: Icons.heat_pump_outlined,
    title: 'Isı Kaynaklarından Uzak Tutun',
    description:
        'Mobilyaları kalorifer, soba gibi ısı kaynaklarından en az 30 cm uzakta konumlandırın. Yakın mesafe ahşabın çatlamasına neden olur.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.wb_sunny_outlined,
    title: 'Güneş Işığından Koruyun',
    description:
        'Direkt güneş ışığına maruz kalmayacak şekilde yerleştirin veya perdelerle filtreleyin. Güneş, renk solmasına ve ahşap deformasyonuna yol açar.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.water_drop_outlined,
    title: 'Nemli Temizlik Yapın',
    description:
        'Ahşap yüzeyleri hafif nemli bezle silip hemen kurulayın. Sırılsıklam bez kullanmak ahşabın şişmesine ve lekelerin kalıcı olmasına sebep olur.',
    category: 'Temizlik',
  ),
  FurnitureTip(
    icon: Icons.cleaning_services,
    title: 'Lekelere Anında Müdahale',
    description:
        'Kumaşa bir şey döküldüğünde hemen temizleyin. Bekleyen lekeler kumaşın liflerine işleyerek çıkmaz hale gelir.',
    category: 'Temizlik',
  ),
  FurnitureTip(
    icon: Icons.touch_app,
    title: 'Tampon Yöntemiyle Temizleyin',
    description:
        'Lekeleri ovalamak yerine tampon yaparak (hafifçe bastırıp çekerek) temizleyin. Ovalamak lekeyi daha geniş alana yayar.',
    category: 'Temizlik',
  ),
  FurnitureTip(
    icon: Icons.emoji_objects_outlined,
    title: 'Bardak Altlığı Kullanın',
    description:
        'Sıcak ve soğuk içecekler için mutlaka bardak altlığı kullanın. Doğrudan temas ahşap yüzeyde kalıcı beyaz halkalar bırakır.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.chair_outlined,
    title: 'Kolçaklara Oturmayın',
    description:
        'Koltuk kolçakları oturmak için tasarlanmamıştır. Üzerine oturmak iskeleti zorlar ve bağlantı noktalarında gevşemeye yol açar.',
    category: 'Kullanım',
  ),
  FurnitureTip(
    icon: Icons.rotate_right,
    title: 'Oturma Pozisyonunu Değiştirin',
    description:
        'Koltukta sürekli aynı yere oturmayın. Minderlerin yerini düzenli değiştirerek eşit aşınma sağlayın. Aksi halde tek taraflı çökme oluşur.',
    category: 'Kullanım',
  ),
  FurnitureTip(
    icon: Icons.construction,
    title: 'Vidaları Düzenli Kontrol Edin',
    description:
        'Yılda bir kez tüm mobilya vidalarını kontrol edip gevşek olanları sıkın. Geciken bakım gıcırtı ve büyük arızalara neden olabilir.',
    category: 'Bakım',
  ),
  FurnitureTip(
    icon: Icons.auto_awesome_mosaic,
    title: 'Ayaklara Keçe Yapıştırın',
    description:
        'Tüm sandalye, masa ve sehpa ayaklarına keçe yapıştırın. Bu önlem parke çizilmesini ve çekme seslerini engeller.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.cleaning_services_outlined,
    title: 'Doğal Temizleyiciler Kullanın',
    description:
        'Arap sabunu gibi doğal temizleyicileri tercih edin. Ağır kimyasallar mobilyanın cila ve rengine zarar verir.',
    category: 'Temizlik',
  ),
  FurnitureTip(
    icon: Icons.king_bed_outlined,
    title: 'Yatağınızı Çevirin',
    description:
        'Yatağınızı 6 ayda bir baş-ayak yönünü değiştirin. Bu sayede yük eşit dağılır ve yatağın ömrü uzar, aksi takdirde çökmeler oluşur.',
    category: 'Bakım',
  ),
  FurnitureTip(
    icon: Icons.directions_run,
    title: 'Mobilyaları Kaldırarak Taşıyın',
    description:
        'Mobilyaları asla sürüklemeyin, daima kaldırarak taşıyın. Sürükleme ayak kırılmasına ve parke çizilmesine yol açar.',
    category: 'Taşıma',
  ),
  FurnitureTip(
    icon: Icons.library_books,
    title: 'Rafları Dengeli Yükleyin',
    description:
        'Ağır kitapları alt raflara, hafif olanları üst raflara yerleştirin. Dengesiz yükleme rafların sarkmasına neden olur.',
    category: 'Kullanım',
  ),
  FurnitureTip(
    icon: Icons.pets_outlined,
    title: 'Evcil Hayvanlar İçin Doğru Kumaş',
    description:
        'Kadife veya tay tüyü gibi sık dokulu kumaşları tercih edin. Dokuma kumaşlar evcil hayvan tırnaklarına karşı dayanıksızdır.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.child_care_outlined,
    title: 'Köşe Koruyucu Kullanın',
    description:
        'Küçük çocuklu evlerde tüm sivri köşelere koruyucu takın. Bu önlem hem çocuk güvenliği hem de mobilya koruması sağlar.',
    category: 'Güvenlik',
  ),
  FurnitureTip(
    icon: Icons.eco_outlined,
    title: 'Doğal Ahşap Bakımı Uygulayın',
    description:
        'Sirke ve zeytinyağı karışımı ile ahşap yüzeyleri doğal yoldan parlatın. Yanlış ürün kullanımı ahşabın çatlamasına yol açar.',
    category: 'Bakım',
  ),
  FurnitureTip(
    icon: Icons.square_foot,
    title: 'Kapak Açılımını Hesaplayın',
    description:
        'Mobilyayı yerleştirirken kapakların tam açılması için yeterli alan bırakın. Yetersiz alan kapakların duvara çarpıp kırılmasına sebep olur.',
    category: 'Yerleştirme',
  ),
  FurnitureTip(
    icon: Icons.settings,
    title: 'Menteşe Ayarını Öğrenin',
    description:
        'Sarkan dolap kapaklarını menteşe vidaları ile kolayca ayarlayabilirsiniz. Ayarsız menteşeler kapakların kapanmamasına neden olur.',
    category: 'Bakım',
  ),
  FurnitureTip(
    icon: Icons.volume_off,
    title: 'Gıcırtıları Giderin',
    description:
        'Gıcırdayan menteşe ve raylara makine yağı veya kalıp sabun sürün. Gıcırtılar zamanla menteşelerde aşınmaya yol açar.',
    category: 'Onarım',
  ),
  FurnitureTip(
    icon: Icons.inventory_2_outlined,
    title: 'Taşıma Öncesi Boşaltın',
    description:
        'Mobilyaları taşımadan önce çekmece ve dolapları tamamen boşaltın. Ağırlık çekmecelerin kırılmasına neden olabilir.',
    category: 'Taşıma',
  ),
  FurnitureTip(
    icon: Icons.local_offer_outlined,
    title: 'Vidaları Düzenli Saklayın',
    description:
        'Söktüğünüz vidaları poşete koyup mobilyaya bantlayın. Kaybolan vidalar mobilyanın montajını zorlaştırır.',
    category: 'Taşıma',
  ),
  FurnitureTip(
    icon: Icons.cable_outlined,
    title: 'Kabloları Düzenleyin',
    description:
        'TV ünitesi arkasındaki kabloları toplayıcılarla düzenleyin. Karmaşık kablolar toz yuvası oluşturur ve görüntü kirliliği yaratır.',
    category: 'Düzen',
  ),
  FurnitureTip(
    icon: Icons.brush_outlined,
    title: 'Kadife Kumaşları Doğru Temizleyin',
    description:
        'Kadife yüzeyleri daima kumaş yönünde, yumuşak fırçayla temizleyin. Ters yöne temizlik kumaşta iz bırakır.',
    category: 'Temizlik',
  ),
  FurnitureTip(
    icon: Icons.dew_point,
    title: 'Nem Dengesini Koruyun',
    description:
        'Ahşap mobilyalar için ideal nem oranı %40-60 arasıdır. Aşırı kuru veya nemli ortumlar ahşabın çatlamasına veya şişmesine yol açar.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.auto_fix_high,
    title: 'Çizikleri Onarın',
    description:
        'Yüzeysel ahşap çiziklerini ayakkabı boyası veya ceviz içi sürerek kapatın. Derinleşen çizikler mobilyanın görünümünü bozar.',
    category: 'Onarım',
  ),
  FurnitureTip(
    icon: Icons.ac_unit,
    title: 'Taze Koku İçin Doğal Çözümler',
    description:
        'Gardırop ve çekmecelere lavanta veya kalıp sabun yerleştirin. Doğal kokular giysilerinizin taze kalmasını sağlar.',
    category: 'Bakım',
  ),
  FurnitureTip(
    icon: Icons.history_edu,
    title: 'İkinci Elin Hikayesine Saygı',
    description:
        'İkinci el mobilyalardaki ufak izleri bir kusur değil, eşyanın karakteri olarak görün. Bu izler mobilyanın geçmişini ve kalitesini yansıtır.',
    category: 'Genel',
  ),
];
