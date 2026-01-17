import 'package:share_plus/share_plus.dart';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

class WebMetaUtil {
  static void setProductMeta({
    required final String title,
    required final String description,
    required final String imageUrl,
    required final String productId,
  }) {
    if (!kIsWeb) return;

    final url = 'https://saglamspotcu.web.app/product/$productId';

    js.context.callMethod('setMeta', [
      title,
      description,
      imageUrl,
      url,
    ]);
  }
}

class ShareUtil {
  static Future<void> shareProduct({
    required final String productId,
    required final String productName,
  }) async {
    final url = 'https://saglamspotcu.web.app/product/$productId';

    // 🌐 Web + Native Share API
    if (kIsWeb && js.context.hasProperty('navigator')) {
      final navigator = js.context['navigator'];
      if (navigator.hasProperty('share')) {
        await js.context.callMethod('eval', [
          '''
          navigator.share({
            title: "$productName",
            text: "$productName",
            url: "$url"
          })
          '''
        ]);
        return;
      }
    }

    // 📱 Fallback (Android / iOS / unsupported browsers)
    await Share.share('$productName\n$url');
  }
}
