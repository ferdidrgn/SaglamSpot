import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_notifier.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<XFile> _selectedImages = [];
  bool _isSecondHand = false;

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    // Login kontrolü
    Future.microtask(() {
      final auth = ref.read(authProvider);
      if (auth.value?.uid == null) context.go('/login');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Yeni Ürün Ekle'),
        backgroundColor: const Color(0xFF6366F1),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildImageSection(),
              const SizedBox(height: 24),
              _buildTextField(_nameController, 'Ürün Adı', Icons.shopping_bag),
              _buildTextField(_priceController, 'Fiyat', Icons.attach_money,
                  isNumeric: true),
              _buildTextField(_categoryController, 'Kategori', Icons.category),
              _buildTextField(_descController, 'Açıklama', Icons.description,
                  maxLines: 3),
              const SizedBox(height: 8),
              _buildSwitchTile('Spot/İkinci El Ürün', _isSecondHand,
                  (v) => setState(() => _isSecondHand = v)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: productState.isLoading ? null : _addProductAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: productState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Ürünü Sisteme Kaydet',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              // Native Ad Örneği
              const AdNativeWidget(),
              const SizedBox(height: 16),
              // AdSense Banner Örneği
              const AdsenseBanner(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ürün Detayları',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Mağazanıza yeni bir ürün tanımlayın.',
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      );

  Widget _buildTextField(
          TextEditingController controller, String label, IconData icon,
          {bool isNumeric = false, int maxLines = 1}) =>
      Padding(
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

  Widget _buildSwitchTile(
          String title, bool value, ValueChanged<bool> onChanged) =>
      SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: value,
        activeColor: const Color(0xFF6366F1),
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
      );

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
              onPressed: _pickImagesAction,
              icon: const Icon(Icons.add_a_photo),
              label: const Text("Görsel Seç"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      transform: Matrix4.identity()..scale(1.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(_selectedImages[index].path),
                                width: 100, height: 100, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _selectedImages.removeAt(index)),
                              child: Container(
                                color: Colors.black54,
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(child: Text('Henüz görsel seçilmedi.')),
          ),
      ],
    );
  }

  Future<void> _pickImagesAction() async {
    final ImagePicker picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() => _selectedImages.addAll(images));
    }
  }

  Future<void> _addProductAction() async {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!')));
      return;
    }

    final product = Product(
      id: '',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      soldAt: '',
      name: _nameController.text.trim(),
      desc: _descController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0,
      isSold: false,
      isSpotProduct: _isSecondHand,
      imagesUrl: const [],
    );

    await ref
        .read(productProvider.notifier)
        .addProduct(product, _selectedImages);

    if (!mounted) return;
    final state = ref.read(productProvider);
    if (state.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Ürün Başarıyla Eklendi!')));
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Hata: ${state.errorMessage}')));
    }
  }
}
