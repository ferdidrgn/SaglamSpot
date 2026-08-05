import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// "Neden Sağlam Spot" bölümü — güven inşa eden, farklılaştırıcı
/// noktaları (USP) vurgulayan kart grid'i.
class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  static const List<_Usp> _items = [
    _Usp(
      icon: Icons.verified_user_rounded,
      title: '20 Yıllık Esnaf Güvencesi',
      desc: 'İçerenköy’de yirmi yılı aşan bir esnaflık geçmişi ve binlerce memnun müşteri.',
      color: Color(0xFF2E7D6B),
    ),
    _Usp(
      icon: Icons.savings_rounded,
      title: 'Piyasanın Altında Fiyat',
      desc: 'Aracısız çalışma modelimizle spot ve sıfır mobilyada en uygun fiyatlar bizde.',
      color: Color(0xFFC5A358),
    ),
    _Usp(
      icon: Icons.fact_check_rounded,
      title: 'Kontrollü Ürün Kalitesi',
      desc: 'Her ürün satışa çıkmadan önce yapısal ve kumaş/kaplama kontrolünden geçer.',
      color: Color(0xFF3E6B8A),
    ),
    _Usp(
      icon: Icons.support_agent_rounded,
      title: 'Satış Sonrası Destek',
      desc: 'Teslimat sonrası da ulaşabileceğin, sorununu çözen gerçek bir ekip.',
      color: Color(0xFFB2673E),
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

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
              Text('Neden Sağlam Spot?',
                  style: TextStyle(
                      fontSize: context.h2Size,
                      fontWeight: FontWeight.w900,
                      color: context.primaryColor)),
              const SizedBox(height: 4),
              Container(height: 3, width: 40, color: context.colors.secondary),
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
                itemCount: _items.length,
                itemBuilder: (final context, final index) =>
                    _UspCard(item: _items[index]),
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

class _UspCard extends StatelessWidget {
  final _Usp item;

  const _UspCard({required this.item});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14.5)),
                const SizedBox(height: 6),
                Text(item.desc,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
