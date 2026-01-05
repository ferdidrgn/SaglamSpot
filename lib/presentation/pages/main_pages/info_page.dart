import 'package:flutter/material.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  @override
  Widget build(final BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeroSection(context),
        _buildOurStory(context),
        _buildOurValues(context),
        _buildMasterHistory(context),
        _buildDeliveryService(context),
        _buildTransportationInfo(context),
        _buildContactSection(context),
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
                      '2012\'DEN BERİ SİZİNLE',
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
                    'Sağlam Spot\nBildiğiniz Güven',
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
                    'İşimizi sevgi ve titizlikle yaparak\nmahallemize hizmet veriyoruz.',
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

  Widget _buildOurStory(final BuildContext context) {
    final imageWidget = Container(
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
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biz Kimiz? (Hikayemiz)',
          style: TextStyle(
            fontSize: context.responsive(mobile: 28, desktop: 42),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Amacımız, evinize sıcaklık katacak, kaliteli ve içinize sinen mobilyaları bulmanıza yardımcı olmak. Yaşam alanlarınızı güzelleştirmek bizim işimiz.',
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Her şey 2012\'de, İçerenköy\'deki bu dükkanda başladı. O günden beri konuk olduğumuz ev sayısı daha da arttı.',
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Bugün, hem sıfır hem de özenle seçtiğimiz ikinci el ürünlerimizle, binlerce komşumuzun evine konuk olduk. Sizin güveninizle büyüyoruz.',
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
            _buildStoryHighlight('2012', 'Başlangıç'),
            _buildStoryHighlight('30+', 'Yıllık Tecrübe'),
            _buildStoryHighlight('5K+', 'Gülen Yüz'),
          ],
        ),
      ],
    );

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        child: context.responsive<Widget>(
          mobile: Column(
            children: [
              imageWidget,
              const SizedBox(height: 24),
              textWidget,
            ],
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: imageWidget),
              const SizedBox(width: 48),
              Expanded(child: textWidget),
            ],
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

  Widget _buildOurValues(final BuildContext context) {
    final value1 = _buildValueCard(
      context,
      Icons.verified_outlined,
      'Kalite ve Titizlik',
      'İster sıfır ister ikinci el olsun titizlikle seçer, size öyle sunarız.',
      AppColors.primary,
    );
    final value2 = _buildValueCard(
      context,
      Icons.favorite_outline,
      'Gülen Yüz',
      'Bizim için en büyük kazanç, dükkandan mutlu ayrılan bir komşumuzdur. Memnuniyetiniz her şeyden önce gelir.',
      AppColors.secondary,
    );
    final value3 = _buildValueCard(
      context,
      Icons.eco_outlined,
      'Emeğe Saygı',
      'Mobilya kıymetli bir emektir. İkinci el ürünlere yeniden hayat vererek hem bütçenizi hem de doğayı koruruz.',
      AppColors.success,
    );
    final value4 = _buildValueCard(
      context,
      Icons.handshake_outlined,
      'Dürüstlük ve Güven',
      'Şeffaf ve dürüst esnaflık en büyük değerimizdir. Yıllardır aynı konumumuzda sizlerle birlikteyiz.',
      AppColors.info,
    );

    final childrenDesktop = [
      Expanded(child: value1),
      SizedBox(width: context.responsive(mobile: 0, desktop: 24)),
      Expanded(child: value2),
      SizedBox(width: context.responsive(mobile: 0, desktop: 24)),
      Expanded(child: value3),
      SizedBox(width: context.responsive(mobile: 0, desktop: 24)),
      Expanded(child: value4),
    ];

    final childrenMobile = [
      value1,
      SizedBox(height: context.responsive(mobile: 16, desktop: 0)),
      value2,
      SizedBox(height: context.responsive(mobile: 16, desktop: 0)),
      value3,
      SizedBox(height: context.responsive(mobile: 16, desktop: 0)),
      value4,
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
              'İlkelerimiz',
              style: TextStyle(
                fontSize: context.responsive(mobile: 28, desktop: 42),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Esnaflıktan ödün vermediğimiz prensiplerimiz',
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            context.responsive<Widget>(
              mobile: Column(children: childrenMobile),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: childrenDesktop,
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

  // Ustamızın Geçmişi - DÜZELTİLDİ
  Widget _buildMasterHistory(final BuildContext context) {
    final iconWidget = Container(
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
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ustamızı Tanıyın',
          style: TextStyle(
            fontSize: context.responsive(mobile: 22, desktop: 28),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Ustamız, 1995\'ten beri, yani çeyrek asırdan fazladır bu işin içinde. Sektörün tozunu yutmuş, en iyi markalarda (İstikbal) çalışarak mobilyanın 'püf noktalarını' öğrenmiş biridir.\n\n"
          "Sürücülükten montaja, müşteri karşılamadan taşımaya kadar her alanda bizzat çalışarak tam bir tecrübe kazanmıştır. 2012'de ise 'artık kendi dükkanım' diyerek bu tecrübesini Sağlam Spot'a taşımıştır.\n\n"
          "Amacı, o büyük firmalarda öğrendiği kaliteyi, mahalle esnafının samimiyeti ve titizliğiyle birleştirip size en iyi hizmeti sunmaktır.",
          style: TextStyle(
            fontSize: context.responsive(mobile: 15, desktop: 16),
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),
      ],
    );

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
          mobile: Column(
            children: [
              iconWidget,
              const SizedBox(height: 24),
              textWidget,
            ],
          ),
          desktop: Row(
            children: [
              iconWidget,
              const SizedBox(width: 32),
              Expanded(child: textWidget),
            ],
          ),
        ),
      ),
    );
  }

  // Taşıma Hizmeti - DÜZELTİLDİ
  Widget _buildDeliveryService(final BuildContext context) {
    final iconWidget = Container(
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
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nakliye ve Montaj Hizmetimiz',
          style: TextStyle(
            fontSize: context.responsive(mobile: 22, desktop: 28),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ücretsiz Nakliye ve Montaj',
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            color: Colors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Ücretsiz Hizmet Bölgelerimiz:',
          style: TextStyle(
            fontSize: context.responsive(mobile: 15, desktop: 16),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '• İçerenköy Mahallemiz\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• İnönü ve Bostancı Sanayi gibi yakın komşularımız',
          style: TextStyle(
            fontSize: context.responsive(mobile: 15, desktop: 16),
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Önemli Not: Ustamızın sağlığını korumak için, asansör olmayan binalarda yüksek katlara maalesef hizmet veremiyoruz. Anlayışınız için teşekkür ederiz.',
          style: TextStyle(
            fontSize: context.responsive(mobile: 14, desktop: 15),
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '⏰ Sizinle sözleştiğimiz saatte kapınızdayız!',
          style: TextStyle(
            fontSize: context.responsive(mobile: 14, desktop: 14),
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );

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
          mobile: Column(children: [
            iconWidget,
            const SizedBox(height: 24),
            textWidget,
          ]),
          desktop: Row(children: [
            iconWidget,
            const SizedBox(width: 32),
            Expanded(child: textWidget),
          ]),
        ),
      ),
    );
  }

  // Ulaşım Bilgileri - DÜZELTİLDİ
  Widget _buildTransportationInfo(final BuildContext context) {
    final iconWidget = Container(
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
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dükkanımıza Nasıl Gelirsiniz?',
          style: TextStyle(
            fontSize: context.responsive(mobile: 22, desktop: 28),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Otobüsle Gelirseniz:',
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildBusInfo(
          context,
          'Ziyapaşa Durağı (Kadıköy Yönü):',
          '19, 19F, 19FB, 14KS, 18UK, KM46-1',
        ),
        _buildBusInfo(
          context,
          'İçerenköy Durağı (Kayışdağı Yönü):',
          '19, 19F, 19FB, 14KS, 18UK, KM46-1',
        ),
        _buildBusInfo(
          context,
          'İçerenköy Durağı (Yeniyol):',
          '10, 319, KM46, 13AB, 14T',
        ),
      ],
    );

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
          mobile: Column(children: [
            iconWidget,
            const SizedBox(height: 24),
            textWidget,
          ]),
          desktop: Row(children: [
            iconWidget,
            const SizedBox(width: 32),
            Expanded(child: textWidget),
          ]),
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

  Widget _buildContactSection(final BuildContext context) {
    final item1 = _buildContactItem(
      context,
      Icons.phone_outlined,
      'Telefon (Hızlı Çözüm)',
      '+90 539 201 9961',
    );
    final item2 = _buildContactItem(
      context,
      Icons.location_on_outlined,
      'Adres (Çaya Bekleriz)',
      'İçerenköy Mahallesi\nBuket Sokak No:6',
    );
    final item3 = _buildContactItem(
      context,
      Icons.access_time_outlined,
      'Çalışma Saatlerimiz',
      'Pzt-Cmt: 09:00 - 22:00\nPazar: 10:00 - 20:00',
    );

    final itemsDesktop = [
      Expanded(child: item1),
      SizedBox(width: context.responsive(mobile: 0, desktop: 32)),
      Expanded(child: item2),
      SizedBox(width: context.responsive(mobile: 0, desktop: 32)),
      Expanded(child: item3),
    ];

    final itemsMobile = [
      item1,
      SizedBox(height: context.responsive(mobile: 24, desktop: 0)),
      item2,
      SizedBox(height: context.responsive(mobile: 24, desktop: 0)),
      item3,
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
              'Bize Ulaşın',
              style: TextStyle(
                fontSize: context.responsive(mobile: 28, desktop: 42),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            context.responsive<Widget>(
              mobile: Column(children: itemsMobile),
              desktop: Row(children: itemsDesktop),
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
                      'Dükkanımız Tam Burada',
                      style: TextStyle(
                        fontSize: context.responsive(mobile: 18, desktop: 20),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Yol tarifi almak için haritaya dokunun',
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

  Future<void> _launchPhone() async {
    final phoneNumber = Uri.parse('tel:+905392019961');
    if (await canLaunchUrl(phoneNumber)) await launchUrl(phoneNumber);
  }

  Future<void> _launchMaps() async {
    final mapsUrl = Uri.parse(
        'https://www.google.com/maps/place/Sa%C4%9Flam+Spot/@40.9699248,29.1146853,21z/data=!4m6!3m5!1s0x14cac64216b4ccb7:0x49124944b40496f6!8m2!3d40.9699196!4d29.1148379!16s%2Fg%2F11dxc20095?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D');
    if (await canLaunchUrl(mapsUrl)) await launchUrl(mapsUrl);
  }
}
