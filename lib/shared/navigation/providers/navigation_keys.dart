import 'package:flutter/material.dart';

class NavigationKeys {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  // Web ve Mobil için ayrı shell'ler kullanıyorsan buraya eklenebilir
  static final webNavKey = GlobalKey<NavigatorState>();
  static final mobileNavKey = GlobalKey<NavigatorState>();
}
