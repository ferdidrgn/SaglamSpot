import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/studio_image_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_image_selector.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_mutation_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/admin_form_widgets.dart';
import '../widgets/category_form_selector.dart';
import '../widgets/color_variant_picker.dart';
import '../widgets/wear_tier_form_selector.dart';

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
  late TextEditingController _dimensionsController;
  late TextEditingController _materialController;

  List<dynamic> _newSelectedImages = [];
  final ImageSelector _imageSelector = ImageSelector();

  // Yeni fotoğraflar seçilince (ilk fotoğraf değiştiği için) eski stüdyo
  // görseli geçersiz kalır — yeni ilk fotoğraf için eşdeğerini yeniden
  // üretiyoruz, tıpkı add_product_page.dart'taki gibi.
  Future<void>? _studioFuture;
  bool _isGeneratingStudio = false;
  String? _studioImageUrl;
  bool _studioFailed = false;

  bool _isSold = false;
  bool _isSpotProduct = false;
  bool _isReserved = false;
  ProductCategory? _selectedCategory;
  List<String> _selectedColors = [];
  ProductWearTier? _selectedWearTier;
  Product? _currentProduct;
  bool _leaveAllowed = false;
  String? _nameError;
  String? _priceError;
  final _scrollController = ScrollController();
  final _nameKey = GlobalKey();
  final _priceKey = GlobalKey();
  final _nameFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _descFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(() {
      if (!mounted || _nameFocus.hasFocus) return;
      setState(() => _nameError = _nameController.text.trim().isEmpty
          ? context.l10n.fieldNameRequired
          : null);
    });
    _priceFocus.addListener(() {
      if (!mounted || _priceFocus.hasFocus) return;
      final price =
          double.tryParse(_priceController.text.trim().replaceAll(',', '.'));
      setState(() => _priceError =
          price == null || price <= 0 ? context.l10n.fieldPriceRequired : null);
    });
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
      _priceController =
          TextEditingController(text: _currentProduct!.price.toString());
      _descController = TextEditingController(text: _currentProduct!.desc);
      _dimensionsController =
          TextEditingController(text: _currentProduct!.dimensions ?? '');
      _materialController =
          TextEditingController(text: _currentProduct!.material ?? '');
      _isSold = _currentProduct!.isSold;
      _isSpotProduct = _currentProduct!.isSpotProduct;
      _isReserved = _currentProduct!.isReserved;
      // Önceden hiç düzenlenemeyen iki alan — artık formda mevcutlar.
      _selectedCategory = _currentProduct!.category;
      _selectedColors = List<String>.from(_currentProduct!.availableColors);
      _selectedWearTier = _currentProduct!.wearTier;
    } else {
      _nameController = TextEditingController();
      _priceController = TextEditingController();
      _descController = TextEditingController();
      _dimensionsController = TextEditingController();
      _materialController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _dimensionsController.dispose();
    _materialController.dispose();
    _scrollController.dispose();
    _nameFocus.dispose();
    _priceFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  bool get _dirty {
    final product = _currentProduct;
    if (product == null) return false;
    return _nameController.text != product.name ||
        _priceController.text != product.price.toString() ||
        _descController.text != product.desc ||
        _dimensionsController.text != (product.dimensions ?? '') ||
        _materialController.text != (product.material ?? '') ||
        _isSold != product.isSold ||
        _isSpotProduct != product.isSpotProduct ||
        _isReserved != product.isReserved ||
        _selectedCategory != product.category ||
        _newSelectedImages.isNotEmpty;
  }

  void _reveal(final GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(target,
        alignment: 0.2, duration: const Duration(milliseconds: 220));
  }

  Future<void> _onLeaveAttempt() async {
    if (!_dirty || _leaveAllowed) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    final leave = await confirmDiscardChanges(context);
    if (!leave || !mounted) return;
    setState(() => _leaveAllowed = true);
    await Future<void>.delayed(Duration.zero);
    if (mounted) Navigator.of(context).pop();
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

    return PopScope(
      canPop: !_dirty || _leaveAllowed,
      onPopInvokedWithResult: (final didPop, final _) {
        if (didPop) return;
        _onLeaveAttempt();
      },
      child: AtelierBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(context.l10n.editProductTitle,
            style: AppTextStyles.serif(
                fontWeight: FontWeight.w700,
                fontSize: 21,
                color: AppColors.mobileTextPrimary)),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.mobileTextPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
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
                            KeyedSubtree(
                              key: _nameKey,
                              child: AdminFormField(
                                  controller: _nameController,
                                  focusNode: _nameFocus,
                                  errorText: _nameError,
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (final _) =>
                                      _priceFocus.requestFocus(),
                                  label: context.l10n.productNameLabel,
                                  icon: Icons.shopping_bag_rounded),
                            ),
                            KeyedSubtree(
                              key: _priceKey,
                              child: AdminFormField(
                                  controller: _priceController,
                                  focusNode: _priceFocus,
                                  errorText: _priceError,
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (final _) =>
                                      _descFocus.requestFocus(),
                                  label: context.l10n.price,
                                  icon: Icons.attach_money_rounded,
                                  numeric: true),
                            ),
                            AdminFormField(
                                controller: _descController,
                                focusNode: _descFocus,
                                textInputAction: TextInputAction.newline,
                                label: context.l10n.descriptionLabel,
                                icon: Icons.description_rounded,
                                lines: 3),
                            AdminFormField(
                                controller: _dimensionsController,
                                label: context.l10n.dimensionsLabel,
                                icon: Icons.straighten_rounded,
                                hintText: context.l10n.dimensionsHint),
                            AdminFormField(
                                controller: _materialController,
                                label: context.l10n.materialLabel,
                                icon: Icons.texture_rounded,
                                hintText: context.l10n.materialHint),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      AdminFormSection(
                        title: context.l10n.category,
                        icon: Icons.category_rounded,
                        child: CategoryFormSelector(
                          selected: _selectedCategory,
                          onSelect: (final c) =>
                              setState(() => _selectedCategory = c),
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
                              onChanged: (final v) => setState(() {
                                _isSold = v;
                                // Satıldı işaretlenince rezerve durumu
                                // anlamsızlaşır — biri satıldıysa artık
                                // "başkası için ayrılmış" olamaz.
                                if (v) _isReserved = false;
                              }),
                            ),
                            if (!_isSold) ...[
                              const Divider(height: 20),
                              AdminFormSwitch(
                                title: context.l10n.reservedToggleLabel,
                                subtitle: context.l10n.reservedHint,
                                value: _isReserved,
                                onChanged: (final v) =>
                                    setState(() => _isReserved = v),
                              ),
                            ],
                            const Divider(height: 20),
                            AdminFormSwitch(
                              title: context.l10n.spotSecondHand,
                              subtitle: _isSpotProduct
                                  ? context.l10n.secondHandHint
                                  : context.l10n.newProductHint,
                              value: _isSpotProduct,
                              onChanged: (final v) =>
                                  setState(() => _isSpotProduct = v),
                            ),
                          ],
                        ),
                      ),
                      if (_isSpotProduct)
                        AdminFormSection(
                          title: context.l10n.productConditionSectionTitle,
                          icon: Icons.fact_check_outlined,
                          child: WearTierFormSelector(
                            selected: _selectedWearTier,
                            onSelect: (final t) =>
                                setState(() => _selectedWearTier = t),
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
            ),
          ),
        ],
      ),
    )));
  }

  Widget _buildImagePreview() {
    final existing = _currentProduct!.imagesUrl;
    final fresh = _newSelectedImages;
    final bool showStudioTile = fresh.isNotEmpty &&
        (_isGeneratingStudio || _studioImageUrl != null || _studioFailed);
    final int itemCount =
        existing.length + fresh.length + (showStudioTile ? 1 : 0) + 1;

    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (final _, final __) => const SizedBox(width: 10),
        itemBuilder: (final _, final i) {
          if (i < existing.length) {
            return PhotoThumbnail(
              image: NetworkImage(existing[i]),
              onDelete: () => setState(() => _currentProduct = _currentProduct!
                  .copyWith(imagesUrl: [...existing]..removeAt(i))),
            );
          }
          final freshIndex = i - existing.length;
          if (freshIndex < fresh.length) {
            final dynamic raw = fresh[freshIndex];
            final ImageProvider imageProvider =
                raw is Uint8List ? MemoryImage(raw) : FileImage(raw as File);
            return PhotoThumbnail(
              image: imageProvider,
              onDelete: () => setState(() {
                _newSelectedImages.removeAt(freshIndex);
                if (_newSelectedImages.isEmpty) {
                  _studioImageUrl = null;
                  _studioFuture = null;
                  _studioFailed = false;
                }
              }),
            );
          }
          if (showStudioTile && i == existing.length + fresh.length) {
            return StudioPhotoTile(
              isLoading: _isGeneratingStudio,
              imageUrl: _studioImageUrl,
              hasError: _studioFailed,
              onDiscard: () => setState(() {
                _studioImageUrl = null;
                _studioFailed = false;
              }),
              onRetry: _generateStudioPreview,
            );
          }
          return AddPhotoTile(onTap: _pickNewImages);
        },
      ),
    );
  }

  Future<void> _pickNewImages() async {
    final images = await _imageSelector.pickImages();
    if (images.isEmpty) return;
    setState(() {
      final bool firstBatch = _newSelectedImages.isEmpty;
      _newSelectedImages = [..._newSelectedImages, ...images];
      if (firstBatch) {
        _studioImageUrl = null;
        _studioFailed = false;
      }
    });
    if (_studioImageUrl == null) _generateStudioPreview();
  }

  Future<Uint8List> _bytesOf(final dynamic image) async =>
      image is Uint8List ? image : (image as File).readAsBytes();

  /// Yeni seçilen ilk fotoğrafı, henüz Storage'a hiç yüklenmeden ham bayt
  /// olarak remove.bg tabanlı Cloud Function'a gönderir (bkz.
  /// add_product_page.dart'taki eşdeğeri — aynı desen, aynı hata karosu).
  void _generateStudioPreview() {
    if (_newSelectedImages.isEmpty || _isGeneratingStudio) return;
    setState(() {
      _isGeneratingStudio = true;
      _studioFailed = false;
    });
    _studioFuture = _bytesOf(_newSelectedImages.first)
        .then(StudioImageService.generate)
        .then((final outcome) {
      if (!mounted) return;
      setState(() {
        _isGeneratingStudio = false;
        if (outcome.result == StudioImageResult.success) {
          _studioImageUrl = outcome.studioImageUrl;
          _studioFailed = false;
        } else if (outcome.result == StudioImageResult.failed) {
          _studioImageUrl = null;
          _studioFailed = true;
          if (outcome.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.error,
              content: Text(
                  '${context.l10n.studioGenerationFailed}: ${outcome.errorMessage}'),
            ));
          }
        } else {
          _studioImageUrl = null;
          _studioFailed = false;
        }
      });
    });
  }

  Future<void> _waitForStudioPreview() async {
    unawaited(showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (final _) => AlertDialog(
        content: Row(
          children: [
            const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4)),
            const SizedBox(width: 16),
            Expanded(child: Text(context.l10n.studioPreparingWait)),
          ],
        ),
      ),
    ));
    await _studioFuture;
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _handleUpdate() async {
    if (ref.read(productMutationProvider).isLoading) return;
    final nameMissing = _nameController.text.trim().isEmpty;
    final price = double.tryParse(
        _priceController.text.trim().replaceAll(',', '.'));
    final priceMissing = price == null || price <= 0;
    setState(() {
      _nameError = nameMissing ? context.l10n.fieldNameRequired : null;
      _priceError = priceMissing ? context.l10n.fieldPriceRequired : null;
    });
    if (nameMissing || priceMissing) {
      if (nameMissing) {
        _reveal(_nameKey);
        _nameFocus.requestFocus();
      } else {
        _reveal(_priceKey);
        _priceFocus.requestFocus();
      }
      return;
    }
    final bool pickedNewImages = _newSelectedImages.isNotEmpty;

    // Yeni fotoğraflar seçildiyse ve stüdyo önizlemesi hâlâ üretiliyorsa,
    // kaydetmeden önce bitmesini bekle.
    if (pickedNewImages && _isGeneratingStudio && _studioFuture != null) {
      await _waitForStudioPreview();
      if (!mounted) return;
    }

    final double newPrice =
        double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0;
    // Fiyat gerçekten düşürüldüyse eski fiyatı sakla — kartlardaki
    // "İndirimde" rozeti bunu kullanır (bkz. custom_product_card.dart).
    // Fiyat artmış/aynı kalmışsa dokunma: rozet zaten previousPrice >
    // price koşuluna bakıyor, kendiliğinden görünmez olur.
    final double? newPreviousPrice =
        (newPrice < _currentProduct!.price && _currentProduct!.price > 0)
            ? _currentProduct!.price
            : null;

    final updatedProduct = _currentProduct!.copyWith(
      name: _nameController.text.trim(),
      desc: _descController.text.trim(),
      price: newPrice,
      previousPrice: newPreviousPrice,
      isSold: _isSold,
      isSpotProduct: _isSpotProduct,
      isReserved: _isReserved,
      dimensions: _dimensionsController.text.trim().isEmpty
          ? null
          : _dimensionsController.text.trim(),
      material: _materialController.text.trim().isEmpty
          ? null
          : _materialController.text.trim(),
      // Önceden burada hiç güncellenmiyordu — kategori ve renkler artık
      // formdan değiştirilip kaydedilebiliyor.
      category: _selectedCategory ?? _currentProduct!.category,
      availableColors: _isSpotProduct ? const [] : _selectedColors,
      wearTier: _isSpotProduct ? _selectedWearTier : null,
      updatedAt: DateTime.now().toIso8601String(),
      // Yeni fotoğraf seçilmediyse mevcut stüdyo görselini koru (alan
      // belirtilmezse copyWith zaten eskisini tutar); seçildiyse yeni
      // üretilen (veya üretilemediyse boş) versiyonla değiştir.
      studioImagesUrl: pickedNewImages
          ? (_studioImageUrl != null ? [_studioImageUrl!] : const [])
          : null,
    );

    await ref.read(productMutationProvider.notifier).updateProduct(
          updatedProduct,
          _newSelectedImages.isEmpty ? null : _newSelectedImages,
        );

    final bool studioQuotaHit = StudioImageService.quotaExceededNotifier.value;
    StudioImageService.quotaExceededNotifier.value = false;

    if (!mounted) return;
    if (studioQuotaHit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.studioQuotaExceededNotice)),
      );
      await Future.delayed(const Duration(milliseconds: 1600));
    }
    if (!mounted) return;
    setState(() => _leaveAllowed = true);
    await Future<void>.delayed(Duration.zero);
    if (mounted) Navigator.pop(context);
  }
}
