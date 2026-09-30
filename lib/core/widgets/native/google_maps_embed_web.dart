import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// Web derlemesinde gerçek, canlı bir Google Haritalar embed'i (API
/// anahtarı GEREKMEZ — `output=embed` sorgu parametresiyle herkese açık
/// gömme biçimi kullanılır). DOM'a gerçek bir `<iframe>` ekler; sahte bir
/// harita görseli DEĞİLDİR.
class GoogleMapsEmbed extends StatefulWidget {
  const GoogleMapsEmbed({
    super.key,
    required this.latitude,
    required this.longitude,
    this.zoom = 16,
    this.borderRadius = 0,
  });

  final double latitude;
  final double longitude;
  final int zoom;
  final double borderRadius;

  @override
  State<GoogleMapsEmbed> createState() => _GoogleMapsEmbedState();
}

class _GoogleMapsEmbedState extends State<GoogleMapsEmbed> {
  static int _instanceCounter = 0;
  late final String _viewType;
  html.IFrameElement? _iframe;

  /// iframe başlangıçta fare/dokunma olaylarını ALMAZ — aksi halde sayfayı
  /// kaydıran kullanıcı imleci/parmağı haritaya denk geldiği anda kaydırma
  /// haritaya kapılıyor (zoom/pan) ve sayfa orada takılı kalıyordu.
  /// Kullanıcı haritaya bilerek dokununca etkinleşir, imleç çıkınca
  /// yeniden pasifleşir.
  bool _interactive = false;

  void _setInteractive(final bool value) {
    if (_interactive == value) return;
    _iframe?.style.pointerEvents = value ? 'auto' : 'none';
    setState(() => _interactive = value);
  }

  @override
  void initState() {
    super.initState();
    // Reklam embed'indeki ile aynı mantık: her örneğin DOM'da benzersiz bir
    // görünüm tipi olmalı, aksi halde aynı harita birden fazla yerde
    // render edilirse çakışır.
    _instanceCounter++;
    _viewType =
        'google-maps-${_instanceCounter}-${DateTime.now().microsecondsSinceEpoch}';

    try {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (final int viewId) {
        final src = 'https://www.google.com/maps?q=${widget.latitude},${widget.longitude}'
            '&z=${widget.zoom}&output=embed';
        return _iframe = html.IFrameElement()
          ..src = src
          ..style.pointerEvents = 'none'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..setAttribute('loading', 'lazy')
          ..allowFullscreen = true;
      });
    } catch (e) {
      debugPrint('⚠️ Google Maps embed view factory kaydı başarısız: $e');
    }
  }

  @override
  Widget build(final BuildContext context) => MouseRegion(
        onExit: (final _) => _setInteractive(false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              HtmlElementView(viewType: _viewType),
              if (!_interactive)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _setInteractive(true),
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xE6FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.touch_app_rounded,
                                size: 18, color: Color(0xFF3E2F23)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
