import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/remote_config_service.dart';
import 'ad_gate_provider.dart';

/// TÜM reklam widget'larının (AdsenseBanner, native ad kartları, banner)
/// ortak "kapatma kancası" — İKİ AYRI anahtarı birden kontrol eder:
///  1) RemoteConfigService.adsEnabledNotifier — uzaktan acil kill-switch
///     (Firebase Console'dan anlık kapatma).
///  2) adsEnabledProvider (bkz. ad_gate_provider.dart) — cihazda
///     SharedPreferences'taki `ads_removed` anahtarı (İLERİDE bir
///     abonelik/RevenueCat özelliğiyle güncellenecek).
/// İkisinden biri "kapalı" derse, reklam HİÇ gösterilmez.
class ReactiveAdWrapper extends StatelessWidget {
  final Widget child;

  const ReactiveAdWrapper({super.key, required this.child});

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<bool>(
      valueListenable: RemoteConfigService.adsEnabledNotifier,
      builder: (final context, final remoteAdsEnabled, final _) {
        if (!remoteAdsEnabled) return const SizedBox.shrink();
        return Consumer(
          builder: (final context, final ref, final _) {
            final gateEnabled = ref.watch(adsEnabledProvider);
            return gateEnabled ? child : const SizedBox.shrink();
          },
        );
      });
}
