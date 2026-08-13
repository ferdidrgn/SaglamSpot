import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// "Neden Sağlam Spot" bölümü — güven inşa eden, farklılaştırıcı
/// noktaları (USP) vurgulayan kart grid'i.
class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  List<_Usp> _items(final BuildContext context) => [
    _Usp(
      icon: Icons.verified_user_rounded,
      title: context.l10n.usp1Title,
      desc: context.l10n.usp1Desc,
      color: AppColors.sage,
    ),
    _Usp(
      icon: Icons.savings_rounded,
      title: context.l10n.usp2Title,
      desc: context.l10n.usp2Desc,
      color: AppColors.accent,
    ),
    _Usp(
      icon: Icons.fact_check_rounded,
      title: context.l10n.usp3Title,
      desc: context.l10n.usp3Desc,
      color: AppColors.primary,
    ),
    _Usp(
      icon: Icons.support_agent_rounded,
      title: context.l10n.usp4Title,
      desc: context.l10n.usp4Desc,
      color: AppColors.sageDark,
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final items = _items(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 60, vertical: 40),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.whyUsHeading,
                  style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: context.h2Size,
                      fontWeight: FontWeight.w600,
                      color: context.primaryColor)),
              const SizedBox(height: 4),
              Container(height: 3, width: 40, color: AppColors.accent),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 140,
                ),
                itemCount: items.length,
                itemBuilder: (final context, final index) =>
                    _UspCard(item: items[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Usp {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  const _Usp(
      {required this.icon,
      required this.title,
      required this.desc,
      required this.color});
}

class _UspCard extends StatefulWidget {
  final _Usp item;

  const _UspCard({required this.item});

  @override
  State<_UspCard> createState() => _UspCardState();
}

class _UspCardState extends State<_UspCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform:
            _isHovered ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
                blurRadius: _isHovered ? 24 : 16,
                offset: Offset(0, _isHovered ? 10 : 6)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.item.icon, color: widget.item.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 14.5)),
                  const SizedBox(height: 6),
                  Text(widget.item.desc,
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                          height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
