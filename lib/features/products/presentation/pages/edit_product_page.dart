import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/common/extentions/app_context_ui_extension.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import '../../../../core/ads/widgets/ad_banner_widget.dart';
import '../../../../core/ads/widgets/ad_native_widget.dart';
import '../../../../core/widgets/custom_image_selector.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_mutation_provider.dart';
import '../providers/product_provider.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final String productId;
  final Product? product;

  const EditProductPage({
    super.key,
    required this.productId,
    this.product,
  });

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
  Product? _currentProduct;

  @override
  void initState() {
    super.initState();

    // Auth guard: Giriş yapılmamışsa login'e yönlendir
    Future.microtask(() {
      final auth = ref.read(authProvider).value;
      if (auth?.uid == null) context.go('/login');
    });

    // Mevcut ürün verilerini başlat
    _currentProduct = widget.product ??
        ref
            .read(productsProvider)
            .value
            ?.where((final e) => e.id == widget.productId)
            .firstOrNull;

    if (_currentProduct != null) {
      _nameController = TextEditingController(text: _currentProduct!.name);
      _priceController =
          TextEditingController(text: _currentProduct!.price.toString());
      _descController = TextEditingController(text: _currentProduct!.desc);
      _isSold = _currentProduct!.isSold;
      _isSpotProduct = _currentProduct!.isSpotProduct;
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
      return const Scaffold(body: Center(child: Text('Ürün bulunamadı')));
    }

    final mutationState = ref.watch(productMutationProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Ürünü Düzenle"),
        backgroundColor: AppColors.accentDark,
      ),
      body: Column(
        children: [
          const AdBannerWidget(), // ÜST REKLAM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section("Ürün Görselleri"),
                  const SizedBox(height: 12),
                  _buildImagePreview(),
                  const SizedBox(height: 12),
                  _imagePickerButton(),
                  const SizedBox(height: 24),
                  _section("Genel Bilgiler"),
                  const SizedBox(height: 16),
                  _buildTextField(
                      _nameController, "Ürün Adı", Icons.shopping_bag),
                  _buildTextField(_priceController, "Fiyat", Icons.attach_money,
                      isNumeric: true),
                  _buildTextField(
                      _descController, "Açıklama", Icons.description,
                      maxLines: 3),
                  const SizedBox(height: 16),
                  const AdNativeWidget(), // NATIVE REKLAM
                  const SizedBox(height: 16),
                  _section("Durum ve Kategori"),
                  _buildSwitchTile(context.l10n.sold, _isSold,
                      (final v) => setState(() => _isSold = v)),
                  _buildSwitchTile("Spot / İkinci El", _isSpotProduct,
                      (final v) => setState(() => _isSpotProduct = v)),
                  const SizedBox(height: 32),
                  _submitButton(mutationState),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const AdBannerWidget(), // ALT REKLAM
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
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
                      width: 140, fit: BoxFit.cover),
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
                          width: 140, fit: BoxFit.cover),
                    ),
                  ),
                )
              : const Center(child: Text("Görsel Yok"))),
    );
  }

  Widget _imagePickerButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final images =
              await _imageSelector.pickImages(); // ImageSelector kullanımı
          if (images.isNotEmpty) setState(() => _newSelectedImages = images);
        },
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text("Görselleri Değiştir"),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildTextField(final TextEditingController controller,
      final String label, final IconData icon,
      {final bool isNumeric = false, final int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(final String title, final bool value,
      final ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      value: value,
      activeColor: const Color(0xFF6366F1),
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _section(final String title) => Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B)),
      );

  Widget _submitButton(final AsyncValue<void> state) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : _handleUpdate,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: state.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Değişiklikleri Kaydet",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
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
      // Spot/İkinci el durumu güncelleniyor
      updatedAt: DateTime.now().toIso8601String(),
    );

    // Mutation provider üzerinden güncelleme işlemini başlat
    await ref.read(productMutationProvider.notifier).updateProduct(
          updatedProduct,
          _newSelectedImages.isEmpty ? null : _newSelectedImages,
        );

    if (mounted) Navigator.pop(context);
  }
}
