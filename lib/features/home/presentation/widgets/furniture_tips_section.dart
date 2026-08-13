import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Referans tasarımdaki "Tips & Tricks" şeridinin karşılığı. 10 ipucu
/// olduğu için artık ne mobilde tek kart ne masaüstünde eşit bölünmüş bir
/// Row (10 kartı sıkıştırıp berbat görünürdü) kullanılıyor — hepsi sabit
/// genişlikli kartlarla yatay kaydırılan tek bir şerit, her kırılım
/// noktasında kendi kart genişliğiyle "yan yana birkaç kart" hissini korur.
class FurnitureTipsSection extends StatelessWidget {
  const FurnitureTipsSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final cardWidth =
        context.responsive(mobile: 260.0, tablet: 300.0, desktop: 340.0);
    // Kart yüksekliği kart genişliğine göre hesaplanıyor: görsel (4:3) +
    // metin bloğu. Eskiden mobilde sabit 340px'e sıkıştırılmıştı ve bu,
    // geniş "mobil" aralığında (0-768px) alttan taşıyordu — artık kart
    // genişliği ne olursa olsun içerik tam sığıyor.
    final cardHeight = cardWidth * 0.75 + 150;

    final tips = _tips(context);

    return SliverPadding(
      padding: context.pagePadding.copyWith(
          top: context.spacingLarge * 2, bottom: context.spacingLarge * 2),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Text(context.l10n.tipsEyebrow,
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    fontSize: context.captionSize)),
            const SizedBox(height: 8),
            Text(context.l10n.tipsHeading,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 32),
            SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: tips.length,
                separatorBuilder: (final _, final __) =>
                    const SizedBox(width: 20),
                itemBuilder: (final context, final index) => SizedBox(
                  width: cardWidth,
                  child: _TipCard(tip: tips[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatefulWidget {
  final FurnitureTip tip;

  const _TipCard({required this.tip});

  @override
  State<_TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<_TipCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    final tip = widget.tip;
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
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.04),
                blurRadius: _isHovered ? 24 : 16,
                offset: Offset(0, _isHovered ? 12 : 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: AnimatedScale(
                  scale: _isHovered ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  child: Image.network(
                    tip.image,
                    fit: BoxFit.cover,
                    errorBuilder: (final c, final e, final s) => Container(
                        color: AppColors.secondary,
                        child: Icon(tip.icon,
                            size: 32, color: AppColors.textTertiary)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(tip.icon, size: 14, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Text(tip.category.toUpperCase(),
                          style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 1)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(tip.title,
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(tip.description,
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
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
  final String image;

  const FurnitureTip({
    required this.icon,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
  });
}

List<FurnitureTip> _tips(final BuildContext context) => [
  FurnitureTip(
    icon: Icons.weekend_rounded,
    title: context.l10n.tip1Title,
    description: context.l10n.tip1Desc,
    category: context.l10n.tip1Category,
    image: 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.cleaning_services_rounded,
    title: context.l10n.tip2Title,
    description: context.l10n.tip2Desc,
    category: context.l10n.tip2Category,
    image: 'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.kitchen_rounded,
    title: context.l10n.tip3Title,
    description: context.l10n.tip3Desc,
    category: context.l10n.tip3Category,
    image: 'https://images.unsplash.com/photo-1556909212-d5b604d0c90d?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.bed_rounded,
    title: context.l10n.tip4Title,
    description: context.l10n.tip4Desc,
    category: context.l10n.tip4Category,
    image: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.checkroom_rounded,
    title: context.l10n.tip5Title,
    description: context.l10n.tip5Desc,
    category: context.l10n.tip5Category,
    image: 'https://images.unsplash.com/photo-1558997519-83ea9252edf8?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.forest_rounded,
    title: context.l10n.tip6Title,
    description: context.l10n.tip6Desc,
    category: context.l10n.tip6Category,
    image: 'https://images.unsplash.com/photo-1601057483204-3b0a4c50d4ac?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.dry_cleaning_rounded,
    title: context.l10n.tip7Title,
    description: context.l10n.tip7Desc,
    category: context.l10n.tip7Category,
    image: 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.lightbulb_rounded,
    title: context.l10n.tip8Title,
    description: context.l10n.tip8Desc,
    category: context.l10n.tip8Category,
    image: 'https://images.unsplash.com/photo-1524484485831-a92ffc0de03f?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.space_dashboard_rounded,
    title: context.l10n.tip9Title,
    description: context.l10n.tip9Desc,
    category: context.l10n.tip9Category,
    image: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.deck_rounded,
    title: context.l10n.tip10Title,
    description: context.l10n.tip10Desc,
    category: context.l10n.tip10Category,
    image: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?q=80&w=800',
  ),
];
