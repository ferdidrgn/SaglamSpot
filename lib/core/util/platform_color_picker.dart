import 'package:flutter/widgets.dart';
import '../common/extentions/app_context_ui_extension.dart';

/// Uygulama artık TEK bir marka paleti kullanıyor (teal/sage — eski sıcak
/// espresso/ahşap palet kaldırıldı, bkz. app_colors.dart). Bu yardımcı
/// jenerik bırakıldı (Color VEYA Gradient dönebilir) — mobile/web kolları
/// artık aynı değeri döndürse de çağrı yerlerini tek tek değiştirmemek
/// için korunuyor. Eskiden `product_detail_page.dart` içinde özel (`_pc`)
/// bir yardımcıydı; sayfanın alt widget'ları ayrı dosyalara taşınırken
/// paylaşılabilir hale getirildi.
T platformPick<T>(final BuildContext context,
        {required final T mobile, required final T web}) =>
    context.isMobile ? mobile : web;
