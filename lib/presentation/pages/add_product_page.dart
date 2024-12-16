import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/custom_image_selector.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ImageSelector _imageSelector = ImageSelector();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final List<dynamic> _selectedImages = [];
  bool _isSold = false;
  String _productCondition = "Sıfır Ürün";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ürün başarıyla eklendi!')),
              );
              _clearForm();
            } else if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Hata: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                ..._buildInputFields(),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Görsel Seç'),
                ),
                if (_selectedImages.isNotEmpty) _buildImagePreview(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addProduct,
                  child: const Text('Ürün Ekle'),
                ),
              ],
            );
          },
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
            onChanged: (value) => setState(() {
              _productCondition = value! ? "2. El Ürün" : "Sıfır Ürün";
            }),
          ),
        ],
      ),
    ];
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.memory(
            _selectedImages[index],
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
  final images = await _imageSelector.pickImages();
  if (images != null) {
    if (images.length + _selectedImages.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En fazla 8 fotoğraf ekleyebilirsiniz.')),
      );
      return;
    }
    // Geçerli türdeki görselleri filtrele
    final validImages = images.where((image) =>
        image is File || image is Uint8List).toList();

    if (validImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçersiz görsel türü. bu en baştaki NOOOOTT')),
      );
      return;
    }

    setState(() {
      _selectedImages.addAll(validImages);
    });
  }
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
        isSpotProduct: _productCondition == "2. El Ürün",
        imageUrl: [],
      );

      // Bloc'a AddProduct olayını gönder
      context.read<ProductBloc>().add(AddProduct(product, _selectedImages));
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
}
