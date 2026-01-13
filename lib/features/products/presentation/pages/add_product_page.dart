import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../domain/entites/product.dart';
import '../providers/product_mutation_provider.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _category = TextEditingController();

  final List<XFile> _images = [];
  bool _isSecondHand = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final auth = ref.read(authProvider).value;
      if (auth?.uid == null) context.go('/login');
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _price.dispose();
    _category.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    ref.listen<AsyncValue<void>>(
      productMutationProvider,
      (final previous, final next) {
        if (next is AsyncData) {
          _snack('Ürün başarıyla eklendi', success: true);
          if (mounted) context.pop();
        }

        if (next is AsyncError)
          _snack('Yetki veya bağlantı hatası oluştu', error: true);
      },
    );

    final mutationState = ref.watch(productMutationProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Yeni Ürün Ekle'),
        backgroundColor: const Color(0xFF6366F1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AdBannerWidget(),
              _header(),
              const SizedBox(height: 24),
              _imageSection(),
              const SizedBox(height: 24),
              _field(_name, 'Ürün Adı', Icons.shopping_bag),
              _field(_price, 'Fiyat', Icons.attach_money, numeric: true),
              _field(_category, 'Kategori', Icons.category),
              _field(_desc, 'Açıklama', Icons.description, lines: 3),
              SwitchListTile(
                title: const Text('Spot / İkinci El'),
                value: _isSecondHand,
                onChanged: (final v) => setState(() => _isSecondHand = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: mutationState.isLoading ? null : _submit,
                  child: mutationState.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Kaydet'),
                ),
              ),
              const SizedBox(height: 24),
              const AdNativeWidget(),
              const SizedBox(height: 16),
              const AdBannerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- ACTIONS ----------------

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty ||
        _price.text.trim().isEmpty ||
        _images.isEmpty) {
      _snack('Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!',
          error: true);
      return;
    }

    final auth = ref.read(authProvider).value;
    if (auth?.uid == null) {
      _snack('Oturum kapalı', error: true);
      return;
    }

    final product = Product(
      id: '',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      soldAt: '',
      name: _name.text.trim(),
      desc: _desc.text.trim(),
      category: _category.text.trim(),
      price: double.tryParse(
            _price.text.replaceAll(',', '.'),
          ) ??
          0,
      isSold: false,
      isSpotProduct: _isSecondHand,
      imagesUrl: const [],
    );

    await ref
        .read(productMutationProvider.notifier)
        .add(product, _images.map((final e) => File(e.path)).toList());
  }

  // ---------------- UI HELPERS ----------------

  Widget _header() => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ürün Detayları',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('Mağazanıza yeni ürün ekleyin'),
        ],
      );

  Widget _field(
    final TextEditingController c,
    final String label,
    final IconData icon, {
    final bool numeric = false,
    final int lines = 1,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextField(
          controller: c,
          maxLines: lines,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );

  Widget _imageSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Görseller',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Ekle'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _images.isEmpty
              ? const Text('Görsel yok')
              : SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (final _, final i) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(
                        File(_images[i].path),
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
        ],
      );

  Future<void> _pickImages() async {
    final images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) setState(() => _images.addAll(images));
  }

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
