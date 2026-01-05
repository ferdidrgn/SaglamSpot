import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class AdsenseBanner extends StatelessWidget {
  final String adSlot;
  final double height;

  const AdsenseBanner({
    super.key,
    required this.adSlot,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    final viewId = 'adsense-$adSlot';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int _) {
      final container = html.DivElement()
        ..style.width = '100%'
        ..style.height = '${height}px'
        ..setInnerHtml(
          '''
          <ins class="adsbygoogle"
              style="display:block"
              data-ad-client="ca-pub-5779807348211992"
              data-ad-slot="$adSlot"
              data-ad-format="auto"
              data-full-width-responsive="true"></ins>
          <script>
              (adsbygoogle = window.adsbygoogle || []).push({});
          </script>
          ''',
          treeSanitizer: html.NodeTreeSanitizer.trusted,
        );

      return container;
    });

    return SizedBox(
      height: height,
      child: HtmlElementView(viewType: viewId),
    );
  }
}
