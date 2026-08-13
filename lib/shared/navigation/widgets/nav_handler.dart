import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/deeplink/deeplink_service.dart';
import '../providers/navigation_keys.dart';

/// 🧭 Global Navigation Handler
/// Tüm uygulama genelinde navigasyon işlemlerini yönetir
class NavigationHandler {
  NavigationHandler._();

  static final NavigationHandler instance = NavigationHandler._();

  // ═══════════════════════════════════════════════════════════════
  // PRODUCT NAVIGATION
  // ═══════════════════════════════════════════════════════════════

  /// Ürün detay sayfasına git (nereden geldiğini kaydet). `sig`, router'daki
  /// (app_router.dart → DeepLinkSecurityEngine) native mobil imza
  /// doğrulamasını geçebilmek için FurnitureShareService ile AYNI anahtarla
  /// üretilir — bu olmadan native uygulamada uygulama-içi ürün gezinmesi
  /// güvenlik ekranına takılır.
  static void goToProduct({
    required final BuildContext context,
    required final String productId,
    required final String productSlug,
  }) {
    final String currentPath = GoRouterState.of(context).uri.path;
    final String sig = FurnitureShareService.signProductId(productId);
    final String targetPath =
        '/product/$productSlug-$productId?from=${Uri.encodeComponent(currentPath)}&sig=$sig';

    context.go(targetPath);
  }

  // ═══════════════════════════════════════════════════════════════
  // SMART BACK NAVIGATION
  // ═══════════════════════════════════════════════════════════════

  /// Akıllı geri dön (nereden geldiyse oraya)
  static void smartGoBack(final BuildContext context) {
    final state = GoRouterState.of(context);
    final fromRoute = state.uri.queryParameters['from'];

    if (fromRoute != null && fromRoute.isNotEmpty) // Nereden geldiyse oraya dön
      context.go(Uri.decodeComponent(fromRoute));
    else {
      // from bilgisi yoksa Navigator stack kontrol et
      if (Navigator.canPop(context))
        Navigator.pop(context);
      else // Stack boşsa ana sayfaya git
        context.go('/');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ROUTE HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Ana sayfaya git
  static void goToHome(final BuildContext context) => context.go('/');

  static void goToLogin(final BuildContext context) => context.go('/login');

  /// Giriş sayfasına, başarılı girişten sonra DOĞRUDAN panele (/admin)
  /// dönecek şekilde gider — düz goToLogin sonrası kullanıcı anasayfada
  /// kalırdı çünkü login'e 'nereden geldiği' bilgisi olmadan gidiliyordu.
  static void goToLoginForAdmin(final BuildContext context) =>
      context.go('/login?redirect=${Uri.encodeComponent('/admin')}');

  /// Arama sayfasına git
  static void goToSearch(final BuildContext context) => context.go('/search');

  /// Arama sayfasına, belirli bir kategori önceden seçili olacak şekilde git.
  /// [category] null ise normal /search sayfasına gider.
  static void goToSearchWithCategory(
    final BuildContext context,
    final String? categoryName,
  ) =>
      context.go(categoryName == null
          ? '/search'
          : '/search?category=$categoryName');

  /// Yeni ürünler sayfasına git
  static void goToNewProducts(final BuildContext context) => context.go('/new');

  /// Spot ürünler sayfasına git
  static void goToSpotProducts(final BuildContext context) =>
      context.go('/spot');

  /// Hakkımızda sayfasına git
  static void goToAbout(final BuildContext context) => context.go('/about');

  /// Sıkça Sorulan Sorular sayfasına git
  static void goToSSS(final BuildContext context) => context.go('/sss');

  /// Sepet sayfasına git
  static void goToCart(final BuildContext context) => context.go('/cart');

  /// Profil/Ayarlar sayfasına git
  static void goToSettings(final BuildContext context) => context.go('/settings');

  /// Bildirimler (push + uygulama içi gelen kutusu) sayfasına git
  static void goToNotifications(final BuildContext context) => context.go('/notifications');

  /// Yönetici paneline git (giriş gerektirir, redirect kapısı app_router'da)
  static void goToAdmin(final BuildContext context) => context.go('/admin');

  /// Gizlilik Politikası sayfasına git
  static void goToPrivacyPolicy(final BuildContext context) => context.go('/privacy');

  /// Kullanım Koşulları sayfasına git
  static void goToTerms(final BuildContext context) => context.go('/terms');

  // ✅ MOBİL TAB NAVIGATION (ROUTER)
  static void goToDiscoverWithCategory(
          final BuildContext context, final String category) =>
      context.go('/discover?category=$category');

  /// Web'de belirli bir bölüme (Hakkımızda, İletişim vb.) kaydır
  //static void scrollToWebSection(final String section) => NavigationKeys.webNavKey.currentState?.scrollToSection(section);

  // ═══════════════════════════════════════════════════════════════
  // GLOBAL ERİŞİM (BuildContext Olmayan Yerler İçin)
  // ═══════════════════════════════════════════════════════════════

  static NavigatorState? get _rootNav =>
      NavigationKeys.rootNavigatorKey.currentState;

  /// Örn: Bildirim geldiğinde BuildContext olmadan sayfaya yönlendirme
  static void globalGoTo(final String location) =>
      _rootNav?.context.go(location);

  // ═══════════════════════════════════════════════════════════════
  // UTILITY
  // ═══════════════════════════════════════════════════════════════

  /// Mevcut route path'i al
  static String getCurrentPath(final BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  /// Geri dönülebilir mi?
  static bool canGoBack(final BuildContext context) {
    final state = GoRouterState.of(context);
    final fromRoute = state.uri.queryParameters['from'];

    return fromRoute != null || Navigator.canPop(context);
  }
}

/*
// ═══════════════════════════════════════════════════════════════
// 📚 KULLANIM ÖRNEKLERİ
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
// 1️⃣ GLASSMORPHISM BACK BUTTON
// ═══════════════════════════════════════════════════════════════

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sayfa içeriği
          YourContent(),

          // Geri butonu (sol üst)
          Positioned(
            top: 60,
            left: 20,
            child: GlassmorphismBackButton(),
          ),
        ],
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// 2️⃣ GLASSMORPHISM ICON BUTTON
// ═══════════════════════════════════════════════════════════════

class MyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlassmorphismBackButton(),
        Spacer(),

        // Favori butonu
        GlassmorphismIconButton(
          icon: Icons.favorite_border,
          onPressed: () {},
          backgroundColor: AppColors.error,
        ),
        SizedBox(width: 12),

        // Paylaş butonu
        GlassmorphismIconButton(
          icon: Icons.share_outlined,
          onPressed: () {},
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// 3️⃣ GLASSMORPHISM APP BAR (Sticky Header)
// ═══════════════════════════════════════════════════════════════

class ProductDetailPage extends StatefulWidget {
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            // Scroll listener ekle
            controller: ScrollController()
              ..addListener(() {
                setState(() {
                  _isScrolled = scrollController.offset > 100;
                });
              }),
            slivers: [
              // Sayfa içeriği
            ],
          ),

          // Sticky header
          if (_isScrolled)
            GlassmorphismAppBar(
              title: 'Ürün Adı',
              subtitle: '₺1,299',
              showBackButton: true,
              actions: [
                GlassmorphismIconButton(
                  icon: Icons.favorite_border,
                  onPressed: () {},
                ),
              ],
            ),
        ],
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// 4️⃣ NAVIGATION HANDLER
// ═══════════════════════════════════════════════════════════════

import '../util/navigation_handler.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ürün detayına git
        NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug(),
        );
      },
      child: ProductCardWidget(),
    );
  }
}

class CustomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Akıllı geri dön
        NavigationHandler.smartGoBack(context);
      },
      child: Text('Geri'),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arama'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Ana sayfaya git
            NavigationHandler.goToHome(context);
          },
        ),
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// 5️⃣ ÖZEL BUTON ÖRNEKLERİ
// ═══════════════════════════════════════════════════════════════

// Küçük geri butonu
GlassmorphismBackButton
(
size: 36,
backgroundColor: AppColors.primary,
)

// Büyük geri butonu
GlassmorphismBackButton(
size: 56,
backgroundColor: Colors.black,
iconColor: Colors.white,
)

// Border'sız geri butonu
GlassmorphismBackButton(
showBorder: false,
backgroundColor: AppColors.secondary,
)

// Custom action ile
GlassmorphismBackButton(
onPressed: () {
// Özel işlem
print('Custom back action');
Navigator.pop(context);
},
)


// ═══════════════════════════════════════════════════════════════
// 6️⃣ HERO HEADER ÖRNEĞI (Product Detail)
// ═══════════════════════════════════════════════════════════════

Widget buildProductHero() {
return Stack(
children: [
// Ana görsel
Image.network(product.imageUrl),

// Gradient overlay
Container(
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [
Colors.black.withOpacity(0.3),
Colors.transparent,
],
),
),
),

// Header butonları
SafeArea(
child: Padding(
padding: EdgeInsets.all(20),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
GlassmorphismBackButton(
backgroundColor: AppColors.primary,
),
Row(
children: [
GlassmorphismIconButton(
icon: Icons.favorite_border,
onPressed: () {},
backgroundColor: AppColors.primary,
),
SizedBox(width: 12),
GlassmorphismIconButton(
icon: Icons.share_outlined,
onPressed: () {},
backgroundColor: AppColors.primary,
),
],
),
],
),
),
),
],
);
}


// ═══════════════════════════════════════════════════════════════
// 7️⃣ FARKLI RENKLERLE KULLANIM
// ═══════════════════════════════════════════════════════════════

// Kırmızı (Error)
GlassmorphismIconButton(
icon: Icons.favorite,
backgroundColor: AppColors.error,
iconColor: Colors.white,
onPressed: () {},
)

// Yeşil (Success)
GlassmorphismIconButton(
icon: Icons.check_circle,
backgroundColor: AppColors.success,
iconColor: Colors.white,
onPressed: () {},
)

// Altın (Accent)
GlassmorphismIconButton(
icon: Icons.star,
backgroundColor: AppColors.accent,
iconColor: Colors.white,
onPressed: () {},
)

// Siyah
GlassmorphismIconButton(
icon: Icons.shopping_cart,
backgroundColor: Colors.black,
iconColor: Colors.white,
onPressed: () {},
)


// ═══════════════════════════════════════════════════════════════
// 📋 ÖZET
// ═══════════════════════════════════════════════════════════════

/*
✅ OLUŞTURDUK:
1. NavigationHandler - Global navigasyon yöneticisi
2. GlassmorphismBackButton - Buzlu cam geri butonu
3. GlassmorphismIconButton - Genel amaçlı buzlu cam buton
4. GlassmorphismAppBar - Sticky header

✅ ÖZELLİKLER:
- Glassmorphism (buzlu cam) efekt
- Hover animasyonu
- Tap animasyonu (basınca küçülme)
- Özelleştirilebilir renk ve boyut
- Responsive

✅ KULLANIM YERLERİ:
- Product detail header
- Sticky scroll header
- Modal header'ları
- Floating action buttons
- Gallery overlay
- Search sayfası
*/
*/
