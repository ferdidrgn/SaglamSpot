import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/catalog_theme.dart';
import '../../../../core/util/platform_color_picker.dart';
import '../../domain/entites/product.dart';

/// `ProductDetailPage`'in ("Ürün Detay Sayfası") kullandığı, tek başına
/// önemsiz küçük yardımcı widget'lar — eskiden sayfa dosyasının sonunda
/// duruyordu, okunabilirlik için ayrı dosyaya taşındı. Davranış/görünüm
/// AYNI kaldı.
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool filled;
  final Color? iconColor;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.filled = false,
    this.iconColor,
  });

  @override
  Widget build(final BuildContext context) => Material(
        color: filled
            ? platformPick(context,
                mobile: AppColors.mobileCardBg, web: AppColors.secondary)
            : platformPick(context,
                mobile: AppColors.mobileSurface, web: AppColors.surface),
        shape: const CircleBorder(),
        elevation: filled ? 0 : 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon,
                size: size * 0.42,
                color: iconColor ??
                    (filled
                        ? platformPick(context,
                            mobile: AppColors.mobilePrimary,
                            web: AppColors.primary)
                        : platformPick(context,
                            mobile: AppColors.mobileTextPrimary,
                            web: AppColors.textPrimary))),
          ),
        ),
      );
}

/// Sepete Ekle ve WhatsApp'ı EŞİT AĞIRLIKLI iki yarım-genişlik butona
/// ayırır — biri diğerinin gölgesinde kalmasın diye. `filled == true`
/// dolgu (birincil, sepet), `false` ise sadece kenarlıklı (ikincil,
/// WhatsApp) çizilir.
class HalfActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const HalfActionButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onTap,
      required this.filled});

  @override
  Widget build(final BuildContext context) {
    final Color accent = platformPick(context,
        mobile: AppColors.mobilePrimary, web: AppColors.primary);
    final Color fg = filled ? Colors.white : accent;

    return Material(
      color: filled ? accent : Colors.transparent,
      shape: StadiumBorder(
          side:
              filled ? BorderSide.none : BorderSide(color: accent, width: 1.6)),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 17),
              const SizedBox(width: 7),
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: fg,
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Güven bloğu içindeki tek bir madde: dolgu daireli ikon + kalın etiket —
/// eski yüzen hap-çipin yerini alan, daha "gövdeli" bir hiyerarşi.
class TrustTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const TrustTile({super.key, required this.icon, required this.label});

  @override
  Widget build(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: platformPick(context,
                  mobile: AppColors.mobileSurface, web: AppColors.surface),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: 15,
                color: platformPick(context,
                    mobile: AppColors.mobilePrimary, web: AppColors.primary)),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: platformPick(context,
                      mobile: AppColors.mobileTextPrimary,
                      web: AppColors.textPrimary))),
        ],
      );
}

class HowToBuyStep extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String desc;

  const HowToBuyStep(
      {super.key,
      required this.index,
      required this.icon,
      required this.title,
      required this.desc});

  @override
  Widget build(final BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: platformPick(context,
                  mobile: AppColors.mobileAccentGradient,
                  web: AppColors.accentGradient),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$index. $title',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: platformPick(context,
                            mobile: AppColors.mobileTextPrimary,
                            web: AppColors.textPrimary))),
                const SizedBox(height: 2),
                Text(desc,
                    style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: platformPick(context,
                            mobile: AppColors.mobileTextSecondary,
                            web: AppColors.textSecondary))),
              ],
            ),
          ),
        ],
      );
}

/// Kartlardaki (_CornerConditionTag, bkz. custom_product_card.dart) ile
/// BİREBİR aynı görsel imza: galerinin keskin (sol üst) köşesine flush
/// oturan, dolgun tek renk köşe etiketi — eski yüzen hap-rozetin yerini
/// alıyor. Renk dili de aynı kaynaktan (catalog_theme.dart): Sıfır = yeşil,
/// İkinci El/Spot = turuncu.
class ConditionCornerTag extends StatelessWidget {
  final Product product;

  const ConditionCornerTag({super.key, required this.product});

  @override
  Widget build(final BuildContext context) {
    final bool spot = product.isSpotProduct;
    final Color color =
        spot ? SpotPalette.accent : NewCollectionPalette.badgeGreen;
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(18)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 11),
        color: color,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              spot ? Icons.inventory_2_rounded : Icons.new_releases_rounded,
              size: 13,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              (spot
                      ? context.l10n.usedProductBadge
                      : context.l10n.newProductBadge)
                  .toUpperCase(),
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Mağaza" (orijinal) / "Stüdyo" (remove.bg, arka plansız) görsel geçişi.
class StudioToggle extends StatelessWidget {
  final bool isStudio;
  final VoidCallback onTap;

  const StudioToggle({super.key, required this.isStudio, required this.onTap});

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded, size: 13, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                isStudio
                    ? context.l10n.studioPhotoLabel
                    : context.l10n.storePhotoLabel,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
}
