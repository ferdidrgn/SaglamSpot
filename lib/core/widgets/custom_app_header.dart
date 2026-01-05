import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/search_page.dart';
import '../theme/app_colors.dart';
import '../util/responsive_utils.dart';

class CustomAppHeader extends StatelessWidget {
  final int currentIndex;
  final void Function(int index) onNavigate;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppHeader({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
    required this.scaffoldKey, // Bu anahtar mobil menü için zorunludur
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
        border: Border(
            bottom: BorderSide(color: AppColors.border.withOpacity(0.3))),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            // Düzeltme: 'getValueForDevice' yerine 'context.responsive'
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: context.responsive(mobile: 12.0, desktop: 16.0),
          ),
          // Düzeltme: 'ResponsiveUtils.isMobile' yerine 'context.isMobile'
          child: context.isMobile
              ? _buildMobileLayout(context) // Mobil düzen
              : _buildDesktopLayout(context), // Desktop düzen
        ),
      ),
    );
  }

  // --- DESKTOP DÜZENİ (Milimetrik Düzenleme) ---
  Widget _buildDesktopLayout(final BuildContext context) {
    return Row(
      children: [
        // Logo alanı - esnek
        _buildLogo(context),

        // Sabit Spacer yerine Expanded kullanarak alanı paylaştırıyoruz
        const Expanded(flex: 1, child: SizedBox()),

        // Navigasyon metinlerinin sıkışmaması için Flexible ile sardık
        Flexible(
          flex: 8,
          child: SingleChildScrollView(
            // Çok dar ekranlarda dikey taşmayı önler
            scrollDirection: Axis.horizontal,
            child: _buildDesktopNavigation(context),
          ),
        ),

        const Expanded(flex: 1, child: SizedBox()),

        // Kullanıcı aksiyonları (Arama ve Profil)
        _buildUserActions(context),
      ],
    );
  }

// --- ARAMA ÇUBUĞU (Hassas Düzenleme) ---
  Widget _buildSearchBar(final BuildContext context) {
    return Container(
      // Değerleri milimetrik olarak küçülttük
      constraints: BoxConstraints(
        maxWidth: context.responsive(
          mobile: 100.0,
          tablet: 140.0,
          desktop: 180.0, // 200'den 180'e çektik
        ),
      ),
      height: 38,
      // 40'tan 38'e çekerek dikey alanı da rahatlattık
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.5))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_rounded,
              size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Ürün ara...',
                  style:
                      TextStyle(color: AppColors.textTertiary, fontSize: 13)),
            ),
          )
        ],
      ),
    );
  }

// --- MOBİL DÜZENİ (Düzeltilmiş) ---
  Widget _buildMobileLayout(final BuildContext context) {
    return Row(
      children: [
        // Logo Alanı: Diğer ikonlardan kalan tüm boşluğu güvenli şekilde kullanır
        Expanded(child: _buildLogo(context)),

        const SizedBox(width: 8),

        // Aksiyon Butonları (Arama ve Menü)
        Row(
          mainAxisSize: MainAxisSize.min, // Sadece ikon kadar yer kaplar
          children: [
            _buildActionButton(
              context: context,
              icon: Icons.search_outlined,
              onPressed: () => context.push('/search'),
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              context: context,
              icon: Icons.menu,
              onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),
      ],
    );
  }

// --- LOGO METODU (FittedBox ile taşma garantili çözüm) ---
  Widget _buildLogo(final BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/saglam_spot_logo.png',
            height:
                context.responsive(mobile: 36.0, tablet: 42.0, desktop: 48.0),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.weekend_rounded, size: context.iconSmall),
          ),
          const SizedBox(width: 8),
          // Flexible + FittedBox kombinasyonu 31 piksellik taşmayı engeller
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              // Metin sığmazsa otomatik küçülür, asla taşmaz
              alignment: Alignment.centerLeft,
              child: Text(
                'Sağlam Spot',
                style: TextStyle(
                  fontSize: context.responsive(mobile: 18.0, desktop: 22.0),
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopNavigation(final BuildContext context) {
    const labels = ['Ana Sayfa', 'Sıfır Ürünler', 'Spot', 'Hakkımızda', 'SSS'];

    return Row(
      children: List.generate(labels.length, (final i) {
        final active = i == currentIndex;
        return GestureDetector(
          onTap: () => onNavigate(i),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              labels[i],
              style: TextStyle(
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUserActions(final BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSearchBar(context),
        const SizedBox(width: 8),
        _buildActionButton(
          context: context,
          icon: Icons.person_outline,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required final BuildContext context,
    required final IconData icon,
    required final VoidCallback onPressed,
  }) {
    final double size = context.responsive(mobile: 40.0, desktop: 40.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 10.0, desktop: 12.0)),
          border: Border.all(color: AppColors.border)),
      child: IconButton(
          icon:
              Icon(icon, size: context.responsive(mobile: 20.0, desktop: 20.0)),
          onPressed: onPressed,
          color: AppColors.textSecondary,
          padding: EdgeInsets.zero),
    );
  }
}
