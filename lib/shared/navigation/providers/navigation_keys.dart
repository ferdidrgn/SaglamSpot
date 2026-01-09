import 'package:flutter/material.dart';

class NavigationKeys {
  // Uygulamanın en dış katmanı (Login, Search, Product Detail gibi tam ekran sayfalar için)
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  // Shell (Bottom Navigation / Top Navigation) içindeki sekme yönetimleri için:
  static final homeShellKey =
      GlobalKey<NavigatorState>(debugLabel: 'homeShell');
  static final newProductsShellKey =
      GlobalKey<NavigatorState>(debugLabel: 'newProductsShell');
  static final spotProductsShellKey =
      GlobalKey<NavigatorState>(debugLabel: 'spotProductsShell');

  // Eğer gerekirse Web ve Mobil özel anahtarlarını da tutabilirsin
  static final webNavKey = GlobalKey<NavigatorState>();
  static final mobileNavKey = GlobalKey<NavigatorState>();
}
