import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/constants/app_constants.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';

/// Remote Config'teki `force_update_min_version` eşiği kurulu sürümden daha
/// YENİ olduğunda gösterilen, atlanamayan tam ekran — bkz.
/// RemoteConfigService.isUpdateRequired ve main.dart > RemoteConfigGate.
/// Sadece mobilde (Android/iOS) gösterilir; web'de mağaza kavramı olmadığı
/// için gate bu ekranı hiç tetiklemez.
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

  Future<void> _openStore() async {
    final url = defaultTargetPlatform == TargetPlatform.iOS
        ? AppConstants.appStoreUrl
        : AppConstants.playStoreUrl;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: AppColors.mobileBackground,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: AppColors.mobileAccentGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.system_update_rounded,
                        size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    context.l10n.forceUpdatePageTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.mobileTextPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.l10n.forceUpdatePageDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.mobileTextSecondary,
                        fontSize: 14,
                        height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mobilePrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _openStore,
                      child: Text(context.l10n.forceUpdatePageButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
