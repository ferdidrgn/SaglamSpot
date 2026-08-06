import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ads/widgets/ad_banner_widget.dart';
import '../../../../core/ads/widgets/ad_native_widget.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_mutation_provider.dart';
import '../widgets/admin_form_widgets.dart';
import '../widgets/category_form_selector.dart';
import '../widgets/color_variant_picker.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  ProductCategory? _selectedCategory;
  List<String> _selectedColors = [];

  final List<XFile> _images = [];
  bool _isSecondHand = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = ref.read(authProvider).value;
      if (auth?.uid == null) NavigationHandler.goToLogin(context);
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    ref.listen<AsyncValue<void>>(productMutationProvider, (final previous, final next) {
      if (next is AsyncData) {
        _snack('Ürün başarıyla eklendi', success: true);
        if (mounted) Navigator.of(context).pop();
      }
      if (next is AsyncError) _snack('Yetki veya bağlantı hatası oluştu', error: true);
    });

    final mutationState = ref.watch(productMutationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Yeni Ürün Ekle',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AdBannerWidget(),
              const SizedBox(height: 16),

              AdminFormSection(
                title: 'Ürün Görselleri',
                icon: Icons.photo_library_rounded,
                child: _imageSection(),
              ),

              AdminFormSection(
                title: 'Genel Bilgiler',
                icon: Icons.info_rounded,
                child: Column(
                  children: [
                    AdminFormField(
                        controller: _name,
                        label: 'Ürün Adı',
                        icon: Icons.shopping_bag_rounded),
                    AdminFormField(
                        controller: _price,
                        label: context.l10n.price,
                        icon: Icons.attach_money_rounded,
                        numeric: true),
                    AdminFormField(
                        controller: _desc,
                        label: 'Açıklama',
                        icon: Icons.description_rounded,
                        lines: 3),
                  ],
                ),
              ),

              AdminFormSection(
                title: 'Kategori',
                icon: Icons.category_rounded,
                child: CategoryFormSelector(
                  selected: _selectedCategory,
                  onSelect: (final c) => setState(() => _selectedCategory = c),
                ),
              ),

              AdminFormSection(
                title: 'Durum',
                icon: Icons.inventory_2_rounded,
                child: AdminFormSwitch(
                  title: 'Spot / İkinci El',
                  subtitle: _isSecondHand
                      ? 'Tek parça — renk seçeneği gösterilmeyecek'
                      : 'Sıfır ürün — aşağıdan renk seçenekleri ekleyebilirsin',
                  value: _isSecondHand,
                  onChanged: (final v) => setState(() => _isSecondHand = v),
                ),
              ),

              // Renk seçenekleri SADECE sıfır ürünlerde gösterilir — ikinci el
              // ürünlerde tek bir fiziksel parça satıldığı için anlamsız olur
              // (bkz. product_color_section.dart, vitrin tarafındaki aynı mantık).
              if (!_isSecondHand)
                AdminFormSection(
                  title: 'Renk Seçenekleri (opsiyonel)',
                  icon: Icons.palette_rounded,
                  child: ColorVariantPicker(
                    selectedHexColors: _selectedColors,
                    onChanged: (final colors) =>
                        setState(() => _selectedColors = colors),
                  ),
                ),

              const SizedBox(height: 8),
              AdminSubmitButton(
                label: context.l10n.save,
                isLoading: mutationState.isLoading,
                onTap: _submit,
              ),
              const SizedBox(height: 24),
              const AdNativeWidget(),
              const SizedBox(height: 16),
              const AdBannerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- ACTIONS ----------------

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty || _price.text.trim().isEmpty || _images.isEmpty) {
      _snack('Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!', error: true);
      return;
    }

    final auth = ref.read(authProvider).value;
    if (auth?.uid == null) {
      _snack('Oturum kapalı', error: true);
      return;
    }

    final product = Product(
      id: '',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      soldAt: '',
      name: _name.text.trim(),
      desc: _desc.text.trim(),
      category: _selectedCategory ?? ProductCategory.other,
      price: double.tryParse(_price.text.replaceAll(',', '.')) ?? 0,
      isSold: false,
      isSpotProduct: _isSecondHand,
      imagesUrl: const [],
      availableColors: _isSecondHand ? const [] : _selectedColors,
    );

    await ref
        .read(productMutationProvider.notifier)
        .add(product, _images.map((final e) => File(e.path)).toList());
  }

  // ---------------- UI HELPERS ----------------

  Widget _imageSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _images.isEmpty
              ? Container(
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.border, style: BorderStyle.solid),
                  ),
                  child: const Text('Henüz görsel eklenmedi',
                      style: TextStyle(color: AppColors.textTertiary)),
                )
              : SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    separatorBuilder: (final _, final __) => const SizedBox(width: 8),
                    itemBuilder: (final _, final i) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(File(_images[i].path),
                              width: 100, height: 100, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(() => _images.removeAt(i)),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                  color: Colors.black54, shape: BoxShape.circle),
                              child: const Icon(Icons.close_rounded,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_a_photo_rounded, size: 18),
              label: const Text('Görsel Ekle'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentDark,
                side: const BorderSide(color: AppColors.accent),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      );

  Future<void> _pickImages() async {
    final images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) setState(() => _images.addAll(images));
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
