import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../core/widgets/custom_image_selector.dart';
import '../../domain/entities/product.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final ImageSelector _imageSelector = ImageSelector();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final List<dynamic> _selectedImages = [];
  bool _isSold = false;
  bool _isSecondHand = false;

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: productState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : productState.errorMessage != null
                ? _buildErrorState(productState.errorMessage!)
                : _buildContentState(context),
      ),
    );
  }

  Widget _buildContentState(final BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          ..._buildInputFields(),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Görsel Seç'),
            ),
          ),
          const SizedBox(height: 10),
          if (_selectedImages.isNotEmpty) _buildImagePreview(),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Ürün Ekle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(final String message) {
    return Center(
      child: Text('Hata: $message', style: const TextStyle(color: Colors.red)),
    );
  }

  Widget _buildHeader() {
    return const Center(
      child: Column(
        children: [
          Text(
            'Yeni Ürün Ekle',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'İlgili bilgileri doldurun ve görsel ekleyin',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInputFields() {
    return [
      _buildTextField(_nameController, 'Ürün Adı'),
      _buildTextField(_descController, 'Ürün Açıklaması'),
      _buildTextField(_categoryController, 'Kategori'),
      _buildTextField(_priceController, 'Fiyat', isNumeric: true),
      _buildSwitchRow('Ürün Satıldı mı?', _isSold, (final value) {
        setState(() {
          _isSold = value;
        });
      }),
      _buildSwitchRow('Ürün 2. El mi?', _isSecondHand, (final value) {
        setState(() {
          _isSecondHand = value;
        });
      }),
    ];
  }

  Widget _buildTextField(final TextEditingController controller, final String label, {final bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(final String label, final bool value, final ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (final context, final index) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.memory(
              _selectedImages[index],
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final images = await _imageSelector.pickImages();
    if (images.length + _selectedImages.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En fazla 8 fotoğraf ekleyebilirsiniz.')),
      );
      return;
    }

    final validImages = images.where((final image) => image is File || image is Uint8List).toList();

    if (validImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçersiz görsel türü.')),
      );
      return;
    }

    setState(() {
      _selectedImages.addAll(validImages);
    });
    }

  Future<void> _addProduct() async {
    if (_validateInputs()) {
      final product = Product(
        id: '', // ID'yi uygun bir şekilde ayarlayın
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

      // Product ekleme işlemini Riverpod ile yapıyoruz
      await ref.read(productProvider.notifier).addProduct(product, _selectedImages);
      _clearForm();
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectedImages.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun ve görsel seçin.')),
      );
      return false;
    }
    return true;
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _categoryController.clear();
    setState(() {
      _selectedImages.clear();
      _isSold = false;
      _isSecondHand = false;
    });
  }
}
