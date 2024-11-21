import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/custom_views/custom_image_selector.dart';
import '../../data/model/product.dart';
import '../../data/repository/product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ProductService _productService = ProductService();
  final ImageSelector _imageSelector = ImageSelector();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final List<dynamic> _selectedImages = [];
  bool _isSold = false;
  String _productCondition = "Sıfır Ürün";

  Future<void> _addProduct() async {
    if (_validateInputs()) {
      try {
        await _productService.addProductWithImages(
          Product(
            id: '',
            createdAt: '',
            updatedAt: '',
            soldAt: '',
            name: _nameController.text,
            desc: _descController.text,
            category: _categoryController.text,
            price: double.tryParse(_priceController.text) ?? 0.0,
            isSold: _isSold,
            isSpotProduct: _productCondition == "2. El Ürün",
            imageUrl: [],
          ),
          _selectedImages,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ürün başarıyla eklendi!')),
        );

        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectedImages.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lütfen tüm alanları doldurun ve görsel seçin.')),
      );
      return false;
    }
    return true;
  }

  void _pickImages() async {
    final images = await _imageSelector.pickImages();
    if (images.length + _selectedImages.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En fazla 8 fotoğraf ekleyebilirsiniz.')),
      );
      return;
    }
    setState(() {
      _selectedImages.addAll(images); // Tüm seçilen görselleri ayarlıyoruz
    });
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _categoryController.clear();
    setState(() {
      _selectedImages.clear();
      _isSold = false;
      _productCondition = "Sıfır Ürün";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields
            ..._buildInputFields(),
            // Image selection button
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Görsel Seç'),
            ),
            // Selected images preview
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _selectedImages[index] is File
                        ? Image.file(
                            _selectedImages[index],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            _selectedImages[index],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Add product button
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Ürün Ekle'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInputFields() {
    return [
      TextField(
        controller: _nameController,
        decoration: const InputDecoration(labelText: 'Ürün Adı'),
      ),
      TextField(
        controller: _descController,
        decoration: const InputDecoration(labelText: 'Ürün Açıklaması'),
      ),
      TextField(
        controller: _categoryController,
        decoration: const InputDecoration(labelText: 'Kategori'),
      ),
      TextField(
        controller: _priceController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Fiyat'),
      ),
      Row(
        children: [
          const Text('Ürün Satıldı mı?'),
          Checkbox(
            value: _isSold,
            onChanged: (value) => setState(() => _isSold = value ?? false),
          ),
        ],
      ),
      Row(
        children: [
          const Text('Ürün 2. El mi?'),
          Checkbox(
            value: _productCondition == "2. El Ürün",
            onChanged: (value) => setState(
                () => _productCondition = value! ? "2. El Ürün" : "Sıfır Ürün"),
          ),
        ],
      ),
    ];
  }
}
