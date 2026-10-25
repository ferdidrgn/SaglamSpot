import 'package:flutter/material.dart';
import '../../core/common/enum/enums.dart';
import '../../core/common/extentions/app_context_ui_extension.dart';
import '../../core/common/extentions/product_category_ex.dart';
import '../../core/theme/app_colors.dart';
import '../../core/util/comminucation_actions.dart';
import '../../core/widgets/design_system/atelier_components.dart';
import '../../features/products/data/models/category_meta.dart';

/// Bütçe aralığı seçenekleri — fiyat filtresi gibi serbest bir aralık
/// yerine, WhatsApp mesajına doğrudan dökülebilecek üç basit hazır
/// seçenek (+ "farketmez"). Arama sayfasındaki fiyat filtresiyle KARIŞTIRILMAZ
/// — bu sihirbaz ürün listesini filtrelemiyor, doğrudan esnafa gönderilecek
/// bir mesaj oluşturuyor.
enum _BudgetTier { any, economic, mid, premium }

extension on _BudgetTier {
  String label(final BuildContext context) {
    switch (this) {
      case _BudgetTier.any:
        return context.l10n.productFinderBudgetAny;
      case _BudgetTier.economic:
        return context.l10n.productFinderBudgetEconomic;
      case _BudgetTier.mid:
        return context.l10n.productFinderBudgetMid;
      case _BudgetTier.premium:
        return context.l10n.productFinderBudgetPremium;
    }
  }
}

/// "Ne Arıyorsun?" sihirbazı — küçük envanterde ürün aramak yerine, üç kısa
/// soruyla (kategori / durum / bütçe) ziyaretçinin ne istediğini anlayıp
/// esnafa hazır bir WhatsApp mesajı olarak ileten hafif bir akış. Sepete
/// ekleme/ödeme YOK — tek çıktı, önceden doldurulmuş bir WhatsApp mesajı.
Future<void> showProductFinderWizard(final BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (final _) => const _ProductFinderWizard(),
  );
}

class _ProductFinderWizard extends StatefulWidget {
  const _ProductFinderWizard();

  @override
  State<_ProductFinderWizard> createState() => _ProductFinderWizardState();
}

class _ProductFinderWizardState extends State<_ProductFinderWizard> {
  int _step = 0;
  ProductCategory? _category;
  ProductCondition? _condition;
  _BudgetTier? _budget;

  static const int _stepCount = 3;

  bool get _canAdvance {
    switch (_step) {
      case 0:
        return _category != null;
      case 1:
        return _condition != null;
      case 2:
        return _budget != null;
      default:
        return false;
    }
  }

  void _next() {
    if (!_canAdvance) return;
    if (_step < _stepCount - 1) {
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() => _step--);
  }

  void _finish() {
    final String categoryLabel = _category!.label(context);
    final String conditionLabel = _condition!.label(context);
    final String budgetLabel = _budget!.label(context);

    Navigator.pop(context);
    SaglamSpotCommunication.launchWhatsApp(
      message: context.l10n.productFinderWhatsappMessage(
        categoryLabel,
        conditionLabel,
        budgetLabel,
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _CategoryStep(
          key: const ValueKey('category'),
          selected: _category,
          onSelect: (final c) {
            setState(() => _category = c);
            _next();
          },
        );
      case 1:
        return _ConditionStep(
          key: const ValueKey('condition'),
          selected: _condition,
          onSelect: (final c) {
            setState(() => _condition = c);
            _next();
          },
        );
      case 2:
        return _BudgetStep(
          key: const ValueKey('budget'),
          selected: _budget,
          onSelect: (final b) {
            setState(() => _budget = b);
            _next();
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    AtelierIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                      onTap: _back,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.l10n.productFinderTitle,
                        style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        _stepCount,
                        (final i) => Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i <= _step
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _buildStep(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryStep extends StatelessWidget {
  const _CategoryStep({super.key, required this.selected, required this.onSelect});

  final ProductCategory? selected;
  final ValueChanged<ProductCategory> onSelect;

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.category,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: defaultCategoryMeta.values
                .map((final CategoryMeta meta) => AtelierChoiceChip(
                      label: meta.category.label(context),
                      icon: meta.icon,
                      selected: selected == meta.category,
                      activeColor: meta.color,
                      onTap: () => onSelect(meta.category),
                    ))
                .toList(),
          ),
        ],
      );
}

class _ConditionStep extends StatelessWidget {
  const _ConditionStep({super.key, required this.selected, required this.onSelect});

  final ProductCondition? selected;
  final ValueChanged<ProductCondition> onSelect;

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.condition,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ProductCondition.values
                .map((final c) => AtelierChoiceChip(
                      label: c.label(context),
                      selected: selected == c,
                      onTap: () => onSelect(c),
                    ))
                .toList(),
          ),
        ],
      );
}

class _BudgetStep extends StatelessWidget {
  const _BudgetStep({super.key, required this.selected, required this.onSelect});

  final _BudgetTier? selected;
  final ValueChanged<_BudgetTier> onSelect;

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.productFinderBudgetLabel,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _BudgetTier.values
                .map((final b) => AtelierChoiceChip(
                      label: b.label(context),
                      selected: selected == b,
                      onTap: () => onSelect(b),
                    ))
                .toList(),
          ),
        ],
      );
}
