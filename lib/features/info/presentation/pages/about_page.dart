import 'package:flutter/material.dart';
import 'package:saglamspot/core/common/enum/enums.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(final BuildContext context) {
    if (context.isMobile) return _buildMobileScaffold(context);

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
        const SliverToBoxAdapter(
            child: AdsenseBanner(height: 100, type: AdUnitType.multiplex)),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // MOBİL TASARIM — teal/sage paleti, gerçek Scaffold + geri butonu +
  // alt navigasyon çubuğu, tek-sütun kompakt kart düzeni.
  // ════════════════════════════════════════════════════════════

  Widget _buildMobileScaffold(final BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _buildMobileHeader(context),
            const SizedBox(height: 12),
            _buildMobileHero(context),
            const SizedBox(height: 20),
            _MobileSection(
              icon: Icons.auto_stories_rounded,
              iconColor: AppColors.mobilePrimary,
              title: context.l10n.aboutStoryHeading,
              body:
                  '${context.l10n.aboutStoryPara1}\n\n${context.l10n.aboutStoryPara2}\n\n${context.l10n.aboutStoryPara3}',
            ),
            const SizedBox(height: 14),
            _buildMobileValues(context),
            const SizedBox(height: 14),
            _MobileSection(
              icon: Icons.engineering_rounded,
              iconColor: AppColors.mobileAccentDark,
              title: context.l10n.aboutMasterHeading,
              body: context.l10n.aboutMasterBody,
            ),
            const SizedBox(height: 14),
            _MobileSection(
              icon: Icons.local_shipping_rounded,
              iconColor: AppColors.mobilePrimary,
              title: context.l10n.aboutDeliveryHeading,
              body:
                  '${context.l10n.aboutDeliveryFreeTitle}\n\n${context.l10n.aboutDeliveryZonesLabel}: ${context.l10n.aboutDeliveryZonesList}\n\n${context.l10n.aboutDeliveryNote}',
            ),
            const SizedBox(height: 14),
            _MobileSection(
              icon: Icons.directions_bus_rounded,
              iconColor: AppColors.mobileAccentDark,
              title: context.l10n.aboutTransportHeading,
              body:
                  '${context.l10n.aboutBusStop1}: 19, 19F, 19FB, 14KS, 18UK, KM46-1\n'
                  '${context.l10n.aboutBusStop2}: 19, 19F, 19FB, 14KS, 18UK, KM46-1\n'
                  '${context.l10n.aboutBusStop3}: 10, 319, KM46, 13AB, 14T',
            ),
            const SizedBox(height: 18),
            _buildMobileContactCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader(final BuildContext context) => Row(
        children: [
          IconButton(
            onPressed: () => NavigationHandler.smartGoBack(context),
            icon: Icon(Icons.arrow_back_rounded, color: AppColors.mobileTextPrimary),
          ),
          Expanded(
            child: Text(
              context.l10n.aboutHeroTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.mobileTextPrimary,
              ),
            ),
          ),
        ],
      );

  Widget _buildMobileHero(final BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.mobilePrimaryGradient,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                context.l10n.aboutBadge,
                style: const TextStyle(
                    color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              context.l10n.aboutHeroSubtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
          ],
        ),
      );

  Widget _buildMobileValues(final BuildContext context) {
    final values = [
      (Icons.verified_rounded, context.l10n.aboutValue1Title, context.l10n.aboutValue1Desc),
      (Icons.favorite_rounded, context.l10n.aboutValue2Title, context.l10n.aboutValue2Desc),
      (Icons.eco_rounded, context.l10n.aboutValue3Title, context.l10n.aboutValue3Desc),
      (Icons.handshake_rounded, context.l10n.aboutValue4Title, context.l10n.aboutValue4Desc),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.mobileBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.aboutValuesHeading,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.mobileTextPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.aboutValuesSubheading,
            style: TextStyle(fontSize: 12.5, color: AppColors.mobileTextSecondary),
          ),
          const SizedBox(height: 14),
          for (final v in values)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.mobileCardBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(v.$1, size: 18, color: AppColors.mobilePrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.$2,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(v.$3,
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mobileTextSecondary,
                                height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileContactCard(final BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.mobileBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.aboutContactHeading,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.mobileTextPrimary),
            ),
            const SizedBox(height: 14),
            _MobileContactRow(
              icon: Icons.location_on_rounded,
              label: context.l10n.aboutContactAddressLabel,
              value: context.l10n.aboutContactAddressValue,
              onTap: () => _launchMaps(),
            ),
            _MobileContactRow(
              icon: Icons.access_time_rounded,
              label: context.l10n.aboutContactHoursLabel,
              value: context.l10n.aboutContactHoursValue,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launchPhone(),
                    icon: const Icon(Icons.call_rounded, size: 16),
                    label: Text(context.l10n.aboutCallNowButton,
                        style: const TextStyle(fontSize: 12.5)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.mobilePrimary,
                      side: BorderSide(color: AppColors.mobilePrimary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchMaps(),
                    icon: const Icon(Icons.map_rounded, size: 16),
                    label: Text(context.l10n.aboutViewMapButton,
                        style: const TextStyle(fontSize: 12.5)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mobilePrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

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
          gradient: LinearGradient(
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
                      context.l10n.aboutBadge,
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
                    context.l10n.aboutHeroTitle,
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      color: Colors.white,
                      fontSize: context.responsive(mobile: 32, desktop: 52),
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.aboutHeroSubtitle,
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
          color: AppColors.accent.withOpacity(0.1),
          child: Center(
            child: Icon(
              Icons.store,
              size: 120,
              color: AppColors.accent,
            ),
          ),
        ),
      ),
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.aboutStoryHeading,
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: context.responsive(mobile: 28, desktop: 42),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.aboutStoryPara1,
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.aboutStoryPara2,
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.aboutStoryPara3,
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
            _buildStoryHighlight('2012', context.l10n.aboutStoryStartLabel),
            _buildStoryHighlight('30+', context.l10n.aboutStoryExperienceLabel),
            _buildStoryHighlight('5K+', context.l10n.aboutStorySmilesLabel),
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
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
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
      context.l10n.aboutValue1Title,
      context.l10n.aboutValue1Desc,
      AppColors.primary,
    );
    final value2 = _buildValueCard(
      context,
      Icons.favorite_outline,
      context.l10n.aboutValue2Title,
      context.l10n.aboutValue2Desc,
      AppColors.secondary,
    );
    final value3 = _buildValueCard(
      context,
      Icons.eco_outlined,
      context.l10n.aboutValue3Title,
      context.l10n.aboutValue3Desc,
      AppColors.success,
    );
    final value4 = _buildValueCard(
      context,
      Icons.handshake_outlined,
      context.l10n.aboutValue4Title,
      context.l10n.aboutValue4Desc,
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
              context.l10n.aboutValuesHeading,
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: context.responsive(mobile: 28, desktop: 42),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.aboutValuesSubheading,
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
        color: AppColors.accentDark.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        Icons.engineering_outlined,
        size: context.responsive(mobile: 50, desktop: 60),
        color: AppColors.accentDark,
      ),
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.aboutMasterHeading,
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: context.responsive(mobile: 22, desktop: 28),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.aboutMasterBody,
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
          color: AppColors.accentDark.withOpacity(0.08),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          border: Border.all(color: AppColors.accentDark.withOpacity(0.3)),
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
        color: AppColors.accent.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        Icons.local_shipping_outlined,
        size: context.responsive(mobile: 50, desktop: 60),
        color: AppColors.accent,
      ),
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.aboutDeliveryHeading,
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: context.responsive(mobile: 22, desktop: 28),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.aboutDeliveryFreeTitle,
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.aboutDeliveryZonesLabel,
          style: TextStyle(
            fontSize: context.responsive(mobile: 15, desktop: 16),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.aboutDeliveryZonesList,
          style: TextStyle(
            fontSize: context.responsive(mobile: 15, desktop: 16),
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.aboutDeliveryNote,
          style: TextStyle(
            fontSize: context.responsive(mobile: 14, desktop: 15),
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.aboutDeliveryPunctual,
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
          color: AppColors.accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
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
        color: AppColors.sage.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        Icons.directions_bus_outlined,
        size: context.responsive(mobile: 50, desktop: 60),
        color: AppColors.sage,
      ),
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.aboutTransportHeading,
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: context.responsive(mobile: 22, desktop: 28),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.aboutTransportBusIntro,
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildBusInfo(
          context,
          context.l10n.aboutBusStop1,
          '19, 19F, 19FB, 14KS, 18UK, KM46-1',
        ),
        _buildBusInfo(
          context,
          context.l10n.aboutBusStop2,
          '19, 19F, 19FB, 14KS, 18UK, KM46-1',
        ),
        _buildBusInfo(
          context,
          context.l10n.aboutBusStop3,
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
          color: AppColors.sage.withOpacity(0.08),
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          border: Border.all(color: AppColors.sage.withOpacity(0.3)),
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
      context.l10n.aboutContactPhoneLabel,
      '+90 539 201 9961',
    );
    final item2 = _buildContactItem(
      context,
      Icons.location_on_outlined,
      context.l10n.aboutContactAddressLabel,
      context.l10n.aboutContactAddressValue,
    );
    final item3 = _buildContactItem(
      context,
      Icons.access_time_outlined,
      context.l10n.aboutContactHoursLabel,
      context.l10n.aboutContactHoursValue,
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
              context.l10n.aboutCallNowButton,
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
              context.l10n.aboutViewMapButton,
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
              context.l10n.aboutContactHeading,
              style: TextStyle(
                fontFamily: 'Fraunces',
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
                      context.l10n.aboutMapHeading,
                      style: TextStyle(
                        fontSize: context.responsive(mobile: 18, desktop: 20),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.aboutMapSubtext,
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
    await SaglamSpotCommunication.makeCall();
  }

  Future<void> _launchMaps() async {
    await SaglamSpotCommunication.openStoreLocation();
  }
}

class _MobileSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  const _MobileSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  @override
  Widget build(final BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.mobileBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.mobileTextPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: TextStyle(
                  fontSize: 12.5, color: AppColors.mobileTextSecondary, height: 1.55),
            ),
          ],
        ),
      );
}

class _MobileContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _MobileContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: AppColors.mobilePrimary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 11.5, color: AppColors.mobileTextTertiary)),
                    const SizedBox(height: 2),
                    Text(value,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mobileTextPrimary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
