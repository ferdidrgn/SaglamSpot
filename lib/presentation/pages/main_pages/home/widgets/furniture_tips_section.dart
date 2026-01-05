import 'package:flutter/material.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';

class FurnitureTipsSection extends StatelessWidget {
  const FurnitureTipsSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final tips = [
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Doğru Aydınlatma',
        'desc':
            'Mobilyalarınızın konumunu planlarken doğal ışık kaynaklarını göz önünde bulundurun. Gün ışığı mekanınızı daha canlı gösterir.',
        'color': const Color(0xFFFFF4E6),
        'iconColor': const Color(0xFFFF9800),
      },
      {
        'icon': Icons.straighten,
        'title': 'Ölçü Önemlidir',
        'desc':
            'Mobilya almadan önce alanınızı detaylı ölçün. Görsel olarak uyumlu bir düzen oluşturmak için yeterli hareket alanı bırakın.',
        'color': const Color(0xFFE3F2FD),
        'iconColor': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'Renk Uyumu',
        'desc':
            'Mobilyalarınızı seçerken oda renklerinizle uyumlu tonları tercih edin. Kontrast renkler kullanarak vurgu noktaları yaratın.',
        'color': const Color(0xFFF3E5F5),
        'iconColor': const Color(0xFF9C27B0),
      },
      {
        'icon': Icons.eco_outlined,
        'title': 'Sürdürülebilir Seçim',
        'desc':
            'İkinci el ve yenilenmiş mobilyalar hem bütçenize hem de çevreye dosttur. Kaliteli ürünleri uygun fiyatlarla bulun.',
        'color': const Color(0xFFE8F5E9),
        'iconColor': const Color(0xFF4CAF50),
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1440),
        margin: EdgeInsets.symmetric(
          horizontal: context.responsive(
            mobile: 16.0,
            tablet: 32.0,
            desktop: 48.0,
            largeDesktop: 64.0,
          ),
          vertical: context.responsive(mobile: 32.0, desktop: 48.0),
        ),
        padding: EdgeInsets.all(
          context.responsive(mobile: 24.0, tablet: 32.0, desktop: 48.0),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFFBF5),
              Colors.white,
              const Color(0xFFF8F9FA),
            ],
          ),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          border: Border.all(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    context.responsive(mobile: 12.0, desktop: 16.0),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(
                      context.responsive(mobile: 14.0, desktop: 18.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.tips_and_updates_outlined,
                    color: Colors.white,
                    size: context.responsive(mobile: 28.0, desktop: 32.0),
                  ),
                ),
                SizedBox(width: context.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mobilya Seçim İpuçları',
                        style: TextStyle(
                          fontSize: context.responsive(
                            mobile: 20.0,
                            tablet: 24.0,
                            desktop: 28.0,
                          ),
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(
                          height:
                              context.responsive(mobile: 3.0, desktop: 4.0)),
                      Text(
                        'Eviniz için en doğru tercihleri yapın',
                        style: TextStyle(
                          fontSize:
                              context.responsive(mobile: 13.0, desktop: 16.0),
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(
                height: context.responsive(
                    mobile: 24.0, tablet: 32.0, desktop: 40.0)),

            // Tips Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    context.responsive(mobile: 1, tablet: 2, desktop: 2),
                crossAxisSpacing: context.responsive(
                    mobile: 16.0, tablet: 20.0, desktop: 24.0),
                mainAxisSpacing: context.responsive(
                    mobile: 16.0, tablet: 20.0, desktop: 24.0),
                childAspectRatio: context.responsive(
                  mobile: 2.2,
                  tablet: 2.0,
                  desktop: 2.3,
                ),
              ),
              itemCount: tips.length,
              itemBuilder: (final context, final index) {
                final tip = tips[index];
                return _TipCard(
                  icon: tip['icon'] as IconData,
                  title: tip['title'] as String,
                  description: tip['desc'] as String,
                  backgroundColor: tip['color'] as Color,
                  iconColor: tip['iconColor'] as Color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color iconColor;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  State<_TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<_TipCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -5.0, 0.0))
            : Matrix4.identity(),
        padding: EdgeInsets.all(
          context.responsive(mobile: 18.0, desktop: 24.0),
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 18.0, desktop: 22.0),
          ),
          border: Border.all(
            color: widget.iconColor.withOpacity(_isHovered ? 0.4 : 0.2),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.iconColor.withOpacity(_isHovered ? 0.2 : 0.1),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(
                context.responsive(mobile: 12.0, desktop: 14.0),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  context.responsive(mobile: 14.0, desktop: 16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.iconColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: context.responsive(mobile: 24.0, desktop: 28.0),
              ),
            ),
            SizedBox(width: context.spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 15.0, desktop: 17.0),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(
                      height: context.responsive(mobile: 6.0, desktop: 8.0)),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 13.0, desktop: 14.0),
                      height: 1.5,
                      color: AppColors.textSecondary.withOpacity(0.85),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
