import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Referans tasarımdaki "Tips & Tricks" şeridinin karşılığı: masaüstünde
/// yan yana 3 fotoğraflı kart, mobilde kaydırmalı + noktalı gösterge.
class FurnitureTipsSection extends StatefulWidget {
  const FurnitureTipsSection({super.key});

  @override
  State<FurnitureTipsSection> createState() => _FurnitureTipsSectionState();
}

class _FurnitureTipsSectionState extends State<FurnitureTipsSection> {
  final PageController _pageController = PageController(viewportFraction: 0.86);
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isMobile = context.isMobile;

    return SliverPadding(
      padding: context.pagePadding.copyWith(
          top: context.spacingLarge * 2, bottom: context.spacingLarge * 2),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Text('İPUÇLARI',
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    fontSize: context.captionSize)),
            const SizedBox(height: 8),
            Text('Uzmanından Bakım Önerileri',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 32),
            if (isMobile)
              SizedBox(
                height: 340,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _tips.length,
                  onPageChanged: (final i) => setState(() => _page = i),
                  itemBuilder: (final context, final index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _TipCard(tip: _tips[index]),
                  ),
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _tips.length; i++) ...[
                    if (i > 0) const SizedBox(width: 24),
                    Expanded(child: _TipCard(tip: _tips[i])),
                  ],
                ],
              ),
            if (isMobile) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_tips.length, (final i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active ? AppColors.accent : AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ],
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
                          style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 1)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(tip.title,
                      style: const TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(tip.description,
                      style: const TextStyle(
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

const List<FurnitureTip> _tips = [
  FurnitureTip(
    icon: Icons.weekend_rounded,
    title: 'Oturma Odasını Sevilesi Hale Getirin',
    description:
        'Koltuk yerleşimini duvardan 1-2 cm boşluk bırakarak yapın; hem hava sirkülasyonu sağlar hem de odayı ferahlatır.',
    category: 'Yerleştirme',
    image: 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.cleaning_services_rounded,
    title: 'Temiz Görünen Bir Çalışma Alanı',
    description:
        'Kabloları toplayıcılarla düzenleyin, mikrofiber bezle dairesel hareketlerle silin — masanız hep yeni gibi kalsın.',
    category: 'Temizlik',
    image: 'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?q=80&w=800',
  ),
  FurnitureTip(
    icon: Icons.kitchen_rounded,
    title: 'Mutfakta Keyifli Bir Kurulum',
    description:
        'Ağır malzemeleri alt raflara, sık kullandıklarınızı göz hizasına yerleştirin — hem pratik hem güvenli.',
    category: 'Düzen',
    image: 'https://images.unsplash.com/photo-1556909212-d5b604d0c90d?q=80&w=800',
  ),
];
