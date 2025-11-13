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

// Püf noktaları listesi (10 adet kısaltılmış)
final List<FurnitureTip> _furnitureTips = [
  FurnitureTip(
    icon: Icons.balance,
    title: 'Terazi Kontrolü Yapın',
    description:
        'Mobilyanın tüm ayakları zemine tam bassın. Yamuk zeminlerde keçe veya kartonla destek yapın. Aksi halde mobilya esner, kapaklar sarkar.',
    category: 'Yerleştirme',
  ),
  FurnitureTip(
    icon: Icons.space_bar,
    title: 'Duvarla Mesafe Bırakın',
    description:
        'Mobilya ile duvar arasında 1-2 cm boşluk bırakın. Bu küçük mesafe rutubet ve küfü önler.',
    category: 'Yerleştirme',
  ),
  FurnitureTip(
    icon: Icons.heat_pump_outlined,
    title: 'Isı Kaynaklarından Uzak Tutun',
    description:
        'Mobilyaları kaloriferden en az 30 cm uzak tutun. Direkt ısı ahşabı kurutur, çatlatır.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.wb_sunny_outlined,
    title: 'Güneş Işığından Koruyun',
    description:
        'Direkt güneş ışığına maruz bırakmayın. Güneş, renk solmasına ve ahşap deformasyonuna yol açar.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.water_drop_outlined,
    title: 'Nemli Temizlik Yapın',
    description:
        'Ahşabı hafif nemli bezle silip hemen kurulayın. Sırılsıklam bez ahşabı şişirir.',
    category: 'Temizlik',
  ),
  FurnitureTip(
    icon: Icons.cleaning_services,
    title: 'Lekelere Anında Müdahale',
    description:
        'Kumaşa dökülenleri hemen temizleyin. Bekleyen lekeler kumaşın liflerine işler.',
    category: 'Temizlik',
  ),
  FurnitureTip(
    icon: Icons.emoji_objects_outlined,
    title: 'Bardak Altlığı Kullanın',
    description:
        'Sıcak-soğuk tüm bardaklar için altlık kullanın. Doğrudan temas beyaz halka yapar.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.construction,
    title: 'Vidaları Kontrol Edin',
    description:
        'Yılda bir tüm mobilya vidalarını sıkın. Gevşek vidalar gıcırtı ve arızaya neden olur.',
    category: 'Bakım',
  ),
  FurnitureTip(
    icon: Icons.auto_awesome_mosaic,
    title: 'Ayaklara Keçe Yapıştırın',
    description:
        'Tüm ayaklara keçe yapıştırın. Parke çizilmesini ve çekme seslerini engeller.',
    category: 'Koruma',
  ),
  FurnitureTip(
    icon: Icons.king_bed_outlined,
    title: 'Yatağınızı Çevirin',
    description: 'Yatağınızı 6 ayda bir çevirin. Yük eşit dağılır, ömrü uzar.',
    category: 'Bakım',
  ),
];
