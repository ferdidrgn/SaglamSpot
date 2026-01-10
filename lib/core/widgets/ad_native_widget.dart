import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdNativeWidget extends StatefulWidget {
  const AdNativeWidget({super.key});

  @override
  State<AdNativeWidget> createState() => _AdNativeWidgetState();
}

class _AdNativeWidgetState extends State<AdNativeWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-5779807348211992/2655077678',
      // Test Native ID
      factoryId: 'adFactoryExample',
      // Not: Platform tarafında tanımlı olmalıdır
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (final ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (final ad, final error) {
          ad.dispose();
        },
      ),
      // Basit şablon kullanımı
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Colors.white,
        cornerRadius: 16.0,
      ),
    )..load();
  }

  @override
  Widget build(final BuildContext context) {
    if (_isLoaded && _nativeAd != null) {
      return Container(
        height: 100, // Küçük şablon için ideal yükseklik
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: AdWidget(ad: _nativeAd!),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
