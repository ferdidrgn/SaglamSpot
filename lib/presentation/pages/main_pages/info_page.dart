import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero Section - SENİN VERİLERİNLE GÜNCELLENDİ
        _buildHeroSection(),

        // Our Story - SENİN VERİLERİNLE GÜNCELLENDİ
        _buildOurStory(),

        // Our Values - AYNI KALDI
        _buildOurValues(),

        // Ustamızın Geçmişi - YENİ EKLENDİ
        _buildMasterHistory(),

        // Taşıma Hizmeti - YENİ EKLENDİ
        _buildDeliveryService(),

        // Ulaşım Bilgileri - YENİ EKLENDİ
        _buildTransportationInfo(),

        // Team Section - AYNI KALDI
        _buildTeamSection(),

        // Contact Info - SENİN VERİLERİNLE GÜNCELLENDİ
        _buildContactSection(),

        // Map Section - SENİN VERİLERİNLE GÜNCELLENDİ
        _buildMapSection(),

        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }

  // Hero Section - SENİN VERİLERİNLE
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
                Icons.storefront_outlined,
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
                      '20 YILLIK ESNAF',
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
                    'Sağlam Spot\nGüvenin Adresi',
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
                    '1992\'den beri kalite ve güven odaklı hizmet\nanlayışımızla yanınızdayız.',
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

  // Our Story - SENİN VERİLERİNLE GÜNCELLENDİ
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
                    color: Colors.brown.withOpacity(0.1), // SENİN RENGİN
                    child: const Center(
                      child: Icon(
                        Icons.store,
                        size: 120,
                        color: Colors.brown, // SENİN RENGİN
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
                    'İş Yeri Bilgileri', // SENİN BAŞLIĞIN
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Müşterilerimize en kaliteli ve şık mobilya çözümleri sunarak, yaşam alanlarını daha konforlu ve estetik hale getiriyoruz.', // SENİN İÇERİĞİN
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '1992 yılında küçük bir atölye olarak başladık. Mobilya sektöründe kalite ve müşteri memnuniyeti odaklı yaklaşımımızla kısa sürede büyüdük.',
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
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      _buildStoryHighlight('1992', 'Kuruluş'), // SENİN TARİHİN
                      const SizedBox(width: 32),
                      _buildStoryHighlight('30+', 'Yıllık Deneyim'), // SENİN DENEYİMİN
                      const SizedBox(width: 32),
                      _buildStoryHighlight('5K+', 'Mutlu Müşteri'),
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

  // Our Values - AYNI KALDI (Değişmedi)
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

  // Ustamızın Geçmişi - YENİ EKLENDİ (SENİN VERİLERİN)
  Widget _buildMasterHistory() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1), // SENİN RENGİN
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.purple.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.engineering_outlined,
                size: 60,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ustamızın Geçmişi ve Yetenekleri', // SENİN BAŞLIĞIN
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Ustamız, 1992 yılından beri bu sektörde aktif olarak çalışmaktadır. "
                        "Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir. "
                        "Çalışma hayatı boyunca, sürücülük, taşıma, montaj, müşteri karşılama gibi birçok iş pozisyonunda görev alarak çok yönlü bir deneyim kazanmıştır.\n\n"
                        "Özellikle 2010 yılına kadar İstikbal'de çalışmış ve bu süreçte ürünlerin özellikleri, parçaları ve püf noktaları hakkında derinlemesine bilgi sahibi olmuştur. "
                        "2010'dan sonra, yakın civardaki Işık Çeyiz'de çalışarak sektördeki yetkinliğini artırmıştır.\n\n"
                        "2012 yılında ise kendi esnaf dükkanını açma kararı almış ve bu süreçte kaliteli hizmet anlayışını ön planda tutarak, "
                        "sektördeki deneyimlerini müşterilerine en iyi şekilde aktarmayı hedeflemiştir.", // SENİN İÇERİĞİN
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.7,
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

  // Taşıma Hizmeti - YENİ EKLENDİ (SENİN VERİLERİN)
  Widget _buildDeliveryService() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1), // SENİN RENGİN
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.local_shipping_outlined,
                size: 60,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Taşıma Hizmeti', // SENİN BAŞLIĞIN
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ücretsiz Teslimat',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hizmet Verilen Bölgeler:', // SENİN İÇERİĞİN
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• İçerenköy Mahallesi\n• İçerenköy Mahallesi yakın çevreleri', // SENİN İÇERİĞİN
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '⏰ Teslimat Saatleri: 09:00 - 22:00',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary,
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

  // Ulaşım Bilgileri - YENİ EKLENDİ (SENİN VERİLERİN)
  Widget _buildTransportationInfo() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1), // SENİN RENGİN
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.directions_bus_outlined,
                size: 60,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ulaşım', // SENİN BAŞLIĞIN
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Otobüs Hatları ve Durakları:', // SENİN İÇERİĞİN
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBusInfo('Ziyapaşa Durağı Kadıköy Yönü:', '19, 19F, 19FB, 14KS, 18UK, KM46-1'),
                  _buildBusInfo('İçerenköy Durağı Kayışdağı Yönü:', '19, 19F, 19FB, 14KS, 18UK, KM46-1'),
                  _buildBusInfo('İçerenköy Durağı Yeniyol\'dan:', '10, 319, KM46, 13AB, 14T'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusInfo(final String route, final String buses) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            buses,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Team Section - AYNI KALDI (Değişmedi)
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

  // Contact Info - SENİN VERİLERİNLE GÜNCELLENDİ
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
                    '+90 553 920 1996', // SENİN TELEFONUN
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildContactItem(
                    Icons.location_on_outlined,
                    'Adres',
                    'İçerenköy Mahallesi', // SENİN ADRESİN
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildContactItem(
                    Icons.access_time_outlined,
                    'Çalışma Saatleri',
                    'Pzt-Cmt: 09:00-22:00\nPazar: 10:00-18:00', // SENİN SAATLERİN
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () => _launchPhone(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 8),
                      Text(
                        'Hemen Ara',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => _launchMaps(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.map),
                      SizedBox(width: 8),
                      Text(
                        'Haritada Gör',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  // Map Section - SENİN VERİLERİNLE GÜNCELLENDİ
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
          child: GestureDetector(
            onTap: () => _launchMaps(),
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
                      'Mağaza Konumumuz',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
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
    const phoneNumber = 'tel:+905539201996';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    }
  }

  void _launchMaps() async {
    const mapsUrl = 'https://www.google.com/maps/place/Sa%C4%9Flam+Spot/@40.9699248,29.1146853,21z/data=!4m6!3m5!1s0x14cac64216b4ccb7:0x49124944b40496f6!8m2!3d40.9699196!4d29.1148379!16s%2Fg%2F11dxc20095?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D';
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    }
  }
}