import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../domain/entites/product.dart';
import '../providers/product_provider.dart';

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
    // 1. Veriyi belirle: extra'dan mı geldi yoksa listeden mi bulalım?
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
                imagesUrl: [],
              ),
            );

    // 2. Controller'ları güvenli bir şekilde başlat
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
    // Eğer ürün bulunamazsa (geçersiz ID) kullanıcıya hata göster
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
          const AdBannerWidget(), // SAYFA BAŞI REKLAM
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildSectionTitle("Genel Bilgiler"),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Ürün Adı",
                          prefixIcon:
                              const Icon(Icons.edit, color: Color(0xFF6366F1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: "Fiyat (TL)",
                          prefixIcon: const Icon(Icons.attach_money,
                              color: Color(0xFF6366F1)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),

                      const AdNativeWidget(), // FORM ORTASI NATIVE REKLAM

                      const SizedBox(height: 24),
                      _buildSectionTitle("Durum Yönetimi"),
                      SwitchListTile(
                        title: const Text("Ürün Satıldı mı?",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: const Text(
                            "İşaretlendiğinde 'Satılanlar' sekmesine taşınır."),
                        value: _isSold,
                        activeColor: const Color(0xFF6366F1),
                        onChanged: (final v) => setState(() => _isSold = v),
                      ),
                      const SizedBox(height: 40),

                      _buildUpdateButton(),
                    ],
                  ),
          ),
          const AdBannerWidget(), // SAYFA SONU REKLAM
        ],
      ),
    );
  }

  Widget _buildSectionTitle(final String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
    );
  }

  Widget _buildUpdateButton() {
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
        child: const Text(
          "Değişiklikleri Kaydet",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _handleUpdate() async {
    // 1. Basit validasyon ve parse işlemi
    final double? price =
        double.tryParse(_priceController.text.replaceAll(',', '.'));
    if (price == null || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Lütfen geçerli bir isim ve fiyat girin.")),
      );
      return;
    }

    // 2. Güncel nesneyi oluştur
    final updated = _currentProduct!.copyWith(
      name: _nameController.text.trim(),
      price: price,
      isSold: _isSold,
      updatedAt: DateTime.now().toIso8601String(),
    );

    // 3. Notifier'ı tetikle
    await ref.read(productProvider.notifier).updateProduct(updated);

    // 4. Geri bildirim ver ve dön
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
