import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_tokens.dart';

/// "Atölye" tasarım sisteminin mobil yapı taşları. Hepsi token'larla
/// ([AppSpacing], [AppRadius], [AppMotion], [AppShadows]) ve marka renk
/// getter'larıyla ([AppColors]) çalışır; ekranlarda ham değer yazmak
/// yerine bunlar kullanılır.

/// Ekran başlığı: serif (Fraunces) başlık + opsiyonel alt satır + sağda
/// eylemler. Başlığın altında uygulamanın imzası olan kısa "mezura"
/// çizgisi (çentikli cetvel) yer alır — her ekranda aynı, tek vurgu.
class AtelierScreenHeader extends StatelessWidget {
  const AtelierScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.leading,
    this.padding = const EdgeInsets.fromLTRB(
        AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.sm),
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? leading;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.serif(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs + 2),
                  const TapeMeasureRule(width: 56),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            for (final a in actions) ...[
              const SizedBox(width: AppSpacing.sm),
              a,
            ],
          ],
        ),
      );
}

/// Kısa mezura/cetvel çizgisi — başlıkların altındaki imza detay.
class TapeMeasureRule extends StatelessWidget {
  const TapeMeasureRule({super.key, this.width = 56, this.color});

  final double width;
  final Color? color;

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: width,
        height: 7,
        child: CustomPaint(painter: _TapePainter(color ?? AppColors.accent)),
      );
}

class _TapePainter extends CustomPainter {
  _TapePainter(this.color);
  final Color color;

  @override
  void paint(final Canvas canvas, final Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(0, size.height - 1), Offset(size.width, size.height - 1), p);
    p.strokeWidth = 1.2;
    int i = 0;
    for (double x = 0; x <= size.width; x += 6, i++) {
      final h = i % 5 == 0 ? size.height : size.height * 0.5;
      canvas.drawLine(
          Offset(x, size.height - 1), Offset(x, size.height - 1 - h), p);
    }
  }

  @override
  bool shouldRepaint(covariant final _TapePainter old) => old.color != color;
}

/// Bölüm başlığı (ekran içi): serif başlık + sağda opsiyonel eylem.
/// ALL-CAPS eyebrow yok (bkz. frontend-design skill).
class AtelierSectionHeader extends StatelessWidget {
  const AtelierSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(AppSpacing.screen,
        AppSpacing.section, AppSpacing.screen, AppSpacing.md),
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.serif(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
            ),
            if (onAction != null && actionLabel != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentDark,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  minimumSize: const Size(48, 36),
                ),
                child: Text(actionLabel!,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      );
}

/// Arama alanı — iki kipte çalışır:
/// * [controller] verilmezse "dokun → arama ekranına git" butonu
///   ([onTap] zorunlu),
/// * [controller] verilirse gerçek, düzenlenebilir alan.
/// Odakta kenarlık aksan rengine döner, ikon kayar; temizle butonu
/// yalnızca metin varken görünür.
class AtelierSearchField extends StatefulWidget {
  const AtelierSearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.trailing,
    this.autofocus = false,
  }) : assert(controller != null || onTap != null);

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final Widget? trailing;
  final bool autofocus;

  @override
  State<AtelierSearchField> createState() => _AtelierSearchFieldState();
}

class _AtelierSearchFieldState extends State<AtelierSearchField> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    widget.controller?.addListener(_onText);
  }

  @override
  void didUpdateWidget(covariant final AtelierSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onText);
      widget.controller?.addListener(_onText);
    }
  }

  void _onText() => setState(() {});

  @override
  void dispose() {
    widget.controller?.removeListener(_onText);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final focused = _focus.hasFocus;
    final editable = widget.controller != null;
    final hasText = editable && widget.controller!.text.isNotEmpty;

    final field = AnimatedContainer(
      duration: AppMotion.normal,
      curve: AppMotion.standard,
      height: 50,
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.all(AppRadius.lg),
        border: Border.all(
          color: focused ? AppColors.accent : AppColors.border,
          width: focused ? 1.6 : 1,
        ),
        boxShadow: focused
            ? AppShadows.level2(AppColors.accent)
            : AppShadows.level1(AppColors.primary),
      ),
      child: Row(
        children: [
          AnimatedSlide(
            duration: AppMotion.normal,
            curve: AppMotion.standard,
            offset: focused ? const Offset(-0.08, 0) : Offset.zero,
            child: Icon(Icons.search_rounded,
                size: 21,
                color: focused ? AppColors.accentDark : AppColors.textTertiary),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: editable
                ? TextField(
                    controller: widget.controller,
                    focusNode: _focus,
                    autofocus: widget.autofocus,
                    onChanged: widget.onChanged,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                          fontSize: 14, color: AppColors.textTertiary),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  )
                : Text(widget.hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 14, color: AppColors.textTertiary)),
          ),
          AnimatedSwitcher(
            duration: AppMotion.fast,
            child: hasText
                ? IconButton(
                    key: const ValueKey('clear'),
                    tooltip:
                        MaterialLocalizations.of(context).deleteButtonTooltip,
                    icon: Icon(Icons.close_rounded,
                        size: 19, color: AppColors.textSecondary),
                    onPressed: () {
                      widget.controller!.clear();
                      widget.onClear?.call();
                    },
                  )
                : (widget.trailing ?? const SizedBox(width: AppSpacing.md)),
          ),
        ],
      ),
    );

    if (editable) return field;
    return Semantics(
      button: true,
      label: widget.hint,
      child: GestureDetector(onTap: widget.onTap, child: field),
    );
  }
}

/// Kare, yuvarlak köşeli ikon butonu (geri, bildirim, ayar...). En az
/// 48x48 dokunma alanı.
class AtelierIconButton extends StatelessWidget {
  const AtelierIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.badgeCount = 0,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final int badgeCount;
  final bool filled;

  @override
  Widget build(final BuildContext context) => Tooltip(
        message: tooltip,
        child: Semantics(
          button: true,
          label: tooltip,
          child: Material(
            color: filled ? AppColors.primary : AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.all(AppRadius.md),
              side: filled
                  ? BorderSide.none
                  : BorderSide(color: AppColors.border),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: AppRadius.all(AppRadius.md),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Icon(icon,
                        size: 22,
                        color:
                            filled ? AppColors.white : AppColors.textPrimary),
                    if (badgeCount > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: AppRadius.all(AppRadius.pill),
                            border: Border.all(
                                color: AppColors.surface, width: 1.5),
                          ),
                          child: Text(
                            badgeCount > 9 ? '9+' : '$badgeCount',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

/// Gruplanmış yüzey (ayar listesi, admin paneli kartı). Düz, ince
/// kenarlıklı, tek seviye gölge — "her şeye gölge" yok.
class AtelierPanel extends StatelessWidget {
  const AtelierPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.signature = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// true ise imza asimetrik köşeler (ekran başına en fazla bir panel).
  final bool signature;

  @override
  Widget build(final BuildContext context) => Container(
        padding: padding,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              signature ? AppRadius.asymSm : AppRadius.all(AppRadius.lg),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.level1(AppColors.primary),
        ),
        child: child,
      );
}

/// Boş / hata durumu: ikon + ne oldu + ne yapılabilir + eylem.
class AtelierStateView extends StatelessWidget {
  const AtelierStateView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(final BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: AppRadius.asymSm,
                ),
                child: Icon(icon, size: 38, color: AppColors.accentDark),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.serif(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.sm),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: AppColors.textSecondary),
                  ),
                ),
              ],
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.all(AppRadius.pill)),
                  ),
                  child: Text(actionLabel!,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ],
          ),
        ),
      );
}

/// Yatay seçim çipi (sıralama, durum filtresi). Seçiliyken dolgulu.
class AtelierChoiceChip extends StatelessWidget {
  const AtelierChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.activeColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? activeColor;

  @override
  Widget build(final BuildContext context) {
    final active = activeColor ?? AppColors.primary;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          constraints: const BoxConstraints(minHeight: 40),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md + 2, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: selected ? active : AppColors.surface,
            borderRadius: AppRadius.all(AppRadius.pill),
            border: Border.all(color: selected ? active : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon,
                    size: 16,
                    color:
                        selected ? AppColors.white : AppColors.textSecondary),
                const SizedBox(width: AppSpacing.xs + 2),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
