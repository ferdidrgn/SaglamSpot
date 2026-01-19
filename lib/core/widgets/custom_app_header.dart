import 'package:flutter/material.dart';
import 'package:saglamspot/shared/navigation/widgets/nav_handler.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';

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
            horizontal: context.responsive(mobile: 16.0, desktop: 24.0),
            vertical: context.responsive(mobile: 12.0, desktop: 16.0),
          ),
          child: context.isMobile
              ? _buildMobileLayout(context) // Mobil düzen
              : _buildDesktopLayout(context), // Desktop düzen
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(final BuildContext context) => Row(
        children: [
          _buildLogo(context),
          const Spacer(flex: 10),
          // 3. Navigasyon Menüsü
          _buildDesktopNavigation(context),
          const SizedBox(width: 30),
          _buildUserActions(context),
        ],
      );

// --- ARAMA ÇUBUĞU (Tıklanabilir + GoRouter) ---
  Widget _buildSearchBar(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => NavigationHandler.goToSearch(context),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: context.responsive(
            mobile: 100.0,
            tablet: 140.0,
            desktop: 180.0,
          ),
        ),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_rounded,
                size: 16, color: AppColors.textTertiary),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  context.l10n.searchHint,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
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
              onPressed: () => NavigationHandler.goToSearch(context),
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

// --- LOGO METODU (Ferah Tasarım Güncellemesi) ---
  Widget _buildLogo(final BuildContext context) => GestureDetector(
        onTap: () => NavigationHandler.goToHome(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/saglam_spot_logo.png',
              height:
                  context.responsive(mobile: 36.0, tablet: 42.0, desktop: 48.0),
              fit: BoxFit.contain,
              errorBuilder: (final context, final error, final stackTrace) =>
                  Icon(Icons.auto_awesome, size: context.iconSmall),
            ),
            const Icon(Icons.auto_awesome, color: Color(0xFF103E35), size: 24),
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

  Widget _buildDesktopNavigation(final BuildContext context) {
    final labels = [
      context.l10n.home,
      context.l10n.conditionNew,
      context.l10n.conditionUsed,
      context.l10n.aboutUs,
      context.l10n.sss
    ];

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

  Widget _buildUserActions(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min, // Sadece içerik kadar yer kaplar
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSearchBar(context),
          const SizedBox(width: 15),
          // Great Showman ferahlığı için artırılmış boşluk

          // Profil Butonu - En sondaki eleman
          _buildActionButton(
            context: context,
            icon: Icons.person_outline_rounded,
            onPressed: () {
              // Profil işlemleri
            },
          ),
        ],
      );

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
