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
                    child: _buildImagePreview(),
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
    final bool usingNew = _newSelectedImages.isNotEmpty;
    final int existingCount = usingNew ? 0 : _currentProduct!.imagesUrl.length;
    final int itemCount = (usingNew ? _newSelectedImages.length : existingCount) + 1;

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (final _, final __) => const SizedBox(width: 10),
        itemBuilder: (final _, final i) {
          if (i == itemCount - 1) {
            return AddPhotoTile(onTap: _pickNewImages);
          }
          if (usingNew) {
            return PhotoThumbnail(
              image: FileImage(File(_newSelectedImages[i].path)),
              onDelete: () => setState(() => _newSelectedImages.removeAt(i)),
            );
          }
          return PhotoThumbnail(
            image: NetworkImage(_currentProduct!.imagesUrl[i]),
            onDelete: () => setState(
                () => _currentProduct = _currentProduct!.copyWith(
                    imagesUrl: [..._currentProduct!.imagesUrl]..removeAt(i))),
          );
        },
      ),
    );
  }

  Future<void> _pickNewImages() async {
    final images = await _imageSelector.pickImages();
    if (images.isNotEmpty) setState(() => _newSelectedImages = images);
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
