// ═══════════════════════════════════════════════════════
// 404 ERROR PAGE
// ═══════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/shared/navigation/widgets/nav_handler.dart';

class NotFoundPage extends StatelessWidget {
  final String? errorPath;

  const NotFoundPage({super.key, this.errorPath});

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline_rounded,
                    size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                '404 - Sayfa Bulunamadı',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800),
              ),
              if (errorPath != null) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Yol: $errorPath',
                      style: TextStyle(color: AppColors.textTertiary),
                      textAlign: TextAlign.center),
                ),
              ],
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 8)),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  onPressed: () => NavigationHandler.goToHome(context),
                  child: const Text('Ana Sayfaya Dön'),
                ),
              )
            ],
          ),
        ),
      );
}
