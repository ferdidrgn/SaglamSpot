import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../localization/locale_provider.dart';
import '../theme/app_colors.dart';

class LanguageSelector extends ConsumerWidget {
  final bool isDrawer;

  const LanguageSelector({super.key, this.isDrawer = false});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final localeAsync = ref.watch(localeControllerProvider);
    final currentLocale = localeAsync.value ?? const Locale('tr');

    // Ortak dil seçenekleri listesi
    final List<({Locale locale, String label, String flag})> languages = [
      (locale: const Locale('tr'), label: 'Türkçe', flag: '🇹🇷'),
      (locale: const Locale('en'), label: 'English', flag: '🇺🇸'),
      (locale: const Locale('ar'), label: 'العربية', flag: '🇸🇦'),
      (locale: const Locale('zh'), label: '中文', flag: '🇨🇳'),
      (locale: const Locale('ru'), label: 'Русский', flag: '🇷🇺'),
      (locale: const Locale('uk'), label: 'Українська', flag: '🇺🇦'),
      (locale: const Locale('de'), label: 'Deutsch', flag: '🇩🇪'),
      (locale: const Locale('it'), label: 'Italiano', flag: '🇮🇹'),
      (locale: const Locale('el'), label: 'Ελληνικά', flag: '🇬🇷'),
      (locale: const Locale('uz'), label: 'O\'zbekcha', flag: '🇺🇿'),
      (locale: const Locale('ky'), label: 'Кыргызча', flag: '🇰🇬'),
    ];

    // --- DRAWER TASARIMI (Yan Menü) ---
    if (isDrawer) {
      return ExpansionTile(
        leading: Icon(Icons.translate_rounded, color: context.colors.primary),
        title: Text(
          context.l10n.languageSelectorTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          languages.firstWhere((final e) => e.locale == currentLocale).label,
          style: TextStyle(color: context.colors.primary, fontSize: 12),
        ),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: languages.map((final lang) {
          final isSelected = currentLocale == lang.locale;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32),
            leading: Text(lang.flag, style: const TextStyle(fontSize: 20)),
            title: Text(lang.label),
            trailing: isSelected
                ? Icon(Icons.check_circle_rounded, color: context.colors.primary, size: 20)
                : null,
            onTap: () => ref.read(localeControllerProvider.notifier).setLocale(lang.locale),
          );
        }).toList(),
      );
    }

    // --- APPBAR TASARIMI (Üst Menü - Popup) ---
    // Artık jenerik bir "çeviri" ikonu yerine, seçili dilin bayrağı ve kodu
    // görünüyor — kullanıcı menüyü açmadan hangi dilde olduğunu görür.
    final current =
        languages.firstWhere((final e) => e.locale == currentLocale);
    return PopupMenuButton<Locale>(
      tooltip: context.l10n.languageTooltip,
      offset: const Offset(0, 46),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      color: AppColors.surface,
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(current.flag,
                style: TextStyle(
                    fontSize:
                        context.responsive(mobile: 15, tablet: 16, desktop: 17))),
            const SizedBox(width: 5),
            Text(current.locale.languageCode.toUpperCase(),
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: context.responsive(mobile: 11, desktop: 12))),
            const SizedBox(width: 2),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
                size: context.responsive(mobile: 16, desktop: 18)),
          ],
        ),
      ),
      onSelected: (final Locale locale) {
        ref.read(localeControllerProvider.notifier).setLocale(locale);
      },
      itemBuilder: (final context) => languages.map((final lang) {
        final isSelected = currentLocale == lang.locale;
        return PopupMenuItem<Locale>(
          value: lang.locale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(lang.flag, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lang.label,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.accentDark
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_rounded,
                      color: AppColors.accentDark, size: 18),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}