import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../util/comminucation_actions.dart';
import 'design_system/tactile_press.dart';

/// Mobil müşteri ekranlarının ortak, hızlı iletişim aksiyonu — tek
/// dokunuşla esnafa WhatsApp'tan yazma. Native shell'in her ekranına
/// (Ana Sayfa, Keşfet, Favoriler) kendi `floatingActionButton`'u olarak
/// eklenir (uygulamada tek, kalıcı bir üst shell olmadığından — bkz.
/// MobileBottomNav'ın aynı per-sayfa gömme deseni).
class WhatsAppQuickFab extends StatelessWidget {
  const WhatsAppQuickFab({super.key, this.message});

  /// Boşsa [SaglamSpotCommunication.launchWhatsApp]'ın varsayılan
  /// karşılama mesajı kullanılır.
  final String? message;

  @override
  Widget build(final BuildContext context) {
    return TactilePress(
      pressScale: 0.9,
      enableTilt: false,
      onTap: () {
        HapticFeedback.mediumImpact();
        if (message != null) {
          SaglamSpotCommunication.launchWhatsApp(message: message!);
        } else {
          SaglamSpotCommunication.launchWhatsApp();
        }
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.mobileAccentGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.mobileAccent.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(Icons.chat_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}
