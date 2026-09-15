import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/services/firestore_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/category_meta.dart';
import '../providers/category_meta_provider.dart';
import '../widgets/admin_form_widgets.dart';

/// Admin'in Firebase Console'a HİÇ girmeden kategori görünümünü (ikon, renk,
/// sıra, aktif/pasif, özel etiket) düzenleyebildiği ekran. 'CategoryMeta'
/// koleksiyonuna doğrudan yazar — okuma tarafı için bkz.
/// category_meta_provider.dart (bu ekranın yazdığı her doküman, o provider
/// tarafından anında dinlenip tüm uygulamaya yansır).
class AdminCategorySettingsPage extends ConsumerWidget {
  const AdminCategorySettingsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final metaAsync = ref.watch(categoryMetaProvider);
    // Akış henüz ilk veriyi getirmediyse bile ekran sabit varsayılanlarla
    // anında kullanılabilir olsun (orderedActiveCategoriesProvider'daki
    // aynı yaklaşım — bkz. category_meta_provider.dart).
    final meta = metaAsync.value ?? defaultCategoryMeta;

    final categories = ProductCategory.values.toList()
      ..sort((final a, final b) =>
          (meta[a]?.order ?? 0).compareTo(meta[b]?.order ?? 0));

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      appBar: AppBar(
        title: Text(context.l10n.categorySettingsTitle,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        backgroundColor: AppColors.mobileBackground,
        foregroundColor: AppColors.mobileTextPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
              child: Text(
                context.l10n.categorySettingsSubtitle,
                style: TextStyle(
                    fontSize: 13, color: AppColors.mobileTextSecondary, height: 1.4),
              ),
            ),
            for (final category in categories)
              _CategoryEditorCard(
                // ValueKey: Firestore akışı her yeni dokümanla ekranı yeniden
                // çizdirse bile (ör. sıra değişince liste yeniden dizilir),
                // kategoriye ait State (denetleyiciler, kaydedilmemiş
                // değişiklikler) kategoriyle birlikte KORUNUR, sıfırlanmaz.
                key: ValueKey(category.name),
                category: category,
                meta: meta[category] ?? defaultCategoryMeta[category]!,
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _CategoryEditorCard extends ConsumerStatefulWidget {
  final ProductCategory category;
  final CategoryMeta meta;

  const _CategoryEditorCard({
    required super.key,
    required this.category,
    required this.meta,
  });

  @override
  ConsumerState<_CategoryEditorCard> createState() => _CategoryEditorCardState();
}

class _CategoryEditorCardState extends ConsumerState<_CategoryEditorCard> {
  // category_meta.dart'taki sabit ikon kayıt defterinden (categoryIconRegistry)
  // BESLENEN, elle uydurulmamış bir ikon/renk seçici — tek doğruluk kaynağı
  // orada kalır.
  static const List<String> _colorPalette = [
    '#2E7D6B', // Zümrüt yeşili
    '#C5A358', // Marka altını
    '#B2673E', // Sıcak ahşap
    '#6B5CA5', // Lila-indigo
    '#3E6B8A', // Petrol mavisi
    '#5A8A6B', // Adaçayı yeşili
    '#7A7F87', // Nötr gri
    '#8B5E3C', // Ceviz
    '#D32F2F', // Kırmızı
    '#1A1A1A', // Siyah
    '#5A6E6A', // Gri-yeşil
    '#E8B573', // Sıcak amber
  ];

  late final TextEditingController _labelController;
  late final TextEditingController _orderController;
  late String _selectedIconName;
  late String _selectedColorHex;
  late bool _isActive;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.meta.customLabel ?? '');
    _orderController = TextEditingController(text: widget.meta.order.toString());
    _selectedIconName = _iconNameFor(widget.meta.icon);
    _selectedColorHex = _colorToHex(widget.meta.color);
    _isActive = widget.meta.isActive;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  String _iconNameFor(final IconData icon) {
    for (final entry in categoryIconRegistry.entries) {
      if (entry.value == icon) return entry.key;
    }
    return categoryIconRegistry.keys.first;
  }

  static String _colorToHex(final Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  static Color _hexToColor(final String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(final BuildContext context) {
    final previewColor = _hexToColor(_selectedColorHex);
    final previewIcon = categoryIconRegistry[_selectedIconName] ?? widget.meta.icon;
    final defaultLabel = widget.category.label(context);

    // Mevcut renk sabit paletin dışındaysa (ör. Firestore Console'dan elle
    // girilmiş özel bir hex), listeye başa eklenir — kaydetmeden ekranı açıp
    // kapatmak rengi SESSİZCE değiştirmesin diye.
    final palette = List<String>.from(_colorPalette);
    if (!palette.contains(_selectedColorHex)) {
      palette.insert(0, _selectedColorHex);
    }

    return AdminFormSection(
      title: defaultLabel,
      icon: previewIcon,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: previewColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: previewColor.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: Icon(previewIcon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _labelController.text.trim().isEmpty
                      ? defaultLabel
                      : _labelController.text.trim(),
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary),
                ),
              ),
              if (!_isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    context.l10n.categoryInactiveBadge,
                    style: TextStyle(
                        fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.error),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          AdminFormField(
            controller: _labelController,
            label: context.l10n.customLabelOptional,
            icon: Icons.label_rounded,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 4),
            child: Text(
              context.l10n.customLabelHint,
              style: TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
            ),
          ),
          Text(context.l10n.iconLabel,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categoryIconRegistry.entries.map((final entry) {
              final isSelected = entry.key == _selectedIconName;
              return GestureDetector(
                onTap: () => setState(() => _selectedIconName = entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected ? previewColor : AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isSelected ? previewColor : AppColors.border, width: 1.4),
                  ),
                  child: Icon(entry.value,
                      size: 20, color: isSelected ? Colors.white : AppColors.textSecondary),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Text(context.l10n.colorLabel,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: palette.map((final hex) {
              final color = _hexToColor(hex);
              final isSelected = hex == _selectedColorHex;
              return GestureDetector(
                onTap: () => setState(() => _selectedColorHex = hex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isSelected ? AppColors.accent : Colors.white,
                        width: isSelected ? 3 : 2),
                    boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(isSelected ? 0.45 : 0.2),
                          blurRadius: isSelected ? 10 : 5),
                    ],
                  ),
                  child: isSelected
                      ? Icon(Icons.check_rounded,
                          size: 16,
                          color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          AdminFormField(
            controller: _orderController,
            label: context.l10n.orderLabel,
            icon: Icons.sort_rounded,
            numeric: true,
          ),
          AdminFormSwitch(
            title: context.l10n.categoryActiveLabel,
            subtitle: context.l10n.categoryActiveHint,
            value: _isActive,
            onChanged: (final v) => setState(() => _isActive = v),
          ),
          const SizedBox(height: 8),
          AdminSubmitButton(
            label: context.l10n.save,
            isLoading: _isSaving,
            onTap: _save,
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final label = _labelController.text.trim();
    final order = int.tryParse(_orderController.text.trim()) ?? widget.meta.order;

    try {
      await ref
          .read(firestoreProvider)
          .collection('CategoryMeta')
          .doc(widget.category.name)
          .set({
        'icon': _selectedIconName,
        'colorHex': _selectedColorHex,
        'order': order,
        'isActive': _isActive,
        // Boş bırakılırsa alan tamamen SİLİNİR — CategoryMeta.fromFirestore
        // bunu "özel etiket yok, çevrilmiş varsayılan isim kullanılsın"
        // olarak okur (bkz. category_meta.dart).
        'label': label.isEmpty ? FieldValue.delete() : label,
      }, SetOptions(merge: true));

      if (!mounted) return;
      _snack(context.l10n.categorySettingsSaved, success: true);
    } catch (_) {
      if (!mounted) return;
      _snack(context.l10n.categorySettingsSaveError, error: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _snack(final String msg, {final bool success = false, final bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success
            ? AppColors.success
            : error
                ? AppColors.error
                : null,
        content: Text(msg),
      ),
    );
  }
}
