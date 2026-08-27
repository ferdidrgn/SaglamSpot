import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/studio_image_service.dart';
import '../../../../core/theme/app_colors.dart';
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
        final bool studioQuotaHit = StudioImageService.quotaExceededNotifier.value;
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
      if (next is AsyncError) _snack(context.l10n.authOrConnectionError, error: true);
    });

    final mutationState = ref.watch(productMutationProvider);

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      appBar: AppBar(
        title: Text(context.l10n.addNewProduct,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        backgroundColor: AppColors.mobileBackground,
        foregroundColor: AppColors.mobileTextPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                    AdminFormField(
                        controller: _name,
                        label: context.l10n.productNameLabel,
                        icon: Icons.shopping_bag_rounded),
                    AdminFormField(
                        controller: _price,
                        label: context.l10n.price,
                        icon: Icons.attach_money_rounded,
                        numeric: true),
                    AdminFormField(
                        controller: _desc,
                        label: context.l10n.descriptionLabel,
                        icon: Icons.description_rounded,
                        lines: 3),
                  ],
                ),
              ),

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
                  title: 'Ürün Durumu',
                  icon: Icons.fact_check_outlined,
                  child: WearTierFormSelector(
                    selected: _selectedWearTier,
                    onSelect: (final t) => setState(() => _selectedWearTier = t),
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
    );
  }

  // ---------------- ACTIONS ----------------

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty || _price.text.trim().isEmpty || _images.isEmpty) {
      _snack(context.l10n.fillRequiredFields, error: true);
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
                width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4)),
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

  Widget _imageSection() {
    final showStudioTile = _isGeneratingStudio || _studioImageUrl != null || _studioFailed;
    final itemCount = _images.length + (showStudioTile ? 1 : 0) + 1;

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (final _, final __) => const SizedBox(width: 10),
        itemBuilder: (final _, final i) {
          if (i < _images.length) {
            return PhotoThumbnail(
              image: FileImage(File(_images[i].path)),
              onDelete: () => setState(() {
                _images.removeAt(i);
                // İlk fotoğraf silindiyse, ona dayanan stüdyo önizlemesi
                // artık geçersiz — temizle (yeniden üretmiyoruz, admin
                // isterse kalan fotoğraflarla devam eder).
                if (i == 0) {
                  _studioImageUrl = null;
                  _studioFuture = null;
                  _studioFailed = false;
                }
              }),
            );
          }
          if (showStudioTile && i == _images.length) {
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
          return AddPhotoTile(onTap: _pickImages);
        },
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
    _studioFuture = _images.first.readAsBytes().then(StudioImageService.generate).then((final outcome) {
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
            _snack('${context.l10n.studioGenerationFailed}: ${outcome.errorMessage}', error: true);
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
