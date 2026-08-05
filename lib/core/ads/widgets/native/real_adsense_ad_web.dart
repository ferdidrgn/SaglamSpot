import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// index.html içinde tanımlı `pushAdsenseAd()` JS köprüsü.
/// Dinamik olarak DOM'a eklenen <ins> etiketini gerçek reklamla doldurur.
@JS('pushAdsenseAd')
external void _pushAdsenseAd();

/// Google AdSense yayıncı kimliği (web/ads.txt ve web/index.html ile aynı).
const String _kAdsensePublisherId = 'ca-pub-5779807348211992';

/// Gerçek, canlı bir Google AdSense reklam birimini Flutter Web sayfasına
/// gömen widget. Sahte/placeholder kutu DEĞİLDİR — DOM'a gerçek
/// `<ins class="adsbygoogle">` etiketi ekler ve adsbygoogle kuyruğuna push eder.
class RealAdsenseAd extends StatefulWidget {
  /// AdManager._prodWeb() içindeki gerçek reklam birimi (slot) ID'si.
  /// Örn: display -> '1670983275', inArticle -> '3810061450',
  /// multiplex -> '4929919042'
  final String slotId;

  /// AdSense reklam formatı: 'auto' (display), 'fluid' (in-article/multiplex).
  final String format;

  /// 'in-article' gibi özel yerleşimler için data-ad-layout değeri.
  final String? layout;

  /// Reklam alanı için ayrılan yükseklik (yüklenene kadar/CLS'i önlemek için).
  final double height;

  final bool fullWidthResponsive;

  const RealAdsenseAd({
    super.key,
    required this.slotId,
    this.format = 'auto',
    this.layout,
    this.height = 280,
    this.fullWidthResponsive = true,
  });

  @override
  State<RealAdsenseAd> createState() => _RealAdsenseAdState();
}

class _RealAdsenseAdState extends State<RealAdsenseAd> {
  static int _instanceCounter = 0;
  late final String _viewType;
  bool _pushed = false;

  @override
  void initState() {
    super.initState();
    // Her reklam biriminin DOM'da benzersiz bir görünüm tipi olması gerekir,
    // aksi halde aynı slot birden fazla yerde render edilirse çakışır.
    _instanceCounter++;
    _viewType =
        'adsense-${widget.slotId}-${_instanceCounter}-${DateTime.now().microsecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (final int viewId) {
      final html.DivElement container = html.DivElement()
        ..style.width = '100%'
        ..style.height = '${widget.height}px'
        ..style.display = 'block'
        ..style.overflow = 'hidden'
        ..style.textAlign = 'center';

      final html.Element ins = html.Element.tag('ins')
        ..className = 'adsbygoogle'
        ..style.display = 'block'
        ..setAttribute('data-ad-client', _kAdsensePublisherId)
        ..setAttribute('data-ad-slot', widget.slotId)
        ..setAttribute('data-ad-format', widget.format);

      if (widget.layout != null) {
        ins.setAttribute('data-ad-layout', widget.layout!);
      }
      if (widget.fullWidthResponsive) {
        ins.setAttribute('data-full-width-responsive', 'true');
      }

      container.append(ins);

      // Element DOM'a eklendikten sonraki ilk frame'de reklamı tetikle.
      html.window.requestAnimationFrame((final _) => _triggerAdLoad());

      return container;
    });
  }

  void _triggerAdLoad() {
    if (_pushed) return;
    _pushed = true;
    try {
      _pushAdsenseAd();
    } catch (e) {
      debugPrint('⚠️ AdSense reklam tetikleme hatası: $e');
    }
  }

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: double.infinity,
        height: widget.height,
        child: HtmlElementView(viewType: _viewType),
      );
}
