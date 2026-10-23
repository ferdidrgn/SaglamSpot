import 'package:flutter/material.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';
import '../util/comminucation_actions.dart';
import 'design_system/tactile_press.dart';

/// Web kabuğunun (Ana Sayfa, Yeni, Spot, Hakkımızda, SSS) her sayfasında
/// sağ altta sabit duran WhatsApp iletişim balonu — mobildeki
/// [WhatsAppQuickFab]'ın web eşdeğeri. Tek, kalıcı üst kabuk (NavigationScreen)
/// üstünde bir kez yerleştirilir; konumlandırma (Positioned) çağıran tarafa
/// aittir.
class WebWhatsAppBubble extends StatelessWidget {
  const WebWhatsAppBubble({super.key});

  @override
  Widget build(final BuildContext context) {
    final String label = context.l10n.whatsappCta;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14).copyWith(
              bottomRight: const Radius.circular(2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.background,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Tooltip(
          message: label,
          child: TactilePress(
            pressScale: 0.92,
            enableTilt: false,
            onTap: () => SaglamSpotCommunication.launchWhatsApp(),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.chat_rounded,
                  color: Colors.white, size: 26),
            ),
          ),
        ),
      ],
    );
  }
}
