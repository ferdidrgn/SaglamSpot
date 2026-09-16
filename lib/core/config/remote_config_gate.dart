import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/remote_config_service.dart';
import 'force_update_page.dart';
import 'maintenance_page.dart';

/// Routed sayfa ağacının (main.dart > MaterialApp.router builder) hemen
/// üstünü saran, Remote Config'ten gelen iki "tüm uygulamayı durdur"
/// bayrağını dinleyen kapı:
///   1) `maintenance_mode` true  → MaintenancePage
///   2) `force_update_min_version` kurulu sürümden yeni → ForceUpdatePage
///      (yalnızca mobil — web'de mağaza/zorunlu güncelleme kavramı yok)
/// İkisi de kapalıysa (varsayılan/Console'da hiç ayarlanmamışsa) [child]
/// olduğu gibi çizilir — davranış ÖNCEKİYLE TAMAMEN AYNI kalır.
class RemoteConfigGate extends StatelessWidget {
  final Widget child;

  const RemoteConfigGate({super.key, required this.child});

  // PackageInfo.fromPlatform() bir platform kanalı çağrısı — her rebuild'de
  // (tema/dil değişimi gibi sık olaylarda) tekrar tetiklenmemesi için bu
  // widget ağacı boyunca BİR KEZ önbelleklenir.
  static Future<PackageInfo>? _packageInfoFuture;

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: RemoteConfigService.maintenanceModeNotifier,
        builder: (final context, final maintenanceMode, final _) {
          if (maintenanceMode) return const MaintenancePage();
          if (kIsWeb) return child;
          return _ForceUpdateCheck(child: child);
        },
      );
}

class _ForceUpdateCheck extends StatelessWidget {
  final Widget child;

  const _ForceUpdateCheck({required this.child});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<String>(
        valueListenable: RemoteConfigService.forceUpdateMinVersionNotifier,
        builder: (final context, final minVersion, final _) =>
            FutureBuilder<PackageInfo>(
          future: RemoteConfigGate._packageInfoFuture ??=
              PackageInfo.fromPlatform(),
          builder: (final context, final snapshot) {
            final currentVersion = snapshot.data?.version;
            if (currentVersion != null &&
                RemoteConfigService.isUpdateRequired(currentVersion)) {
              return const ForceUpdatePage();
            }
            return child;
          },
        ),
      );
}
