import 'package:flutter/material.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero Section
        _buildHeroSection(context),

        // Our Story
        _buildOurStory(context),

        // Our Values
        _buildOurValues(context),

        // Ustamızın Geçmişi
        _buildMasterHistory(context),

        // Taşıma Hizmeti
        _buildDeliveryService(context),

        // Ulaşım Bilgileri
        _buildTransportationInfo(context),

        // Team Section
        _buildTeamSection(context),

        // Contact Info
        _buildContactSection(context),

        // Map Section
        _buildMapSection(context),

        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }

  // Hero Section
  Widget _buildHeroSection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(24),
        ),
        height: context.responsive(mobile: 300, desktop: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
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
                Icons.storefront_outlined,
                size: context.responsive(mobile: 200, desktop: 300),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: context.responsive(
                mobile: const EdgeInsets.all(24),
                desktop: const EdgeInsets.all(60),
              ),
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
                    child: Text(
                      '20 YILLIK ESNAF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.responsive(mobile: 12, desktop: 14),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sağlam Spot\nGüvenin Adresi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.responsive(mobile: 32, desktop: 52),
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '1992\'den beri kalite ve güven odaklı hizmet\nanlayışımızla yanınızdayız.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.responsive(mobile: 16, desktop: 20),
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

  // Our Story
  Widget _buildOurStory(final BuildContext context) {
    final children = [
      Expanded(
        child: Container(
          height: context.responsive(mobile: 300, desktop: 500),
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
              color: Colors.brown.withOpacity(0.1),
              child: const Center(
                child: Icon(
                  Icons.store,
                  size: 120,
                  color: Colors.brown,
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 48),
        height: context.responsive(mobile: 24, desktop: 0),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İş Yeri Bilgileri',
              style: TextStyle(
                fontSize: context.responsive(mobile: 28, desktop: 42),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Müşterilerimize en kaliteli ve şık mobilya çözümleri sunarak, yaşam alanlarını daha konforlu ve estetik hale getiriyoruz.',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: AppColors.textSecondary,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '1992 yılında küçük bir atölye olarak başladık. Mobilya sektöründe kalite ve müşteri memnuniyeti odaklı yaklaşımımızla kısa sürede büyüdük.',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: AppColors.textSecondary,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bugün, hem sıfır hem de ikinci el mobilya ürünleriyle binlerce müşterimize hizmet veriyor, evlere sıcaklık ve konfor katıyoruz.',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: AppColors.textSecondary,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 32,
              runSpacing: 24,
              children: [
                _buildStoryHighlight('1992', 'Kuruluş'),
                _buildStoryHighlight('30+', 'Yıllık Deneyim'),
                _buildStoryHighlight('5K+', 'Mutlu Müşteri'),
              ],
            ),
          ],
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        child: context.responsive<Widget>(
          mobile: Column(children: children),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
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

  // Our Values
  Widget _buildOurValues(final BuildContext context) {
    final children = [
      Expanded(
        child: _buildValueCard(
          context,
          Icons.verified_outlined,
          'Kalite',
          'Her üründe en yüksek kalite standartlarını garanti ediyoruz.',
          AppColors.primary,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 24),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildValueCard(
          context,
          Icons.favorite_outline,
          'Müşteri Memnuniyeti',
          'Müşterilerimizin mutluluğu bizim için en önemli önceliktir.',
          AppColors.secondary,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 24),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildValueCard(
          context,
          Icons.eco_outlined,
          'Sürdürülebilirlik',
          'Çevreye duyarlı, sürdürülebilir ticaret anlayışını benimsiyoruz.',
          AppColors.success,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 24),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildValueCard(
          context,
          Icons.handshake_outlined,
          'Güven',
          'Şeffaf ve dürüst iş ilişkileri kurmaya önem veriyoruz.',
          AppColors.info,
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
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
            Text(
              'Değerlerimiz',
              style: TextStyle(
                fontSize: context.responsive(mobile: 28, desktop: 42),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bizi biz yapan ilkeler',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            context.responsive<Widget>(
              mobile: Column(children: children),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(
    final BuildContext context,
    final IconData icon,
    final String title,
    final String description,
    final Color color,
  ) {
    return Container(
      padding: context.responsive(
        mobile: const EdgeInsets.all(24),
        desktop: const EdgeInsets.all(32),
      ),
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
            child: Icon(
              icon,
              color: color,
              size: context.responsive(mobile: 40, desktop: 48),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: context.responsive(mobile: 18, desktop: 22),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.responsive(mobile: 15, desktop: 16),
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // Ustamızın Geçmişi
  Widget _buildMasterHistory(final BuildContext context) {
    final children = [
      Container(
        width: context.responsive(mobile: 100, desktop: 120),
        height: context.responsive(mobile: 100, desktop: 120),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          Icons.engineering_outlined,
          size: context.responsive(mobile: 50, desktop: 60),
          color: Colors.purple,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 32),
        height: context.responsive(mobile: 24, desktop: 0),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ustamızın Geçmişi ve Yetenekleri',
              style: TextStyle(
                fontSize: context.responsive(mobile: 22, desktop: 28),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Ustamız, 1992 yılından beri bu sektörde aktif olarak çalışmaktadır. "
              "Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir. "
              "Çalışma hayatı boyunca, sürücülük, taşıma, montaj, müşteri karşılama gibi birçok iş pozisyonunda görev alarak çok yönlü bir deneyim kazanmıştır.\n\n"
              "Özellikle 2010 yılına kadar İstikbal'de çalışmış ve bu süreçte ürünlerin özellikleri, parçaları ve püf noktaları hakkında derinlemesine bilgi sahibi olmuştur. "
              "2010'dan sonra, yakın civardaki Işık Çeyiz'de çalışarak sektördeki yetkinliğini artırmıştır.\n\n"
              "2012 yılında ise kendi esnaf dükkanını açma kararı almış ve bu süreçte kaliteli hizmet anlayışını ön planda tutarak, "
              "sektördeki deneyimlerini müşterilerine en iyi şekilde aktarmayı hedeflemiştir.",
              style: TextStyle(
                fontSize: context.responsive(mobile: 15, desktop: 16),
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: context.responsive<Widget>(
          mobile: Column(children: children),
          desktop: Row(children: children),
        ),
      ),
    );
  }

  // Taşıma Hizmeti
  Widget _buildDeliveryService(final BuildContext context) {
    final children = [
      Container(
        width: context.responsive(mobile: 100, desktop: 120),
        height: context.responsive(mobile: 100, desktop: 120),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          Icons.local_shipping_outlined,
          size: context.responsive(mobile: 50, desktop: 60),
          color: Colors.orange,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 32),
        height: context.responsive(mobile: 24, desktop: 0),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Taşıma Hizmeti',
              style: TextStyle(
                fontSize: context.responsive(mobile: 22, desktop: 28),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ücretsiz Teslimat',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Hizmet Verilen Bölgeler:',
              style: TextStyle(
                fontSize: context.responsive(mobile: 15, desktop: 16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• İçerenköy Mahallesi\n• İçerenköy Mahallesi yakın çevreleri',
              style: TextStyle(
                fontSize: context.responsive(mobile: 15, desktop: 16),
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '⏰ Teslimat Saatleri: 09:00 - 22:00',
              style: TextStyle(
                fontSize: context.responsive(mobile: 14, desktop: 14),
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    ];
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: context.responsive<Widget>(
          mobile: Column(children: children),
          desktop: Row(children: children),
        ),
      ),
    );
  }

  // Ulaşım Bilgileri
  Widget _buildTransportationInfo(final BuildContext context) {
    final children = [
      Container(
        width: context.responsive(mobile: 100, desktop: 120),
        height: context.responsive(mobile: 100, desktop: 120),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          Icons.directions_bus_outlined,
          size: context.responsive(mobile: 50, desktop: 60),
          color: Colors.green,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 32),
        height: context.responsive(mobile: 24, desktop: 0),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ulaşım',
              style: TextStyle(
                fontSize: context.responsive(mobile: 22, desktop: 28),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Otobüs Hatları ve Durakları:',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildBusInfo(
              context,
              'Ziyapaşa Durağı Kadıköy Yönü:',
              '19, 19F, 19FB, 14KS, 18UK, KM46-1',
            ),
            _buildBusInfo(
              context,
              'İçerenköy Durağı Kayışdağı Yönü:',
              '19, 19F, 19FB, 14KS, 18UK, KM46-1',
            ),
            _buildBusInfo(
              context,
              'İçerenköy Durağı Yeniyol\'dan:',
              '10, 319, KM46, 13AB, 14T',
            ),
          ],
        ),
      ),
    ];
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: context.responsive<Widget>(
          mobile: Column(children: children),
          desktop: Row(children: children),
        ),
      ),
    );
  }

  Widget _buildBusInfo(
      final BuildContext context, final String route, final String buses) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route,
            style: TextStyle(
              fontSize: context.responsive(mobile: 15, desktop: 16),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            buses,
            style: TextStyle(
              fontSize: context.responsive(mobile: 14, desktop: 15),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Team Section
  Widget _buildTeamSection(final BuildContext context) {
    final children = [
      Expanded(
        child: _buildTeamMember(
          context,
          'Ahmet Yılmaz',
          'Kurucu & CEO',
          Icons.person_outline,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 24),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildTeamMember(
          context,
          'Ayşe Demir',
          'Satış Müdürü',
          Icons.person_outline,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 24),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildTeamMember(
          context,
          'Mehmet Kaya',
          'Lojistik Sorumlusu',
          Icons.person_outline,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 24),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildTeamMember(
          context,
          'Zeynep Şahin',
          'Müşteri İlişkileri',
          Icons.person_outline,
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        child: Column(
          children: [
            Text(
              'Ekibimiz',
              style: TextStyle(
                fontSize: context.responsive(mobile: 28, desktop: 42),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Uzman ve deneyimli kadromuzla hizmetinizdeyiz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            context.responsive<Widget>(
              mobile: Column(children: children),
              desktop: Row(children: children),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(
    final BuildContext context,
    final String name,
    final String role,
    final IconData icon,
  ) {
    return Container(
      padding: context.responsive(
        mobile: const EdgeInsets.all(24),
        desktop: const EdgeInsets.all(32),
      ),
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
            width: context.responsive(mobile: 100, desktop: 120),
            height: context.responsive(mobile: 100, desktop: 120),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: context.responsive(mobile: 50, desktop: 60),
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: TextStyle(
              fontSize: context.responsive(mobile: 18, desktop: 20),
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

  // Contact Info
  Widget _buildContactSection(final BuildContext context) {
    final items = [
      Expanded(
        child: _buildContactItem(
          context,
          Icons.phone_outlined,
          'Telefon',
          '+90 553 920 1996',
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 32),
        height: context.responsive(mobile: 24, desktop: 0),
      ),
      Expanded(
        child: _buildContactItem(
          context,
          Icons.location_on_outlined,
          'Adres',
          'İçerenköy Mahallesi',
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 32),
        height: context.responsive(mobile: 24, desktop: 0),
      ),
      Expanded(
        child: _buildContactItem(
          context,
          Icons.access_time_outlined,
          'Çalışma Saatleri',
          'Pzt-Cmt: 09:00-22:00\nPazar: 10:00-18:00',
        ),
      ),
    ];

    final buttons = [
      FilledButton(
        onPressed: () => _launchPhone(),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          padding: context.responsive(
            mobile: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone),
            const SizedBox(width: 8),
            Text(
              'Hemen Ara',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 16),
        height: context.responsive(mobile: 12, desktop: 0),
      ),
      OutlinedButton(
        onPressed: () => _launchMaps(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white),
          padding: context.responsive(
            mobile: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map),
            const SizedBox(width: 8),
            Text(
              'Haritada Gör',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
        ),
        child: Column(
          children: [
            Text(
              'İletişim Bilgilerimiz',
              style: TextStyle(
                fontSize: context.responsive(mobile: 28, desktop: 42),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            context.responsive<Widget>(
              mobile: Column(children: items),
              desktop: Row(children: items),
            ),
            const SizedBox(height: 40),
            context.responsive<Widget>(
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buttons,
              ),
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttons,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    final BuildContext context,
    final IconData icon,
    final String label,
    final String value,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: context.responsive(mobile: 32, desktop: 40),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: TextStyle(
            fontSize: context.responsive(mobile: 15, desktop: 16),
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Map Section
  Widget _buildMapSection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        height: context.responsive(mobile: 300, desktop: 400),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
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
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          child: GestureDetector(
            onTap: () => _launchMaps(),
            child: Container(
              color: AppColors.background,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: context.responsive(mobile: 60, desktop: 80),
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mağaza Konumumuz',
                      style: TextStyle(
                        fontSize: context.responsive(mobile: 18, desktop: 20),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Haritayı görüntülemek için tıklayın',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchPhone() async {
    final phoneNumber = Uri.parse('tel:+905539201996');
    if (await canLaunchUrl(phoneNumber)) {
      await launchUrl(phoneNumber);
    }
  }

  void _launchMaps() async {
    final mapsUrl = Uri.parse(
        'https://www.google.com/maps/place/Sa%C4%9Flam+Spot/@40.9699248,29.1146853,21z/data=!4m6!3m5!1s0x14cac64216b4ccb7:0x49124944b40496f6!8m2!3d40.9699196!4d29.1148379!16s%2Fg%2F11dxc20095?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D');
    if (await canLaunchUrl(mapsUrl)) {
      await launchUrl(mapsUrl);
    }
  }
}
