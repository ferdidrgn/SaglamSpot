import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// Gerçek, canlı bir Google Haritalar `<iframe>`'ini Flutter Web sayfasına
/// gömen widget — `real_adsense_ad_web.dart` ile AYNI DOM-enjeksiyon
/// tekniği (platformViewRegistry + HtmlElementView). API anahtarı
/// GEREKTİRMEYEN klasik `output=embed` sorgu biçimini kullanır, bu yüzden
/// ek bir Google Cloud faturalandırma/anahtar kurulumu gerekmez.
class GoogleMapEmbed extends StatefulWidget {
  final double lat;
  final double lng;
  final String label;
  final double height;
  final double borderRadius;
  final VoidCallback? onOpenExternal;

  const GoogleMapEmbed({
    super.key,
    required this.lat,
    required this.lng,
    required this.label,
    this.height = 260,
    this.borderRadius = 24,
    this.onOpenExternal,
  });

  @override
  State<GoogleMapEmbed> createState() => _GoogleMapEmbedState();
}

class _GoogleMapEmbedState extends State<GoogleMapEmbed> {
  static int _instanceCounter = 0;
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _instanceCounter++;
    _viewType = 'google-map-$_instanceCounter-${DateTime.now().microsecondsSinceEpoch}';

    try {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (final int viewId) {
        final html.IFrameElement iframe = html.IFrameElement()
          ..src =
              'https://maps.google.com/maps?q=${widget.lat},${widget.lng}&z=16&output=embed'
          ..style.border = '0'
          ..style.width = '100%'
          ..style.height = '100%'
          ..title = widget.label
          ..setAttribute('loading', 'lazy');
        return iframe;
      });
    } catch (e) {
      debugPrint('⚠️ Harita view factory kaydı başarısız: $e');
    }
  }

  @override
  Widget build(final BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: HtmlElementView(viewType: _viewType),
        ),
      );
}
