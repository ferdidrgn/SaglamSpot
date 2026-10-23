import 'package:flutter/material.dart';
import '../../core/common/extentions/app_context_ui_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/util/comminucation_actions.dart';
import '../../features/home/presentation/widgets/home_page_footer_widgets.dart';
import '../navigation/widgets/nav_handler.dart';

/// Tüm web sayfalarında (Ana Sayfa, Yeni, Spot…) tutarlı, tek paylaşılan
/// footer. Önceden bu içerik yalnızca ana sayfaya özel, private bir widget'tı
/// — /new ve /spot sayfalarının hiç footer'ı yoktu, bu yüzden o sayfalardan
/// iletişim bilgilerine, mağaza adresine ve Gizlilik Politikası/Kullanım
/// Şartları'na HİÇ erişilemiyordu (yalnızca ana sayfadan). Davranış/görünüm
/// ana sayfadaki eski footer'la birebir aynı — yalnızca paylaşılabilir bir
/// widget'a taşındı.
class SiteFooter extends StatelessWidget {
  const SiteFooter();

  @override
  Widget build(final BuildContext context) {
    final double horizontalPad = context.responsive(
        mobile: 16.0, tablet: 24.0, desktop: 28.0, largeDesktop: 32.0);

    return Container(
      color: AppColors.backgroundDark,
      child: Column(
        children: [
          const HazardStripeBar(),
          Container(
            padding:
                EdgeInsets.fromLTRB(horizontalPad, 56, horizontalPad, 32),
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 40,
                  runSpacing: 42,
                  children: [
                    SizedBox(
                      width: context.responsive(
                          mobile: double.infinity, desktop: 260),
                      child: Column(
                        crossAxisAlignment: context.isMobile
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.storefront_rounded,
                                  color: AppColors.accentLight, size: 20),
                              const SizedBox(width: 8),
                              Text(context.l10n.brand,
                                  style: const TextStyle(
                                      fontFamily: 'Fraunces',
                                      color: Colors.white,
                                      fontSize: 22,
                                      letterSpacing: 3,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.footerDesc,
                            textAlign: context.isMobile
                                ? TextAlign.center
                                : TextAlign.start,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 13,
                                height: 1.6),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FooterSocialIcon(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  onTap:
                                      SaglamSpotCommunication.launchWhatsApp),
                              const SizedBox(width: 10),
                              FooterSocialIcon(
                                  icon: Icons.camera_alt_outlined,
                                  onTap:
                                      SaglamSpotCommunication.openInstagram),
                              const SizedBox(width: 10),
                              FooterSocialIcon(
                                  icon: Icons.facebook,
                                  onTap:
                                      SaglamSpotCommunication.openFacebook),
                              const SizedBox(width: 10),
                              FooterSocialIcon(
                                  icon: Icons.call_outlined,
                                  onTap: SaglamSpotCommunication.makeCall),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _footerColumn(context, context.l10n.explore, {
                      context.l10n.home: () =>
                          NavigationHandler.goToHome(context),
                      context.l10n.collections: () =>
                          NavigationHandler.goToSearch(context),
                      context.l10n.spotProducts: () =>
                          NavigationHandler.goToSpotProducts(context),
                      context.l10n.aboutUs: () =>
                          NavigationHandler.goToAbout(context),
                    }),
                    _footerColumn(context, context.l10n.contact, {
                      SaglamSpotCommunication.displayPhone:
                          SaglamSpotCommunication.makeCall,
                      context.l10n.whatsappCta:
                          SaglamSpotCommunication.launchWhatsApp,
                      context.l10n.storeAddress:
                          SaglamSpotCommunication.openStoreLocation,
                      context.l10n.sss: () =>
                          NavigationHandler.goToSSS(context),
                    }),
                    SizedBox(
                      width: context.responsive(
                          mobile: double.infinity, desktop: 260),
                      child: const FooterLocationCard(),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Container(height: 1, color: Colors.white.withOpacity(0.08)),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 10,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 18,
                      runSpacing: 6,
                      children: [
                        Text(context.l10n.allRightsReserved,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.15),
                                fontSize: 10)),
                        // Google AdSense ve benzeri incelemeler bu iki
                        // bağlantının HER sayfadan erişilebilir olmasını
                        // bekler — rotalar (/privacy, /terms) zaten vardı,
                        // yalnızca bu widget'ın eskiden olmadığı /new ve
                        // /spot sayfalarından hiç bağlı değillerdi.
                        _footerLegalLink(
                          context.l10n.settingsPrivacyPolicy,
                          () => NavigationHandler.goToPrivacyPolicy(context),
                        ),
                        _footerLegalLink(
                          context.l10n.settingsTerms,
                          () => NavigationHandler.goToTerms(context),
                        ),
                      ],
                    ),
                    Text(
                      context.l10n.footerWarehouseTagline,
                      style: AppTextStyles.microLabel(
                          fontSize: 9.5,
                          letterSpacing: 1.6,
                          color: Colors.white.withOpacity(0.15)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLegalLink(final String label, final VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        child: Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.25),
                fontSize: 10,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white.withOpacity(0.2))),
      );

  Widget _footerColumn(final BuildContext context, final String title,
          final Map<String, VoidCallback> items) =>
      SizedBox(
        width: context.responsive(mobile: context.wp(40), desktop: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(),
                style: AppTextStyles.microLabel(
                    fontSize: 11.5,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 25),
            ...items.entries.map((final entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: entry.value,
                    child: Text(entry.key,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 13)),
                  ),
                )),
          ],
        ),
      );
}
