import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../providers/product_provider.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final String productId;
  final Product? product;

  const EditProductPage({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage>
    with TickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  bool _isSold = false;
  bool _isLoading = false;
  Product? _currentProduct;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // auth guard
    Future.microtask(() {
      final auth = ref.read(authProvider).value;
      if (auth?.uid == null) context.go('/login');
    });

    // ürün
    _currentProduct = widget.product ??
        ref.read(productsProvider).value?.firstWhere(
              (final e) => e.id == widget.productId,
              orElse: () => throw Exception("Ürün bulunamadı"),
            );

    if (_currentProduct != null) {
      _nameController = TextEditingController(text: _currentProduct!.name);
      _priceController =
          TextEditingController(text: _currentProduct!.price.toString());
      _isSold = _currentProduct!.isSold;
    } else {
      _nameController = TextEditingController();
      _priceController = TextEditingController();
    }

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
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
    if (_currentProduct == null) {
      return const Scaffold(
        body: Center(child: Text('Ürün bulunamadı')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Ürünü Güncelle'),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            const AdBannerWidget(),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  _section('Genel Bilgiler'),
                  const SizedBox(height: 16),
                  _field(_nameController, 'Ürün Adı', Icons.edit),
                  const SizedBox(height: 16),
                  _field(_priceController, 'Fiyat', Icons.attach_money,
                      numeric: true),
                  const SizedBox(height: 24),
                  const AdNativeWidget(),
                  const SizedBox(height: 24),
                  _section('Durum'),
                  _soldSwitch(),
                  const SizedBox(height: 32),
                  _submitButton(),
                ],
              ),
            ),
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }

  // ---------------- ACTION ----------------

  Future<void> _handleUpdate() async {
    final price = double.tryParse(_priceController.text.replaceAll(',', '.'));

    if (price == null || _nameController.text.trim().isEmpty) {
      _snack('Geçerli isim ve fiyat gir');
      return;
    }

    setState(() => _isLoading = true);

    final updated = _currentProduct!.copyWith(
      name: _nameController.text.trim(),
      price: price,
      isSold: _isSold,
      updatedAt: DateTime.now().toIso8601String(),
    );

    final useCase = ref.read(updateProductUseCaseProvider);
    final result = await useCase(updated);

    result.fold(
      (final f) => _snack(f.message ?? 'Güncelleme başarısız', error: true),
      (final _) {
        ref.invalidate(productsProvider); // 👈 mutant refresh
        _snack('Ürün güncellendi', success: true);
        context.pop();
      },
    );

    if (mounted) setState(() => _isLoading = false);
  }

  // ---------------- UI ----------------

  Widget _section(final String title) => Text(
        title,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B)),
      );

  Widget _field(
    final TextEditingController c,
    final String label,
    final IconData icon, {
    final bool numeric = false,
  }) =>
      TextField(
        controller: c,
        keyboardType: numeric
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
        ),
      );

  Widget _soldSwitch() => SwitchListTile(
        title: const Text('Ürün satıldı mı?'),
        value: _isSold,
        onChanged: (final v) => setState(() => _isSold = v),
      );

  Widget _submitButton() => SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleUpdate,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Değişiklikleri Kaydet'),
        ),
      );

  void _snack(final String msg,
      {final bool success = false, final bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success
            ? Colors.green
            : error
                ? Colors.red
                : null,
        content: Text(msg),
      ),
    );
  }
}
