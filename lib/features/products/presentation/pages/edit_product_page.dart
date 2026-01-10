import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_notifier.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final String productId;
  final Product? product;

  const EditProductPage({super.key, required this.productId, this.product});

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage>
    with TickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  bool _isSold = false;
  Product? _currentProduct;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Auth kontrolü
    Future.microtask(() {
      final auth = ref.read(authProvider);
      if (auth.value?.uid == null) context.go('/login');
    });

    // Ürün verisi
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

    _nameController = TextEditingController(text: _currentProduct?.name);
    _priceController =
        TextEditingController(text: _currentProduct?.price.toString());
    _isSold = _currentProduct?.isSold ?? false;

    // Fade animasyon
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _fadeController.dispose();
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Ürünü Güncelle",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            const AdBannerWidget(), // Banner reklam üstte
            Expanded(
              child: productState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      children: [
                        _buildSectionTitle("Genel Bilgiler"),
                        const SizedBox(height: 16),
                        _buildAnimatedTextField(
                            _nameController, "Ürün Adı", Icons.edit),
                        const SizedBox(height: 16),
                        _buildAnimatedTextField(
                            _priceController, "Fiyat (TL)", Icons.attach_money,
                            isNumeric: true),
                        const SizedBox(height: 24),
                        const AdNativeWidget(), // Native reklam
                        const SizedBox(height: 24),
                        _buildSectionTitle("Durum Yönetimi"),
                        _buildSoldSwitch(),
                        const SizedBox(height: 40),
                        _buildSubmitButton(),
                      ],
                    ),
            ),
            const AdBannerWidget(), // Footer reklam
          ],
        ),
      ),
    );
  }

  // --- Widget Parçaları ---

  Widget _buildAnimatedTextField(final TextEditingController controller,
      final String label, final IconData icon,
      {final bool isNumeric = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (final context, final value, final child) => Opacity(
        opacity: value,
        child: Transform.translate(
            offset: Offset(0, (1 - value) * 20), child: child),
      ),
      child: _buildTextField(controller, label, icon, isNumeric: isNumeric),
    );
  }

  Widget _buildTextField(final TextEditingController controller,
      final String label, final IconData icon,
      {final bool isNumeric = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.grey)),
        filled: true,
        fillColor: Colors.white,
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
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
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
