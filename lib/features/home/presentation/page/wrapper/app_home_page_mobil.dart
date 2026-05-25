import 'package:flutter/material.dart';
import '../../../../../shared/navigation/providers/navigation_keys.dart';
import '../../widgets/architectural_editorial_showroom.dart';
import '../home_page_mobile.dart';

class AppHomePage extends StatelessWidget {
  const AppHomePage({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        // Rafine açık editoryal arka plan
        body: SafeArea(
          top: false, // Donanım çubuğu geçişini ezmemek için
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(), // 120Hz akıcı kaydırma
            slivers: [
              // 1. Yeni Göz Alıcı Lüks Showroom Vitrini en tepede çağrılıyor
              const SliverToBoxAdapter(child: ArchitecturalEditorialShowroom()),

              // 2. Sizin orijinal mobil ana sayfa içeriğiniz (Key korunarak çağrıldı)
              SliverToBoxAdapter(
                  child: HomePage(key: NavigationKeys.mobileNavKey)),
            ],
          ),
        ),
      );
}
