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
            // Kare logo dosyası artık her zaman daireye kırpılıyor —
            // ikinci_sans_furniture prototipindeki BrandLogo mantığı.
            ClipOval(
              child: Container(
                width: context.responsive(
                    mobile: 36.0, tablet: 42.0, desktop: 48.0),
                height: context.responsive(
                    mobile: 36.0, tablet: 42.0, desktop: 48.0),
                color: AppColors.primary,
                child: Image.asset(
                  'assets/images/saglam_spot_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (final context, final error, final stackTrace) =>
                      Icon(Icons.auto_awesome,
                          size: context.iconSmall, color: AppColors.accentLight),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                    color: AppColors.primary,
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
        return _HeaderNavLink(
          label: labels[i],
          active: active,
          onTap: () => onNavigate(i),
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

    return _HeaderActionButton(
      size: size,
      icon: icon,
      iconSize: context.responsive(mobile: 20.0, desktop: 20.0),
      borderRadius: context.responsive(mobile: 10.0, desktop: 12.0),
      onPressed: onPressed,
    );
  }
}

/// Masaüstü nav bağlantısı — hover'da yumuşak bir renk geçişi ve altı çizili
/// vurgu ile tıklanabilirliği belli eder (Emil Kowalski: her etkileşimin
/// amaçlı, sübtil bir geri bildirimi olmalı).
class _HeaderNavLink extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _HeaderNavLink(
      {required this.label, required this.active, required this.onTap});

  @override
  State<_HeaderNavLink> createState() => _HeaderNavLinkState();
}

class _HeaderNavLinkState extends State<_HeaderNavLink> {
  bool _hovered = false;

  @override
  Widget build(final BuildContext context) {
    final highlighted = widget.active || _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (final _) => setState(() => _hovered = true),
      onExit: (final _) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontWeight: widget.active ? FontWeight.bold : FontWeight.w500,
                  color: highlighted
                      ? AppColors.accentDark
                      : AppColors.textPrimary,
                ),
                child: Text(widget.label),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                height: 2,
                width: highlighted ? 16 : 0,
                color: AppColors.accentDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// İkon aksiyon butonu — hover'da hafif zeminle ve kenarlıkla kendini belli
/// eder.
class _HeaderActionButton extends StatefulWidget {
  final double size;
  final double iconSize;
  final double borderRadius;
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderActionButton({
    required this.size,
    required this.iconSize,
    required this.borderRadius,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_HeaderActionButton> createState() => _HeaderActionButtonState();
}

class _HeaderActionButtonState extends State<_HeaderActionButton> {
  bool _hovered = false;

  @override
  Widget build(final BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (final _) => setState(() => _hovered = true),
        onExit: (final _) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _hovered ? AppColors.secondary : AppColors.surface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
                color: _hovered ? AppColors.accentDark : AppColors.border),
          ),
          child: IconButton(
              icon: Icon(widget.icon, size: widget.iconSize),
              onPressed: widget.onPressed,
              color: _hovered ? AppColors.accentDark : AppColors.textSecondary,
              padding: EdgeInsets.zero),
        ),
      );
}
