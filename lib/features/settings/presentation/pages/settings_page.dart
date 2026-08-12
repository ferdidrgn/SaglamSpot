import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// Profil / Ayarlar sayfası. Uygulamada müşteri hesap sistemi yok —
/// bu yüzden giriş/kayıt gerektirmez; dil, iletişim, kurumsal sayfalar
/// (Hakkımızda/SSS) ve yönetici girişine erişim sağlar.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String _appVersion = '1.0.0';

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
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
            Center(
              child: Text(
                '${context.l10n.settingsAppVersion}: $_appVersion',
                style: const TextStyle(fontSize: 12, color: AppColors.mobileTextTertiary),
              ),
            ),
          ],
        ),
      ),
    );
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
  Widget build(final BuildContext context) => Container(
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(final BuildContext context) => ListTile(
        onTap: onTap,
        leading: Icon(icon, size: 20, color: AppColors.mobilePrimary),
        title: Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right_rounded,
            size: 20, color: AppColors.mobileTextTertiary),
      );
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(final BuildContext context) => Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: const LanguageSelector(isDrawer: true),
      );
}
