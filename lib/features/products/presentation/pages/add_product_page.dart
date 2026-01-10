import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/custom_image_selector.dart';
import '../../domain/entites/product.dart';
import '../providers/product_provider.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _imageSelector = ImageSelector();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();

  final List<dynamic> _selectedImages = [];
  bool _isSold = false;
  bool _isSecondHand = false;

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Yeni Ürün Ekle')),
      body: Column(
        children: [
          const AdBannerWidget(), // Sayfa Başı Reklam
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildTextField(
                            _nameController, 'Ürün Adı', Icons.title),
                        _buildTextField(
                            _descController, 'Açıklama', Icons.description,
                            maxLines: 3),
                        _buildTextField(
                            _categoryController, 'Kategori', Icons.category),
                        _buildTextField(
                            _priceController, 'Fiyat (TL)', Icons.attach_money,
                            isNumeric: true),
                        const SizedBox(height: 16),
                        const AdNativeWidget(), // Formun ortasına şık reklam
                        const SizedBox(height: 16),
                        _buildSwitchTile('Satıldı Olarak İşaretle', _isSold,
                            (final v) => setState(() => _isSold = v)),
                        _buildSwitchTile('İkinci El / Spot Ürün', _isSecondHand,
                            (final v) => setState(() => _isSecondHand = v)),
                        const SizedBox(height: 24),
                        _buildImageSection(),
                        const SizedBox(height: 32),
                        _buildSubmitButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          ),
          const AdBannerWidget(), // Sayfa Sonu Reklam
        ],
      ),
    );
  }

  // --- AddProduct Özel Parçaları ---

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ürün Detayları',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text('Mağazanıza yeni bir ürün tanımlayın.',
            style: TextStyle(color: Colors.grey.shade600)),
      ],
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
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ürün Görselleri',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.add_a_photo),
                label: const Text("Ekle")),
          ],
        ),
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (final context, final index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(_selectedImages[index],
                      width: 100, height: 100, fit: BoxFit.cover),
                ),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('Henüz görsel seçilmedi.')),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: _addProductAction,
        child: const Text('Ürünü Sisteme Kaydet',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- Logic Metodları ---

  Future<void> _addProductAction() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen gerekli alanları doldurun.')));
      return;
    }
    final product = Product(
      id: '',
      // ID'yi uygun bir şekilde ayarlayın
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: '',
      soldAt: '',
      name: _nameController.text,
      desc: _descController.text,
      category: _categoryController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      isSold: _isSold,
      isSpotProduct: _isSecondHand,
      imagesUrl: const [],
    );
    await ref
        .read(productProvider.notifier)
        .addProduct(product, _selectedImages);
    if (mounted) context.pop(); // İşlem bitince geri dön
  }

  Future<void> _pickImages() async {
    final images = await _imageSelector.pickImages();
    setState(() => _selectedImages.addAll(images));
  }
}
