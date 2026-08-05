import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// "Nasıl Çalışır" süreç şeridi. Kullanıcıya siteden mobilya almanın kaç
/// adımda tamamlandığını gösterir — güven ve netlik yaratan bir bölüm.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const List<_Step> _steps = [
    _Step(
      icon: Icons.travel_explore_rounded,
      title: 'Gözat & Filtrele',
      desc:
          'Kategoriler ve fiyat aralığına göre binlerce ürün arasından beğendiğini bul.',
    ),
    _Step(
      icon: Icons.chat_bubble_rounded,
      title: 'Bizimle İletişime Geç',
      desc:
          'Ürün sayfasından tek tıkla WhatsApp veya telefonla ekibimize ulaş.',
    ),
    _Step(
      icon: Icons.handshake_rounded,
      title: 'Fiyatı Netleştir',
      desc:
          'Ürünü showroom’da gör veya fotoğraflarla teyit et, esnaf usulü net fiyat al.',
    ),
    _Step(
      icon: Icons.local_shipping_rounded,
      title: 'Kapına Teslim',
      desc:
          'İçerenköy ve Anadolu Yakası’na hızlı, sigortalı taşıma ile mobilyan güvenle evine gelsin.',
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return SliverPadding(
      padding:
          EdgeInsets.symmetric(horizontal: isMobile ? 16 : 60, vertical: 40),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nasıl Çalışır?',
                style: TextStyle(
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w900,
                    color: context.primaryColor)),
            const SizedBox(height: 4),
            Container(height: 3, width: 40, color: context.colors.secondary),
            const SizedBox(height: 24),
            isMobile
                ? Column(
                    children: [
                      for (int i = 0; i < _steps.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _StepCard(step: _steps[i], index: i + 1),
                        ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _steps.length; i++) ...[
                        Expanded(
                            child: _StepCard(step: _steps[i], index: i + 1)),
                        if (i != _steps.length - 1)
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

class _StepCard extends StatelessWidget {
  final _Step step;
  final int index;

  const _StepCard({required this.step, required this.index});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8)),
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
    );
  }
}
