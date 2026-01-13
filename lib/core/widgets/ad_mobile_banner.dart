import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_manager.dart';

class AdBannerWidget extends StatefulWidget {
  final double width;
  final double height;

  const AdBannerWidget({super.key, this.width = 320, this.height = 50});

  @override
  State<AdBannerWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: AdManager().bannerId(),
      size: AdSize(width: widget.width.toInt(), height: widget.height.toInt()),
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (final _) => setState(() {}),
        onAdFailedToLoad: (final ad, final error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(final BuildContext context) {
    if (_bannerAd == null) return const SizedBox.shrink();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AdWidget(ad: _bannerAd!),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
