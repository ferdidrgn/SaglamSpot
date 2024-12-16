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
  bool _isSecondHand = false;

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
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Yeni Ürün Ekle',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
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
      _buildSwitchRow('Ürün Satıldı mı?', _isSold, (value) {
        setState(() {
          _isSold = value;
        });
      }),
      _buildSwitchRow('Ürün 2. El mi?', _isSecondHand, (value) {
        setState(() {
          _isSecondHand = value;
        });
      }),
    ];
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool> onChanged) {
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
        itemBuilder: (context, index) => Padding(
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
    if (images != null) {
      if (images.length + _selectedImages.length > 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('En fazla 8 fotoğraf ekleyebilirsiniz.')),
        );
        return;
      }

      final validImages = images.where((image) =>
          image is File || image is Uint8List).toList();

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
        imageUrl: [],
      );

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
      _isSecondHand = false;
    });
  }
}