import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../domain/entites/product.dart';
import '../providers/product_notifier.dart'; // .g.dart'tan gelen productProvider için

class EditProductPage extends ConsumerStatefulWidget {
  final String productId;
  final Product? product;

  const EditProductPage({super.key, required this.productId, this.product});

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  bool _isSold = false;
  Product? _currentProduct;

  @override
  void initState() {
    super.initState();

    // 1. Auth Kontrolü: Giriş yapılmamışsa yönlendir
    Future.microtask(() {
      final auth = ref.read(authProvider);
      if (auth.value?.uid == null) {
        context.go('/login');
      }
    });

    // 2. Veriyi belirle
    _currentProduct = widget.product ??
        ref.read(productProvider).dataList?.firstWhere(
              (final e) => e.id == widget.productId,
              orElse: () => Product(
                id: '',
                updatedAt: DateTime.now().toIso8601String(),
                soldAt: '',
                name: '',
                desc: '',
                category: '',
                price: 0,
                isSold: false,
                isSpotProduct: false,
                createdAt: '',
                imagesUrl: const [],
              ),
            );

    // 3. Controller'ları başlat
    _nameController = TextEditingController(text: _currentProduct?.name);
    _priceController =
        TextEditingController(text: _currentProduct?.price.toString());
    _isSold = _currentProduct?.isSold ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (_currentProduct == null || _currentProduct!.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Hata")),
        body: const Center(child: Text("Ürün verisi bulunamadı.")),
      );
    }

    final productState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Ürünü Güncelle",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const AdBannerWidget(),
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildSectionTitle("Genel Bilgiler"),
                      const SizedBox(height: 16),
                      _buildTextField(_nameController, "Ürün Adı", Icons.edit),
                      const SizedBox(height: 16),
                      _buildTextField(
                          _priceController, "Fiyat (TL)", Icons.attach_money,
                          isNumeric: true),
                      const SizedBox(height: 24),
                      const AdNativeWidget(),
                      const SizedBox(height: 24),
                      _buildSectionTitle("Durum Yönetimi"),
                      _buildSoldSwitch(),
                      const SizedBox(height: 40),
                      _buildSubmitButton(),
                    ],
                  ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }

  // --- Widget Parçaları ---

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
    );
  }

  Widget _buildSoldSwitch() {
    return SwitchListTile(
      title: const Text("Ürün Satıldı mı?",
          style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: const Text("İşaretlendiğinde 'Satılanlar' sekmesine taşınır."),
      value: _isSold,
      activeColor: const Color(0xFF6366F1),
      onChanged: (final v) => setState(() => _isSold = v),
    );
  }

  Widget _buildSectionTitle(final String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _handleUpdate,
        child: const Text("Değişiklikleri Kaydet",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- Mantıksal Metodlar ---

  Future<void> _handleUpdate() async {
    final double? price =
        double.tryParse(_priceController.text.replaceAll(',', '.'));
    if (price == null || _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Lütfen geçerli bir isim ve fiyat girin.")),
      );
      return;
    }

    final updated = _currentProduct!.copyWith(
      name: _nameController.text.trim(),
      price: price,
      isSold: _isSold,
      updatedAt: DateTime.now().toIso8601String(),
    );

    // Generator provider ismi: productProvider
    await ref.read(productProvider.notifier).updateProduct(updated);

    if (mounted) {
      final state = ref.read(productProvider);
      if (state.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Ürün başarıyla güncellendi!")),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Hata: ${state.errorMessage}")),
        );
      }
    }
  }
}
