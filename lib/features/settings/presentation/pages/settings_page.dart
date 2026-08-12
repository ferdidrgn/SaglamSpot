import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/deeplink/deeplink_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';

/// Profil / Ayarlar sayfası. Uygulamada müşteri hesap sistemi yok —
/// bu yüzden giriş/kayıt gerektirmez; dil, iletişim, kurumsal sayfalar
/// (Hakkımızda/SSS), yasal metinler ve uygulama değerlendirme/paylaşım
/// erişimi sağlar.
///
/// GÜVENLİK NOTU: "Yönetici Girişi" burada ARTIK GÖRÜNÜR bir buton değil
/// — herkese açık bir sayfada admin girişini öne çıkarmak istenmeyen bir
/// hedef oluşturur. Zaten oturum açmış bir yönetici için küçük bir "Panele
/// Dön" kısayolu gösterilir; oturum yoksa girişe ulaşmanın tek yolu alt
/// bilgideki sürüm metnine UZUN BASMAK (bkz. _AppVersionFooter).
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final bool isAdminLoggedIn = authState.value != null && !authState.isLoading;

    final scaffold = Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: !kIsWeb ? const MobileBottomNav() : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text(
              context.l10n.settingsTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.mobileTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileHeader(context),
            const SizedBox(height: 28),
            _SectionLabel(context.l10n.settingsAccountSection),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                const _LanguageTile(),
                if (isAdminLoggedIn)
                  _SettingsTile(
                    icon: Icons.admin_panel_settings_rounded,
                    label: context.l10n.settingsAdminLogin,
                    onTap: () => NavigationHandler.goToAdmin(context),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionLabel(context.l10n.settingsGeneralSection),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.storefront_rounded,
                  label: context.l10n.aboutUs,
                  onTap: () => NavigationHandler.goToAbout(context),
                ),
                _SettingsTile(
                  icon: Icons.quiz_rounded,
                  label: context.l10n.sss,
                  onTap: () => NavigationHandler.goToSSS(context),
                ),
                _SettingsTile(
                  icon: Icons.call_rounded,
                  label: context.l10n.settingsCallUs,
                  onTap: SaglamSpotCommunication.makeCall,
                ),
                _SettingsTile(
                  icon: Icons.chat_bubble_rounded,
                  label: context.l10n.whatsappCta,
                  onTap: () => SaglamSpotCommunication.launchWhatsApp(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionLabel(context.l10n.settingsAppSection),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.star_rounded,
                  label: context.l10n.settingsRateApp,
                  onTap: FurnitureShareService.openStoreListingForReview,
                ),
                _SettingsTile(
                  icon: Icons.ios_share_rounded,
                  label: context.l10n.settingsShareApp,
                  onTap: FurnitureShareService.shareApp,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionLabel(context.l10n.settingsLegalSection),
            const SizedBox(height: 10),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.privacy_tip_rounded,
                  label: context.l10n.settingsPrivacyPolicy,
                  onTap: () => NavigationHandler.goToPrivacyPolicy(context),
                ),
                _SettingsTile(
                  icon: Icons.description_rounded,
                  label: context.l10n.settingsTerms,
                  onTap: () => NavigationHandler.goToTerms(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const _AppVersionFooter(),
          ],
        ),
      ),
    );

    return kIsWeb ? scaffold : BackToHomeGuard(child: scaffold);
  }

  Widget _buildProfileHeader(final BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.mobilePrimaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.brand,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    SaglamSpotCommunication.displayPhone,
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(final BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
          color: AppColors.mobileTextTertiary,
        ),
      );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(final BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mobileBorder),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(height: 1, color: AppColors.mobileBorder, indent: 52),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: AppColors.mobilePrimary),
      title: Text(label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.mobileTextPrimary)),
      trailing: const Icon(Icons.chevron_right_rounded,
          size: 20, color: AppColors.mobileTextTertiary),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(final BuildContext context) => Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: const LanguageSelector(isDrawer: true),
      );
}

/// Sürüm metni — normal kullanıcılar için sade bir bilgi satırı. Buraya
/// UZUN BASMAK yönetici giriş sayfasını açar; bilerek keşfedilmesi zor,
/// ama yöneticinin bildiği bir "gizli kapı". ÖNEMLİ: zaten oturumu açık
/// bir yönetici içinse doğrudan panele (/admin) gider — /login'e gitmek
/// router'daki "zaten girişliyken login'e gidersen anasayfaya dön"
/// kuralına takılıp onu sessizce ana sayfaya geri fırlatırdı.
class _AppVersionFooter extends ConsumerWidget {
  const _AppVersionFooter();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authState = ref.read(authProvider);
    final bool isAdminLoggedIn = authState.value != null && !authState.isLoading;

    return Center(
        child: GestureDetector(
          onLongPress: () => isAdminLoggedIn
              ? NavigationHandler.goToAdmin(context)
              : NavigationHandler.goToLoginForAdmin(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (final context, final snapshot) {
                final String version = snapshot.hasData
                    ? '${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                    : '…';
                return Text(
                  '${context.l10n.settingsAppVersion}: $version',
                  style: const TextStyle(fontSize: 12, color: AppColors.mobileTextTertiary),
                );
              },
            ),
          ),
        ),
      );
  }
}
