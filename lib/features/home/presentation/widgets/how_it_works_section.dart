import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// "Nasıl Çalışır" süreç şeridi. Kullanıcıya siteden mobilya almanın kaç
/// adımda tamamlandığını gösterir — güven ve netlik yaratan bir bölüm.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  List<_Step> _steps(final BuildContext context) => [
    _Step(
      icon: Icons.travel_explore_rounded,
      title: context.l10n.step1Title,
      desc: context.l10n.step1Desc,
    ),
    _Step(
      icon: Icons.chat_bubble_rounded,
      title: context.l10n.step2Title,
      desc: context.l10n.step2Desc,
    ),
    _Step(
      icon: Icons.handshake_rounded,
      title: context.l10n.step3Title,
      desc: context.l10n.step3Desc,
    ),
    _Step(
      icon: Icons.local_shipping_rounded,
      title: context.l10n.step4Title,
      desc: context.l10n.step4Desc,
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final steps = _steps(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 60, vertical: 40),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.howItWorksHeading,
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: context.primaryColor)),
            const SizedBox(height: 4),
            Container(height: 3, width: 40, color: AppColors.accent),
            const SizedBox(height: 24),
            isMobile
                ? Column(
                    children: [
                      for (int i = 0; i < steps.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _StepCard(step: steps[i], index: i + 1),
                        ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < steps.length; i++) ...[
                        Expanded(child: _StepCard(step: steps[i], index: i + 1)),
                        if (i != steps.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Icon(Icons.arrow_forward_rounded,
                                color: context.primaryColor.withOpacity(0.2)),
                          ),
                      ],
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class _Step {
  final IconData icon;
  final String title;
  final String desc;

  const _Step({required this.icon, required this.title, required this.desc});
}

class _StepCard extends StatefulWidget {
  final _Step step;
  final int index;

  const _StepCard({required this.step, required this.index});

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    final step = widget.step;
    final index = widget.index;
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.09 : 0.04),
                blurRadius: _isHovered ? 26 : 18,
                offset: Offset(0, _isHovered ? 12 : 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(step.icon, color: Colors.white, size: 24),
                ),
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text('$index',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(step.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 6),
            Text(step.desc,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
