import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ads/widgets/ad_banner_widget.dart';
import '../../../../core/ads/widgets/ad_native_widget.dart';
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
              const AdBannerWidget(),
              const SizedBox(height: 16),

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
      _snack(context.l10n.fillRequiredFields, error: true);
      return;
    }

    final auth = ref.read(authProvider).value;
    if (auth?.uid == null) {
      _snack(context.l10n.sessionClosed, error: true);
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

  Widget _imageSection() => SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _images.length + 1,
          separatorBuilder: (final _, final __) => const SizedBox(width: 10),
          itemBuilder: (final _, final i) {
            if (i == _images.length) return AddPhotoTile(onTap: _pickImages);
            return PhotoThumbnail(
              image: FileImage(File(_images[i].path)),
              onDelete: () => setState(() => _images.removeAt(i)),
            );
          },
        ),
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
