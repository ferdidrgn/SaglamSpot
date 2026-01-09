import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_notifier.dart';
import '../../../products/presentation/providers/product_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final productState = ref.watch(productProvider);
    final products = productState.dataList ?? [];

    // Extension getter'larını kullanarak listeleri ayırıyoruz
    final available = products.available;
    final sold = products.sold;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ürün Yönetimi",
              style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [Tab(text: "Stokta"), Tab(text: "Satılanlar")],
          ),
          actions: [
            IconButton(
                onPressed: () => ref.read(authProvider.notifier).signOut(),
                icon: const Icon(Icons.logout))
          ],
        ),
        body: productState.isLoading && products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Builder(builder: (final context) {
                if (productState.errorMessage != null && products.isEmpty) {
                  return Center(child: Text(productState.errorMessage!));
                }
                return TabBarView(
                  children: [
                    _buildList(context, ref, available),
                    _buildList(context, ref, sold),
                  ],
                );
              }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-product'),
          icon: const Icon(Icons.add_a_photo_rounded),
          label: const Text("Yeni Ürün Ekle"),
          backgroundColor: const Color(0xFF6366F1),
        ),
      ),
    );
  }

  Widget _buildList(final BuildContext context, final WidgetRef ref,
      final List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text("Görüntülenecek ürün bulunamadı."));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (final _, final __) => const SizedBox(height: 12),
      itemBuilder: (final context, final index) {
        final product = products[index];
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: _buildProductImage(product),
            title: Text(product.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${product.price} TL",
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.more_vert),
            onTap: () => _showAdminActions(context, ref, product),
          ),
        );
      },
    );
  }

  // Çoklu görsel desteği için önizleme kutusu
  Widget _buildProductImage(final Product product) {
    final hasImage = product.imagesUrl.isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            width: 60,
            height: 60,
            color: Colors.grey[200],
            child: hasImage
                ? Image.network(
                    product.imagesUrl.first, // Listenin ilk elemanını alıyoruz
                    fit: BoxFit.cover,
                    errorBuilder:
                        (final context, final error, final stackTrace) =>
                            const Icon(Icons.broken_image),
                  )
                : const Icon(Icons.image_not_supported),
          ),
          if (product.imagesUrl.length > 1)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4)),
                ),
                child: Text(
                  "+${product.imagesUrl.length - 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAdminActions(final BuildContext context, final WidgetRef ref,
          final Product product) =>
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (final context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Ürünü Düzenle"),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/edit-product', extra: product);
                },
              ),
              ListTile(
                leading: Icon(
                    product.isSold ? Icons.undo : Icons.check_circle_outline,
                    color: Colors.orange),
                title:
                    Text(product.isSold ? "Stoka Geri Al" : "Satıldı İşaretle"),
                onTap: () {
                  final updated = product.copyWith(isSold: !product.isSold);
                  ref.read(productProvider.notifier).updateProduct(updated);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text("Sistemden Sil",
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, ref, product.id);
                },
              ),
            ],
          ),
        ),
      );

  void _confirmDelete(
          final BuildContext context, final WidgetRef ref, final String id) =>
      showDialog(
        context: context,
        builder: (final context) => AlertDialog(
          title: const Text("Ürünü Sil"),
          content: const Text("Bu işlem geri alınamaz. Emin misiniz?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Vazgeç")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                ref.read(productProvider.notifier).deleteProduct(id);
                Navigator.pop(context);
              },
              child: const Text("Sil", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
}
