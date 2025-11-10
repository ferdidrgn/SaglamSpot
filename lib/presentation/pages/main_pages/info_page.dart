import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero Section
        _buildHeroSection(),

        // Our Story
        _buildOurStory(),

        // Our Values
        _buildOurValues(),

        // Team Section
        _buildTeamSection(),

        // Contact Info
        _buildContactSection(),

        // Map Section (Placeholder)
        _buildMapSection(),

        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              bottom: -50,
              child: Icon(
                Icons.info_outline,
                size: 300,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      'HAKKIMIZDA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Hayalinizdeki Evi\nBirlikte Oluşturalım',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '15 yıldır kaliteli mobilya ve müşteri memnuniyeti\nodaklı hizmet anlayışımızla yanınızdayız.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOurStory() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Center(
                      child: Icon(
                        Icons.store,
                        size: 120,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hikayemiz',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '2009 yılında küçük bir atölye olarak başladık. Mobilya sektöründe kalite ve müşteri memnuniyeti odaklı yaklaşımımızla kısa sürede büyüdük.',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bugün, hem sıfır hem de ikinci el mobilya ürünleriyle binlerce müşterimize hizmet veriyor, evlere sıcaklık ve konfor katıyoruz.',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sürdürülebilir yaşam anlayışıyla, kaliteli ikinci el ürünlere yeni bir hayat verirken, çevreye olan sorumluluğumuzu da yerine getiriyoruz.',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      _buildStoryHighlight('2009', 'Kuruluş Yılı'),
                      const SizedBox(width: 32),
                      _buildStoryHighlight('15+', 'Yıllık Deneyim'),
                      const SizedBox(width: 32),
                      _buildStoryHighlight('2.5K+', 'Mutlu Müşteri'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryHighlight(final String number, final String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOurValues() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Değerlerimiz',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bizi biz yapan ilkeler',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildValueCard(
                    Icons.verified_outlined,
                    'Kalite',
                    'Her üründe en yüksek kalite standartlarını garanti ediyoruz.',
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildValueCard(
                    Icons.favorite_outline,
                    'Müşteri Memnuniyeti',
                    'Müşterilerimizin mutluluğu bizim için en önemli önceliktir.',
                    AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildValueCard(
                    Icons.eco_outlined,
                    'Sürdürülebilirlik',
                    'Çevreye duyarlı, sürdürülebilir ticaret anlayışını benimsiyoruz.',
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildValueCard(
                    Icons.handshake_outlined,
                    'Güven',
                    'Şeffaf ve dürüst iş ilişkileri kurmaya önem veriyoruz.',
                    AppColors.info,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(
    final IconData icon,
    final String title,
    final String description,
    final Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 48),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            const Text(
              'Ekibimiz',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Uzman ve deneyimli kadromuzla hizmetinizdeyiz',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: _buildTeamMember(
                    'Ahmet Yılmaz',
                    'Kurucu & CEO',
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTeamMember(
                    'Ayşe Demir',
                    'Satış Müdürü',
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTeamMember(
                    'Mehmet Kaya',
                    'Lojistik Sorumlusu',
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildTeamMember(
                    'Zeynep Şahin',
                    'Müşteri İlişkileri',
                    Icons.person_outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(final String name, final String role, final IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            role,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            const Text(
              'İletişim Bilgilerimiz',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: _buildContactItem(
                    Icons.phone_outlined,
                    'Telefon',
                    '+90 (212) 555 0123',
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildContactItem(
                    Icons.email_outlined,
                    'E-posta',
                    'info@mobilyaevim.com',
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildContactItem(
                    Icons.location_on_outlined,
                    'Adres',
                    'İstanbul, Türkiye',
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildContactItem(
                    Icons.access_time_outlined,
                    'Çalışma Saatleri',
                    'Pzt-Cmt: 09:00-18:00',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Bize Ulaşın',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(final IconData icon, final String label, final String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        height: 400,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            color: AppColors.background,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 80,
                    color: AppColors.textTertiary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Konum Haritası',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
