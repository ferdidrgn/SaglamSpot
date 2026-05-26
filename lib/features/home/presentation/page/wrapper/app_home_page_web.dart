import 'package:flutter/material.dart';
import '../../../../../shared/navigation/providers/navigation_keys.dart';
import '../home_page_web.dart';

class AppHomePage extends StatelessWidget {
  const AppHomePage({super.key});

  @override
  Widget build(final BuildContext context) =>
      HomePage(key: NavigationKeys.webNavKey);
}
