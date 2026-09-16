import 'package:flutter/material.dart';
import '../services/remote_config_service.dart';

/// TÜM reklam widget'larının (AdsenseBanner, native ad kartları, banner)
/// ortak "kapatma kancası" — RemoteConfigService.adsEnabledNotifier ile
/// uzaktan acil kill-switch (Firebase Console'dan anlık kapatma) sağlar.
class ReactiveAdWrapper extends StatelessWidget {
  final Widget child;

  const ReactiveAdWrapper({super.key, required this.child});

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<bool>(
      valueListenable: RemoteConfigService.adsEnabledNotifier,
      builder: (final context, final remoteAdsEnabled, final _) {
        return remoteAdsEnabled ? child : const SizedBox.shrink();
      });
}
