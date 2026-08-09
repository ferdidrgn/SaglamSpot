import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

class FurnitureTipsSection extends StatelessWidget {
  const FurnitureTipsSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return SliverPadding(
      padding: const EdgeInsets.all(40),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Uzmanından Püf Noktaları',
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: context.primaryColor)),
            const SizedBox(height: 4),
            Container(height: 3, width: 40, color: AppColors.accent),
            const SizedBox(height: 28),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                mainAxisExtent: 200,
              ),
              itemCount: _furnitureTips.length,
              itemBuilder: (final context, final index) =>
                  _TipCard(tip: _furnitureTips[index], number: index + 1),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getCategoryColor(final String category) {
  switch (category) {
    case 'Yerleştirme':
      return AppColors.sage;
    case 'Koruma':
      return AppColors.info;
    case 'Temizlik':
      return AppColors.sageDark;
    case 'Bakım':
      return AppColors.accent;
    case 'Kullanım':
      return AppColors.accentDark;
    case 'Taşıma':
      return AppColors.primary;
    default:
      return AppColors.textSecondary;
  }
}

class _TipCard extends StatefulWidget {
  final FurnitureTip tip;
  final int number;

  const _TipCard({required this.tip, required this.number});

  @override
  State<_TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<_TipCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    final tip = widget.tip;
    final color = _getCategoryColor(tip.category);
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.09 : 0.04),
                blurRadius: _isHovered ? 26 : 20,
                offset: Offset(0, _isHovered ? 14 : 10))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 85,
              height: double.infinity,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color.withOpacity(0.7), color],
                    begin: Alignment.topLeft),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tip.icon, color: Colors.white, size: 28),
                    const SizedBox(height: 4),
                    Text("#${widget.number}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tip.category.toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(tip.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Text(tip.description,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.3),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FurnitureTip {
  final IconData icon;
  final String title;
  final String description;
  final String category;

  FurnitureTip(
      {required this.icon,
      required this.title,
      required this.description,
      required this.category});
}

final List<FurnitureTip> _furnitureTips = [
  FurnitureTip(
      icon: Icons.balance,
      title: 'Terazi Kontrolü Yapın',
      description:
          'Mobilyanızın tüm ayaklarının zemine tam bastığından emin olun. Eğimli zeminlerde keçe ile denge sağlayın.',
      category: 'Yerleştirme'),
  FurnitureTip(
      icon: Icons.space_bar,
      title: 'Duvarla Mesafe Bırakın',
      description:
          'Duvar arasında 1-2 cm boşluk bırakarak hava sirkülasyonu sağlayın. Rutubet ve küf oluşumunu engeller.',
      category: 'Yerleştirme'),
  FurnitureTip(
      icon: Icons.heat_pump,
      title: 'Isı Kaynaklarından Uzak Tutun',
      description:
          'Kalorifer ve sobalardan en az 30 cm uzakta konumlandırın. Yakın mesafe ahşabın çatlamasına neden olur.',
      category: 'Koruma'),
  FurnitureTip(
      icon: Icons.wb_sunny,
      title: 'Güneş Işığından Koruyun',
      description:
          'Direkt güneş ışığı renk solmasına ve ahşap deformasyonuna yol açar. Perdelerle ışığı filtreleyin.',
      category: 'Koruma'),
  FurnitureTip(
      icon: Icons.water_drop,
      title: 'Nemli Temizlik Yapın',
      description:
          'Ahşap yüzeyleri hafif nemli bezle silip hemen kurulayın. Sırılsıklam bez ahşabın şişmesine neden olur.',
      category: 'Temizlik'),
  FurnitureTip(
      icon: Icons.cleaning_services,
      title: 'Lekelere Anında Müdahale',
      description:
          'Kumaşa bir şey döküldüğünde hemen temizleyin. Bekleyen lekeler liflere işleyerek kalıcı hale gelir.',
      category: 'Temizlik'),
  FurnitureTip(
      icon: Icons.touch_app,
      title: 'Tampon Yöntemiyle Temizleyin',
      description:
          'Lekeleri ovalamak yerine tampon yaparak temizleyin. Ovalamak lekeyi daha geniş alana yayar.',
      category: 'Temizlik'),
  FurnitureTip(
      icon: Icons.emoji_objects,
      title: 'Bardak Altlığı Kullanın',
      description:
          'Sıcak ve soğuk içecekler için altlık kullanın. Doğrudan temas ahşapta beyaz halkalar bırakır.',
      category: 'Koruma'),
  FurnitureTip(
      icon: Icons.chair,
      title: 'Kolçaklara Oturmayın',
      description:
          'Kolçaklar oturmak için tasarlanmamıştır. Üzerine oturmak iskeleti zorlar ve bağlantıları gevşetir.',
      category: 'Kullanım'),
  FurnitureTip(
      icon: Icons.rotate_right,
      title: 'Oturma Pozisyonunu Değiştirin',
      description:
          'Minderlerin yerini düzenli değiştirerek eşit aşınma sağlayın. Tek taraflı çökmeleri önleyin.',
      category: 'Kullanım'),
  FurnitureTip(
      icon: Icons.construction,
      title: 'Vidaları Düzenli Kontrol Edin',
      description:
          'Yılda bir kez tüm mobilya vidalarını kontrol edip gevşek olanları sıkın. Gıcırtıları önler.',
      category: 'Bakım'),
  FurnitureTip(
      icon: Icons.auto_awesome_mosaic,
      title: 'Ayaklara Keçe Yapıştırın',
      description:
          'Tüm sandalye ve masa ayaklarına keçe yapıştırın. Parke çizilmesini ve sesleri engeller.',
      category: 'Koruma'),
  FurnitureTip(
      icon: Icons.eco,
      title: 'Doğal Temizleyiciler Kullanın',
      description:
          'Arap sabunu gibi doğal temizleyicileri tercih edin. Kimyasallar mobilyanın cilasına zarar verir.',
      category: 'Temizlik'),
  FurnitureTip(
      icon: Icons.king_bed,
      title: 'Yatağınızı Çevirin',
      description:
          'Yatağınızı 6 ayda bir baş-ayak yönünde değiştirin. Yük eşit dağılır ve çökmeler önlenir.',
      category: 'Bakım'),
  FurnitureTip(
      icon: Icons.directions_run,
      title: 'Mobilyaları Kaldırarak Taşıyın',
      description:
          'Mobilyaları asla sürüklemeyin, daima kaldırarak taşıyın. Sürükleme ayak kırılmasına yol açar.',
      category: 'Taşıma'),
  FurnitureTip(
      icon: Icons.library_books,
      title: 'Rafları Dengeli Yükleyin',
      description:
          'Ağır kitapları alt raflara, hafifleri üst raflara yerleştirin. Rafların sarkmasını önler.',
      category: 'Kullanım'),
  FurnitureTip(
      icon: Icons.pets,
      title: 'Evcil Hayvanlar İçin Kumaş',
      description:
          'Tay tüyü gibi sık dokulu kumaşları tercih edin. Dokuma kumaşlar tırnaklara karşı dayanıksızdır.',
      category: 'Koruma'),
  FurnitureTip(
      icon: Icons.child_care,
      title: 'Köşe Koruyucu Kullanın',
      description:
          'Sivri köşelere koruyucu takın. Hem çocuk güvenliği hem mobilya koruması sağlar.',
      category: 'Güvenlik'),
  FurnitureTip(
      icon: Icons.brush,
      title: 'Kadife Kumaş Bakımı',
      description:
          'Kadife yüzeyleri daima tüy yönünde fırçalayın. Ters yöne temizlik kumaşta iz bırakır.',
      category: 'Temizlik'),
  FurnitureTip(
      icon: Icons.dew_point,
      title: 'Nem Dengesini Koruyun',
      description:
          'İdeal nem oranı %40-60 arasıdır. Aşırı kuru ortamlar ahşabın çatlamasına yol açar.',
      category: 'Koruma'),
  FurnitureTip(
      icon: Icons.auto_fix_high,
      title: 'Çizikleri Onarın',
      description:
          'Yüzeysel çizikleri ceviz içi sürerek kapatabilirsiniz. Mobilyanın görünümünü tazeler.',
      category: 'Onarım'),
  FurnitureTip(
      icon: Icons.inventory_2,
      title: 'Taşıma Öncesi Boşaltın',
      description:
          'Taşımadan önce çekmece ve dolapları boşaltın. Ağırlık çekmecelerin kırılmasına neden olabilir.',
      category: 'Taşıma'),
  FurnitureTip(
      icon: Icons.local_offer,
      title: 'Vidaları Düzenli Saklayın',
      description:
          'Söktüğünüz vidaları mobilyaya bantlayın. Kaybolan vidalar montajı imkansız kılar.',
      category: 'Taşıma'),
  FurnitureTip(
      icon: Icons.cable,
      title: 'Kabloları Düzenleyin',
      description:
          'TV ünitesi arkasını toplayıcılarla düzenleyin. Toz yuvası oluşumunu engeller.',
      category: 'Düzen'),
  FurnitureTip(
      icon: Icons.square_foot,
      title: 'Kapak Açılımını Hesaplayın',
      description:
          'Mobilyayı kapaklar tam açılacak şekilde yerleştirin. Menteşe zorlanmalarını önler.',
      category: 'Yerleştirme'),
  FurnitureTip(
      icon: Icons.settings,
      title: 'Menteşe Ayarını Öğrenin',
      description:
          'Sarkan kapakları menteşe vidaları ile kolayca hizalayabilirsiniz.',
      category: 'Bakım'),
  FurnitureTip(
      icon: Icons.volume_off,
      title: 'Gıcırtıları Giderin',
      description:
          'Gıcırdayan menteşe ve raylara makine yağı sürün. Aşınmaları engeller.',
      category: 'Bakım'),
  FurnitureTip(
      icon: Icons.ac_unit,
      title: 'Ferah Koku İçin Çözümler',
      description:
          'Gardırop içlerine lavanta kesesi koyun. Rutubet kokusu oluşumunu engeller.',
      category: 'Bakım'),
  FurnitureTip(
      icon: Icons.history_edu,
      title: 'İkinci El Hikayesine Saygı',
      description:
          'İkinci eldeki ufak izleri karakter olarak görün. Geçmişini ve kalitesini yansıtır.',
      category: 'Genel'),
  FurnitureTip(
      icon: Icons.stars,
      title: 'Parlatma Sırrı',
      description:
          'Mikrofiber bezle dairesel hareketlerle silmek doğal parlaklığı korur.',
      category: 'Temizlik'),
];
