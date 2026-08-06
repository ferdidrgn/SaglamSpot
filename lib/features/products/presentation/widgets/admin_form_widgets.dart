import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Ürün ekle/düzenle formlarında kullanılan ortak "kart bölüm" kabuğu.
class AdminFormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const AdminFormSection(
      {super.key, required this.title, required this.icon, required this.child});

  @override
  Widget build(final BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.accentDark),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      );
}

/// Ortak, marka renklerine uygun metin girişi.
class AdminFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool numeric;
  final int lines;

  const AdminFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.numeric = false,
    this.lines = 1,
  });

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextField(
          controller: controller,
          maxLines: lines,
          keyboardType:
              numeric ? const TextInputType.numberWithOptions(decimal: true) : null,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14.5),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 13.5),
            prefixIcon: Icon(icon, color: AppColors.onSecondary, size: 20),
            filled: true,
            fillColor: AppColors.secondary,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
        ),
      );
}

/// Ortak, marka renklerine uygun anahtar (switch) satırı.
class AdminFormSwitch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AdminFormSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(subtitle!,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textTertiary)),
                    ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.accent,
            ),
          ],
        ),
      );
}

/// Kaydet/Güncelle butonu — marka rengiyle, tam genişlik.
class AdminSubmitButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const AdminSubmitButton(
      {super.key, required this.label, required this.isLoading, required this.onTap});

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: double.infinity,
        height: 54,
        child: Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: isLoading ? null : onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      );
}
