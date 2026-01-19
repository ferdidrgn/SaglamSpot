import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../common/enum/enums.dart';
import '../services/ad_manager.dart';
import '../services/remote_config_service.dart';

class AdBannerWidget extends StatefulWidget {
  final AdSize size;
  final EdgeInsets margin;

  const AdBannerWidget({
    super.key,
    this.size = AdSize.banner,
    this.margin = EdgeInsets.zero,
  });

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();

    _ad = BannerAd(
      adUnitId: AdManager.getAdUnitId(AdUnitType.banner),
      size: widget.size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (final _) => setState(() => _loaded = true),
        onAdFailedToLoad: (final ad, final _) => ad.dispose(),
      ),
    )..load();
  }

  @override
  Widget build(final BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    if (!RemoteConfigService.adsEnabled) return const SizedBox.shrink();

    return Container(
      margin: widget.margin,
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }
}
