import 'package:flutter/material.dart';
import '../../../../../shared/navigation/providers/navigation_keys.dart';
import '../../widgets/architectural_editorial_showroom.dart';
import '../home_page_web.dart';

class AppHomePage extends StatelessWidget {
  const AppHomePage({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Web arayüzü için de lüks editoryal showroom vitrini en tepede
              const SliverToBoxAdapter(child: ArchitecturalEditorialShowroom()),

              // 2. Sizin orijinal web ana sayfa içeriğiniz (Key korunarak çağrıldı)
              SliverToBoxAdapter(
                  child: HomePage(key: NavigationKeys.webNavKey)),
            ],
          ),
        ),
      );
}
