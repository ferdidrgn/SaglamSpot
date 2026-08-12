import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ads/widgets/ad_banner_widget.dart';
import '../../../../core/ads/widgets/ad_native_widget.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_image_selector.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_mutation_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/admin_form_widgets.dart';
import '../widgets/category_form_selector.dart';
import '../widgets/color_variant_picker.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final String productId;
  final Product? product;

  const EditProductPage({super.key, required this.productId, this.product});

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;

  List<dynamic> _newSelectedImages = [];
  final ImageSelector _imageSelector = ImageSelector();

  bool _isSold = false;
  bool _isSpotProduct = false;
  ProductCategory? _selectedCategory;
  List<String> _selectedColors = [];
  Product? _currentProduct;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final auth = ref.read(authProvider).value;
      if (auth?.uid == null) NavigationHandler.goToLogin(context);
    });

    _currentProduct = widget.product;
    if (_currentProduct == null) {
      final all = ref.read(productsProvider).value ?? [];
      for (final p in all) {
        if (p.id == widget.productId) {
          _currentProduct = p;
          break;
        }
      }
    }

    if (_currentProduct != null) {
      _nameController = TextEditingController(text: _currentProduct!.name);
      _priceController = TextEditingController(text: _currentProduct!.price.toString());
      _descController = TextEditingController(text: _currentProduct!.desc);
      _isSold = _currentProduct!.isSold;
      _isSpotProduct = _currentProduct!.isSpotProduct;
      // Önceden hiç düzenlenemeyen iki alan — artık formda mevcutlar.
      _selectedCategory = _currentProduct!.category;
      _selectedColors = List<String>.from(_currentProduct!.availableColors);
    } else {
      _nameController = TextEditingController();
      _priceController = TextEditingController();
      _descController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (_currentProduct == null) {
      return Scaffold(
        backgroundColor: AppColors.mobileBackground,
        body: Center(child: Text(context.l10n.productNotFound)),
      );
    }

    final mutationState = ref.watch(productMutationProvider);

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      appBar: AppBar(
        title: Text(context.l10n.editProductTitle,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        backgroundColor: AppColors.mobileBackground,
        foregroundColor: AppColors.mobileTextPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          const AdBannerWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminFormSection(
                    title: context.l10n.productImages,
                    icon: Icons.photo_library_rounded,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImagePreview(),
                        const SizedBox(height: 12),
                        _imagePickerButton(),
                      ],
                    ),
                  ),
                  AdminFormSection(
                    title: context.l10n.generalInfo,
                    icon: Icons.info_rounded,
                    child: Column(
                      children: [
                        AdminFormField(
                            controller: _nameController,
                            label: context.l10n.productNameLabel,
                            icon: Icons.shopping_bag_rounded),
                        AdminFormField(
                            controller: _priceController,
                            label: context.l10n.price,
                            icon: Icons.attach_money_rounded,
                            numeric: true),
                        AdminFormField(
                            controller: _descController,
                            label: context.l10n.descriptionLabel,
                            icon: Icons.description_rounded,
                            lines: 3),
                      ],
                    ),
                  ),
                  const AdNativeWidget(),
                  const SizedBox(height: 16),
                  AdminFormSection(
                    title: context.l10n.category,
                    icon: Icons.category_rounded,
                    child: CategoryFormSelector(
                      selected: _selectedCategory,
                      onSelect: (final c) => setState(() => _selectedCategory = c),
                    ),
                  ),
                  AdminFormSection(
                    title: context.l10n.statusLabel,
                    icon: Icons.inventory_2_rounded,
                    child: Column(
                      children: [
                        AdminFormSwitch(
                          title: context.l10n.sold,
                          value: _isSold,
                          onChanged: (final v) => setState(() => _isSold = v),
                        ),
                        const Divider(height: 20),
                        AdminFormSwitch(
                          title: context.l10n.spotSecondHand,
                          subtitle: _isSpotProduct
                              ? context.l10n.secondHandHint
                              : context.l10n.newProductHint,
                          value: _isSpotProduct,
                          onChanged: (final v) => setState(() => _isSpotProduct = v),
                        ),
                      ],
                    ),
                  ),
                  if (!_isSpotProduct)
                    AdminFormSection(
                      title: context.l10n.colorOptionsOptional,
                      icon: Icons.palette_rounded,
                      child: ColorVariantPicker(
                        selectedHexColors: _selectedColors,
                        onChanged: (final colors) =>
                            setState(() => _selectedColors = colors),
                      ),
                    ),
                  const SizedBox(height: 8),
                  AdminSubmitButton(
                    label: context.l10n.saveChanges,
                    isLoading: mutationState.isLoading,
                    onTap: _handleUpdate,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.mobileCardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _newSelectedImages.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _newSelectedImages.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (final context, final index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(_newSelectedImages[index].path),
                      width: 100, fit: BoxFit.cover),
                ),
              ),
            )
          : (_currentProduct!.imagesUrl.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _currentProduct!.imagesUrl.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (final context, final index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(_currentProduct!.imagesUrl[index],
                          width: 100, fit: BoxFit.cover),
                    ),
                  ),
                )
              : Center(
                  child: Text(context.l10n.noImages,
                      style: const TextStyle(color: AppColors.mobileTextTertiary)))),
    );
  }

  Widget _imagePickerButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final images = await _imageSelector.pickImages();
          if (images.isNotEmpty) setState(() => _newSelectedImages = images);
        },
        icon: const Icon(Icons.add_a_photo_outlined, size: 18),
        label: Text(context.l10n.changeImages),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mobileAccentDark,
          side: const BorderSide(color: AppColors.mobileAccent),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Future<void> _handleUpdate() async {
    final updatedProduct = _currentProduct!.copyWith(
      name: _nameController.text.trim(),
      desc: _descController.text.trim(),
      price: double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0,
      isSold: _isSold,
      isSpotProduct: _isSpotProduct,
      // Önceden burada hiç güncellenmiyordu — kategori ve renkler artık
      // formdan değiştirilip kaydedilebiliyor.
      category: _selectedCategory ?? _currentProduct!.category,
      availableColors: _isSpotProduct ? const [] : _selectedColors,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await ref.read(productMutationProvider.notifier).updateProduct(
          updatedProduct,
          _newSelectedImages.isEmpty ? null : _newSelectedImages,
        );

    if (mounted) Navigator.pop(context);
  }
}
