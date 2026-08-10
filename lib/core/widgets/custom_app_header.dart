import 'package:flutter/material.dart';
import 'package:saglamspot/shared/navigation/widgets/nav_handler.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../theme/app_colors.dart';
import '../util/comminucation_actions.dart';

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

  // Arama çubuğu artık başlığın görsel merkezi — geniş, hap biçimli ve
  // sonunda dolgu vurgu renkli bir arama düğmesiyle bitiyor. Bento/vitrin
  // referans tasarımındaki "arama öncelikli" üst çubuk hissini yakalıyor.
  Widget _buildDesktopLayout(final BuildContext context) => Row(
        children: [
          _buildLogo(context),
          SizedBox(width: context.responsive(mobile: 24, desktop: 36)),
          Expanded(child: _buildSearchBar(context)),
          SizedBox(width: context.responsive(mobile: 24, desktop: 36)),
          _buildDesktopNavigation(context),
          SizedBox(width: context.responsive(mobile: 16, desktop: 24)),
          _buildWhatsAppButton(context),
        ],
      );

// --- ARAMA ÇUBUĞU (Tıklanabilir + GoRouter) ---
  Widget _buildSearchBar(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => NavigationHandler.goToSearch(context),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        height: context.responsive(mobile: 40.0, desktop: 48.0),
        padding: const EdgeInsets.only(left: 20, right: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded,
                size: 18, color: AppColors.textTertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                context.l10n.searchHint,
                style: const TextStyle(
                    color: AppColors.textTertiary, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: context.responsive(mobile: 30.0, desktop: 36.0),
              height: context.responsive(mobile: 30.0, desktop: 36.0),
              decoration:
                  const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 16),
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
                    fontFamily: 'Fraunces',
                    fontSize: context.responsive(mobile: 18.0, desktop: 22.0),
                    fontWeight: FontWeight.w600,
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
        return _NavLink(
          label: labels[i],
          active: active,
          onTap: () => onNavigate(i),
        );
      }),
    );
  }

  // Showcase sitesinde kullanıcı hesabı/sepeti yok — üst çubuğun son
  // eylemi her zaman doğrudan WhatsApp ile iletişim.
  Widget _buildWhatsAppButton(final BuildContext context) => Material(
        color: AppColors.accent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: SaglamSpotCommunication.launchWhatsApp,
          child: SizedBox(
            width: context.responsive(mobile: 40.0, desktop: 44.0),
            height: context.responsive(mobile: 40.0, desktop: 44.0),
            child: const Icon(Icons.chat_bubble_outline_rounded,
                color: Colors.white, size: 20),
          ),
        ),
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

/// Masaüstü menü bağlantısı — hover'da yumuşak renk geçişi, aktif
/// sekmenin altında beliren ince bir vurgu çizgisi.
class _NavLink extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavLink(
      {required this.label, required this.active, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    final bool highlighted = widget.active || _isHovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 14.5,
                  letterSpacing: 0.3,
                  fontWeight: widget.active ? FontWeight.w700 : FontWeight.w500,
                  color: highlighted
                      ? AppColors.accent
                      : AppColors.textPrimary,
                ),
                child: Text(widget.label),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: highlighted ? 16 : 0,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
