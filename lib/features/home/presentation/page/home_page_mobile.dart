import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_notifier.dart';
import '../../../products/presentation/providers/product_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Slate rengi için modern bir gri tonu tanımlıyoruz
  static const Color slateColor = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);
    final products = productState.dataList ?? [];

    final available = products.where((final p) => !p.isSold).toList();
    final sold = products.where((final p) => p.isSold).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        // Değişkenleri metodlara parametre olarak gönderiyoruz
        appBar: _buildAppBar(context, ref, available.length, sold.length),
        body: productState.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF6366F1)))
            : TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildModernGrid(available, "Stokta ürün bulunmuyor"),
                  _buildModernGrid(sold, "Satılmış ürün bulunmuyor"),
                ],
              ),
        floatingActionButton: _buildFAB(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(final BuildContext context,
      final WidgetRef ref, final int availableCount, final int soldCount) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Yönetici Paneli",
              style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w900,
                  fontSize: 24)),
          Text("Sağlam Spot Stok Yönetimi",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
          child: IconButton(
            onPressed: () => _showLogoutDialog(context, ref),
            icon: const Icon(Icons.power_settings_new_rounded,
                color: Colors.redAccent),
          ),
        )
      ],
      bottom: TabBar(
        labelColor: const Color(0xFF6366F1),
        unselectedLabelColor: slateColor, // Hata giderildi
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: Color(0xFF6366F1)),
          insets: EdgeInsets.symmetric(horizontal: 40),
        ),
        tabs: [
          Tab(child: _buildTabLabel("Aktif Stok", availableCount)),
          Tab(child: _buildTabLabel("Satılanlar", soldCount)),
        ],
      ),
    );
  }

  Widget _buildTabLabel(final String label, final int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
              color: slateColor.withOpacity(0.1), // Hata giderildi
              borderRadius: BorderRadius.circular(10)),
          child: Text(count.toString(), style: const TextStyle(fontSize: 10)),
        )
      ],
    );
  }

  Widget _buildModernGrid(final List<Product> products, final String emptyMsg) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 64, color: slateColor.withOpacity(0.2)),
            // Hata giderildi
            const SizedBox(height: 16),
            Text(emptyMsg,
                style: const TextStyle(
                    color: slateColor, fontWeight: FontWeight.w500)),
            // Hata giderildi
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.gridColumns(2),
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (final context, final index) =>
          _AdminProductCard(product: products[index]),
    );
  }

  Widget _buildFAB(final BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.push('/add-product'),
      backgroundColor: const Color(0xFF6366F1),
      elevation: 4,
      icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
      label: const Text("Yeni Ürün Ekle",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  void _showLogoutDialog(final BuildContext context, final WidgetRef ref) {
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Çıkış Yap"),
        content: const Text("Oturumu kapatmak istediğinize emin misiniz?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Vazgeç")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
              context.go('/login');
            },
            child: const Text("Çıkış", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _AdminProductCard extends ConsumerWidget {
  final Product product;

  const _AdminProductCard({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    image: DecorationImage(
                      image: NetworkImage(product.imagesUrl.isNotEmpty
                          ? product.imagesUrl.first
                          : "https://via.placeholder.com/300"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.isSold ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(product.isSold ? "SATILDI" : "STOKTA",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text("${product.price} TL",
                    style: const TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w900,
                        fontSize: 16)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _actionBtn(Icons.edit_note_rounded, Colors.blue, () {}),
                _actionBtn(
                    product.isSold
                        ? Icons.replay_circle_filled_rounded
                        : Icons.check_circle_rounded,
                    product.isSold ? Colors.orange : Colors.green, () {
                  final updated = product.copyWith(isSold: !product.isSold);
                  ref.read(productProvider.notifier).updateProduct(updated);
                }),
                _actionBtn(Icons.delete_forever_rounded, Colors.redAccent, () {
                  _showDeleteConfirm(context, ref);
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _actionBtn(
      final IconData icon, final Color color, final VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 22),
      visualDensity: VisualDensity.compact,
    );
  }

  void _showDeleteConfirm(final BuildContext context, final WidgetRef ref) {
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text("Ürünü Sil"),
        content:
            Text("${product.name} sistemden tamamen silinecek. Emin misiniz?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Vazgeç")),
          TextButton(
              onPressed: () {
                ref.read(productProvider.notifier).deleteProduct(product);
                Navigator.pop(context);
              },
              child:
                  const Text("Evet, Sil", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
