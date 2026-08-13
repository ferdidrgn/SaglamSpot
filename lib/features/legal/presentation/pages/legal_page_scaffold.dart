import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';

/// Gizlilik Politikası ve Kullanım Koşulları sayfalarının paylaştığı ortak
/// düzen: geri butonlu başlık + "şu an sadece Türkçe" uyarı şeridi (dil
/// Türkçe değilse) + kaydırılabilir içerik.
class LegalPageScaffold extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final List<Widget> children;

  const LegalPageScaffold({
    super.key,
    required this.title,
    required this.onBack,
    required this.children,
  });

  @override
  Widget build(final BuildContext context) {
    final bool isTurkish = Localizations.localeOf(context).languageCode == 'tr';

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: !kIsWeb ? const MobileBottomNav() : null,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back_rounded,
                        color: AppColors.mobileTextPrimary),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.mobileTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isTurkish)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.mobileAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 18, color: AppColors.mobileAccentDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.legalContentTurkishOnly,
                        style: TextStyle(
                            fontSize: 12.5, color: AppColors.mobileAccentDark),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
