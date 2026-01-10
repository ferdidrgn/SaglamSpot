import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/ad_mobile_banner.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color slateColor = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında verileri tetikle
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
        appBar: _buildAppBar(available.length, sold.length),
        body: Column(
          children: [
            const AdBannerWidget(), // ÜST SABİT REKLAM
            Expanded(
              child: productState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor))
                  : TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildProductList(available, "Stokta ürün bulunmuyor"),
                        _buildProductList(sold, "Satılmış ürün bulunmuyor"),
                      ],
                    ),
            ),
            const AdBannerWidget(), // ALT SABİT REKLAM
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-product'),
          backgroundColor: primaryColor,
          elevation: 4,
          icon: const Icon(Icons.add_photo_alternate_outlined,
              color: Colors.white),
          label: const Text("Yeni Ürün Ekle",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- Yardımcı Widgetlar ---

  PreferredSizeWidget _buildAppBar(
      final int availableCount, final int soldCount) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text("Yönetici Paneli",
          style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w900,
              fontSize: 22)),
      actions: [
        IconButton(
          onPressed: () => _showLogoutDialog(),
          icon: const Icon(Icons.power_settings_new_rounded,
              color: Colors.redAccent),
        )
      ],
      bottom: TabBar(
        labelColor: primaryColor,
        unselectedLabelColor: slateColor,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 3, color: primaryColor),
          insets: EdgeInsets.symmetric(horizontal: 40),
        ),
        tabs: [
          Tab(text: "Aktif Stok ($availableCount)"),
          Tab(text: "Satılanlar ($soldCount)"),
        ],
      ),
    );
  }

  Widget _buildProductList(final List<Product> list, final String emptyMsg) {
    if (list.isEmpty) return _buildEmptyState(emptyMsg);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length + (list.length ~/ 5), // Her 5 üründe bir reklam
      itemBuilder: (final context, final index) {
        if (index > 0 && index % 5 == 0) {
          return const AdNativeWidget(); // LİSTE İÇİ NATIVE REKLAM
        }
        final productIndex = index - (index ~/ 5);
        if (productIndex >= list.length) return const SizedBox();

        return _AdminProductCard(product: list[productIndex]);
      },
    );
  }

  Widget _buildEmptyState(final String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: slateColor.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(msg,
              style: const TextStyle(
                  color: slateColor, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
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
