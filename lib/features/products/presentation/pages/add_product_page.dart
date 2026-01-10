import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_notifier.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  // Controller ve State tanımları
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<dynamic> _selectedImages = [];
  bool _isSecondHand = false;

  @override
  void initState() {
    super.initState();
    // Auth Kontrolü: Giriş yapılmamışsa login sayfasına yönlendir
    Future.microtask(() {
      final auth = ref.read(authProvider);
      if (auth.value?.uid == null) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // Generator tarafından üretilen ana state'i izle
    final productState = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Ürün Ekle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
            _buildSwitchTile('Spot/İkinci El Ürün', _isSecondHand, (final v) {
              setState(() => _isSecondHand = v);
            }),
            const SizedBox(height: 32),
            if (productState.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // --- Widget Parçaları ---

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
        keyboardType: isNumeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
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
              itemBuilder: (final context, final index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildSelectedImage(index),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedImages.removeAt(index)),
                        child: Container(
                          color: Colors.black54,
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    )
                  ],
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
                border: Border.all(
                    color: Colors.grey.shade300, style: BorderStyle.solid)),
            child: const Center(child: Text('Henüz görsel seçilmedi.')),
          ),
      ],
    );
  }

  // Resim seçimi için widget helper
  Widget _buildSelectedImage(final int index) {
    final image = _selectedImages[index];
    if (image is String) {
      // URL ise (edit sayfasından kalma veya web)
      return Image.network(image, width: 100, height: 100, fit: BoxFit.cover);
    } else {
      // File veya Uint8List ise
      return Image.file(image, width: 100, height: 100, fit: BoxFit.cover);
    }
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

  // --- Mantıksal Metodlar ---

  Future<void> _pickImagesAction() async {
    // custom_image_selector dosyanızdaki widget'ı veya image_picker'ı burada tetikleyin
    // Şimdilik _selectedImages.add(pickedFile) şeklinde veri eklendiğini varsayıyoruz
    // Örn: final ImagePicker _picker = ImagePicker();
  }

  Future<void> _addProductAction() async {
    // 1. Validasyon
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!')));
      return;
    }

    // 2. Ürün Nesnesini Hazırla
    final product = Product(
      id: '',
      // Notifier içinde benzersiz ID atanacak
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

    // 3. Notifier Üzerinden İşlemi Başlat
    // Generator kullandığın için provider ismi 'productProvider' oldu
    await ref
        .read(productProvider.notifier)
        .addProduct(product, _selectedImages);

    // 4. Sonucu Kontrol Et
    if (mounted) {
      final state = ref.read(productProvider);
      if (state.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Ürün Başarıyla Eklendi!')));
        context.pop(); // Başarılıysa geri dön
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('Hata: ${state.errorMessage}')));
      }
    }
  }
}
