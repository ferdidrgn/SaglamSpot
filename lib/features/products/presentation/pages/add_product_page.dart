import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/studio_image_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/action_feedback.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_mutation_provider.dart';
import '../widgets/admin_form_widgets.dart';
import '../widgets/category_form_selector.dart';
import '../widgets/color_variant_picker.dart';
import '../widgets/wear_tier_form_selector.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _dimensions = TextEditingController();
  final _material = TextEditingController();
  ProductCategory? _selectedCategory;
  List<String> _selectedColors = [];
  ProductWearTier? _selectedWearTier;

  final List<XFile> _images = [];
  bool _isSecondHand = false;

  // İlk fotoğraf SEÇİLİR SEÇİLMEZ (kaydet'e basmadan çok önce) arka planda
  // stüdyo (arka plansız) önizlemesi üretilmeye başlanır — bkz.
  // _generateStudioPreview. `_studioFuture` kaydet anında hâlâ devam
  // ediyorsa admin'in beklemesi için tutuluyor (bkz. _submit).
  Future<void>? _studioFuture;
  bool _isGeneratingStudio = false;
  String? _studioImageUrl;
  bool _studioFailed = false;
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
      if (!_nameFocus.hasFocus) _refreshNameError();
    });
    _priceFocus.addListener(() {
      if (!_priceFocus.hasFocus) _refreshPriceError();
    });
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
    _dimensions.dispose();
    _material.dispose();
    _scrollController.dispose();
    _nameFocus.dispose();
    _priceFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  bool get _dirty =>
      _name.text.trim().isNotEmpty ||
      _price.text.trim().isNotEmpty ||
      _desc.text.trim().isNotEmpty ||
      _dimensions.text.trim().isNotEmpty ||
      _material.text.trim().isNotEmpty ||
      _images.isNotEmpty ||
      _selectedCategory != null ||
      _isSecondHand;

  void _refreshNameError() {
    if (!mounted) return;
    final missing = _name.text.trim().isEmpty;
    setState(() => _nameError = missing ? context.l10n.fieldNameRequired : null);
  }

  void _refreshPriceError() {
    if (!mounted) return;
    final price = double.tryParse(_price.text.trim().replaceAll(',', '.'));
    setState(() => _priceError =
        price == null || price <= 0 ? context.l10n.fieldPriceRequired : null);
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
    ref.listen<AsyncValue<void>>(productMutationProvider,
        (final previous, final next) {
      if (next is AsyncData) {
        _leaveAllowed = true;
        final bool studioQuotaHit =
            StudioImageService.quotaExceededNotifier.value;
        StudioImageService.quotaExceededNotifier.value = false;
        _snack(context.l10n.productAddedSuccess, success: true);
        if (studioQuotaHit) {
          // Sayfa kapanmadan önce ikinci bildirimin de görünmesi için kısa
          // bir gecikme — SnackBar, gösterildiği Scaffold pop edilince kaybolur.
          Future.delayed(const Duration(milliseconds: 1600), () {
            if (!mounted) return;
            _snack(context.l10n.studioQuotaExceededNotice);
            Future.delayed(const Duration(milliseconds: 1600),
                () => mounted ? Navigator.of(context).pop() : null);
          });
        } else if (mounted) {
          Navigator.of(context).pop();
        }
      }
      if (next is AsyncError)
        _snack(context.l10n.authOrConnectionError, error: true);
    });

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
        title: Text(context.l10n.addNewProduct,
            style: AppTextStyles.serif(
                fontWeight: FontWeight.w700,
                fontSize: 21,
                color: AppColors.mobileTextPrimary)),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.mobileTextPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              // Geniş masaüstü pencerelerinde form tüm ekrana yayılıp
              // okunması zorlaşmasın diye — telefon genişliğinde zaten
              // etkisiz (ekran ondan dar).
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminFormSection(
                    title: context.l10n.productImages,
                    icon: Icons.photo_library_rounded,
                    child: _imageSection(),
                  ),

                  AdminFormSection(
                    title: context.l10n.generalInfo,
                    icon: Icons.info_rounded,
                    child: Column(
                      children: [
                        KeyedSubtree(
                          key: _nameKey,
                          child: AdminFormField(
                              controller: _name,
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
                              controller: _price,
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
                            controller: _desc,
                            focusNode: _descFocus,
                            textInputAction: TextInputAction.newline,
                            label: context.l10n.descriptionLabel,
                            icon: Icons.description_rounded,
                            lines: 3),
                        AdminFormField(
                            controller: _dimensions,
                            label: context.l10n.dimensionsLabel,
                            icon: Icons.straighten_rounded,
                            hintText: context.l10n.dimensionsHint),
                        AdminFormField(
                            controller: _material,
                            label: context.l10n.materialLabel,
                            icon: Icons.texture_rounded,
                            hintText: context.l10n.materialHint),
                      ],
                    ),
                  ),

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
                    child: AdminFormSwitch(
                      title: context.l10n.spotSecondHand,
                      subtitle: _isSecondHand
                          ? context.l10n.secondHandHint
                          : context.l10n.newProductHint,
                      value: _isSecondHand,
                      onChanged: (final v) => setState(() => _isSecondHand = v),
                    ),
                  ),

                  // Yıpranma seviyesi SADECE ikinci el ürünlerde gösterilir —
                  // vitrindeki "durum rozeti" bu bilgiyi kullanır (bkz.
                  // spot_products_page.dart). Boş bırakılırsa kartta rozet
                  // görünmez, uydurma bir değer ATANMAZ.
                  if (_isSecondHand)
                    AdminFormSection(
                      title: context.l10n.productConditionSectionTitle,
                      icon: Icons.fact_check_outlined,
                      child: WearTierFormSelector(
                        selected: _selectedWearTier,
                        onSelect: (final t) =>
                            setState(() => _selectedWearTier = t),
                      ),
                    ),

                  // Renk seçenekleri SADECE sıfır ürünlerde gösterilir — ikinci el
                  // ürünlerde tek bir fiziksel parça satıldığı için anlamsız olur
                  // (bkz. product_color_section.dart, vitrin tarafındaki aynı mantık).
                  if (!_isSecondHand)
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
                    label: context.l10n.save,
                    isLoading: mutationState.isLoading,
                    onTap: _submit,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    )));
  }

  // ---------------- ACTIONS ----------------

  Future<void> _submit() async {
    if (ref.read(productMutationProvider).isLoading) return;
    final nameMissing = _name.text.trim().isEmpty;
    final price =
        double.tryParse(_price.text.trim().replaceAll(',', '.'));
    final priceMissing = price == null || price <= 0;
    setState(() {
      _nameError = nameMissing ? context.l10n.fieldNameRequired : null;
      _priceError = priceMissing ? context.l10n.fieldPriceRequired : null;
    });
    if (nameMissing || priceMissing || _images.isEmpty || _selectedCategory == null) {
      if (nameMissing) {
        _reveal(_nameKey);
        _nameFocus.requestFocus();
      } else if (priceMissing) {
        _reveal(_priceKey);
        _priceFocus.requestFocus();
      } else {
        _snack(context.l10n.fillRequiredFields, error: true);
      }
      return;
    }

    final auth = ref.read(authProvider).value;
    if (auth?.uid == null) {
      _snack(context.l10n.sessionClosed, error: true);
      return;
    }

    // Stüdyo önizlemesi hâlâ üretiliyorsa, kaydetmeden önce bitmesini
    // bekle — admin'e bunu bir diyalogla belli et.
    if (_isGeneratingStudio && _studioFuture != null) {
      await _waitForStudioPreview();
      if (!mounted) return;
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
      dimensions:
          _dimensions.text.trim().isEmpty ? null : _dimensions.text.trim(),
      material: _material.text.trim().isEmpty ? null : _material.text.trim(),
      imagesUrl: const [],
      availableColors: _isSecondHand ? const [] : _selectedColors,
      studioImagesUrl: _studioImageUrl != null ? [_studioImageUrl!] : const [],
      wearTier: _isSecondHand ? _selectedWearTier : null,
    );

    await ref
        .read(productMutationProvider.notifier)
        .add(product, _images.map((final e) => File(e.path)).toList());
  }

  /// Stüdyo önizlemesi kaydet anında hâlâ sürüyorsa, bitene kadar
  /// kapatılamayan bir bekleme diyalogu gösterir.
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

  // ---------------- UI HELPERS ----------------

  void _removeImageAt(final int index) {
    final removed = _images[index];
    setState(() {
      _images.removeAt(index);
      if (index == 0) {
        _studioImageUrl = null;
        _studioFuture = null;
        _studioFailed = false;
      }
    });
    showUndoSnackBar(
      context: context,
      message: context.l10n.photoRemoved,
      onUndo: () {
        if (!mounted) return;
        setState(() {
          final insertAt = index.clamp(0, _images.length);
          _images.insert(insertAt, removed);
        });
      },
    );
  }

  Widget _imageSection() {
    final showStudioTile =
        _isGeneratingStudio || _studioImageUrl != null || _studioFailed;

    return SizedBox(
      height: 108,
      child: Row(
        children: [
          Expanded(
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              buildDefaultDragHandles: true,
              onReorder: (final oldIndex, final newIndex) {
                setState(() {
                  var target = newIndex;
                  if (target > oldIndex) target -= 1;
                  final item = _images.removeAt(oldIndex);
                  _images.insert(target, item);
                  if (oldIndex == 0 || target == 0) {
                    _studioImageUrl = null;
                    _studioFuture = null;
                    _studioFailed = false;
                  }
                });
              },
              children: [
                for (var i = 0; i < _images.length; i++)
                  Padding(
                    key: ValueKey(_images[i].path),
                    padding: const EdgeInsets.only(right: 10),
                    child: PhotoThumbnail(
                      image: FileImage(File(_images[i].path)),
                      onDelete: () => _removeImageAt(i),
                    ),
                  ),
              ],
            ),
          ),
          if (showStudioTile)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: StudioPhotoTile(
                isLoading: _isGeneratingStudio,
                imageUrl: _studioImageUrl,
                hasError: _studioFailed,
                onDiscard: () => setState(() {
                  _studioImageUrl = null;
                  _studioFailed = false;
                }),
                onRetry: _generateStudioPreview,
              ),
            ),
          AddPhotoTile(onTap: _pickImages),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    final images = await ImagePicker().pickMultiImage();
    if (images.isEmpty) return;
    final wasEmpty = _images.isEmpty;
    setState(() => _images.addAll(images));
    // Stüdyo önizlemesi sadece İLK kez fotoğraf eklendiğinde (ya da ilk
    // fotoğraf daha önce silinip yeniden eklendiğinde) tetiklenir — aylık
    // kotayı korumak için her zaman yalnızca "kapak" fotoğrafı işlenir.
    if (wasEmpty || _studioFuture == null) _generateStudioPreview();
  }

  /// İlk fotoğrafı, henüz Storage'a hiç yüklenmeden ham bayt olarak
  /// remove.bg tabanlı Cloud Function'a gönderir. Kaydet'e basılmadan
  /// çok önce çalışır — admin sonucu fotoğraf şeridinde görür. Başarısız
  /// olursa SESSİZCE KAYBOLMAZ — hata karosu + gerçek hata mesajıyla bir
  /// SnackBar gösterilir (bkz. StudioImageService.generate errorMessage).
  void _generateStudioPreview() {
    if (_images.isEmpty || _isGeneratingStudio) return;
    setState(() {
      _isGeneratingStudio = true;
      _studioFailed = false;
    });
    _studioFuture = _images.first
        .readAsBytes()
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
            _snack(
                '${context.l10n.studioGenerationFailed}: ${outcome.errorMessage}',
                error: true);
          }
        } else {
          // Kota doldu — sessizce (StudioQuotaExceededNotice zaten kaydet
          // sonrası gösteriliyor), hata karosu değil, hiçbir karo göstermez.
          _studioImageUrl = null;
          _studioFailed = false;
        }
      });
    });
  }

  void _snack(final String msg,
      {final bool success = false, final bool error = false}) {
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
