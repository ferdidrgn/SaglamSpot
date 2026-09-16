import 'package:flutter/material.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../services/remote_config_service.dart';
import '../theme/app_colors.dart';

/// Remote Config'teki `maintenance_mode` bayrağı true olduğunda TÜM
/// uygulamanın yerini alan tam ekran — bkz. RemoteConfigGate. Herhangi bir
/// navigasyon/geri tuşu YOK, bilinçli olarak: bakım modundayken kullanıcının
/// uygulamanın başka hiçbir yerine geçebilmesi istenmiyor.
class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    await RemoteConfigService.refresh();
    if (mounted) setState(() => _retrying = false);
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
                    child: const Icon(Icons.build_rounded,
                        size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    context.l10n.maintenancePageTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.mobileTextPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.l10n.maintenancePageDesc,
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
                      onPressed: _retrying ? null : _retry,
                      child: _retrying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.4, color: Colors.white),
                            )
                          : Text(context.l10n.maintenancePageRetry),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
