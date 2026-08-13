import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/util/platform_checker.dart';
import 'package:saglamspot/shared/navigation/widgets/nav_handler.dart';
import '../../../core/ads/widgets/ad_banner_widget.dart';
import '../../../core/ads/widgets/adsense_banner.dart';
import '../../../core/common/enum/enums.dart';
import '../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/language_selector.dart';
import '../../../features/auth/presentation/provider/auth_provider_notifier.dart';

class SearchIntent extends Intent {
  const SearchIntent();
}

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<NavigationItem> get _navItems => [
    NavigationItem(label: context.l10n.home, icon: Icons.home_rounded, index: 0),
    NavigationItem(label: context.l10n.conditionNew, icon: Icons.chair_rounded, index: 1),
    NavigationItem(label: context.l10n.conditionUsed, icon: Icons.weekend_rounded, index: 2),
    NavigationItem(label: context.l10n.aboutUs, icon: Icons.store_rounded, index: 3),
    NavigationItem(label: context.l10n.sss, icon: Icons.quiz_rounded, index: 4),
  ];

  void _onItemTapped(final int index) {
    if (MediaQuery.sizeOf(context).width < 1024) {
      _scaffoldKey.currentState?.closeDrawer();
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  // Endüstriyel Güvenli Çıkış İletişim Penceresi
  Future<void> _showLogoutDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text(context.l10n.brand, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(context.l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (mounted) {
        _scaffoldKey.currentState?.closeDrawer();
      }
      await ref.read(authProvider.notifier).signOut();
    }
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Image.asset(
            'assets/images/saglam_spot_logo_mark.png',
            width: 90,
            height: 90,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: context.responsive(mobile: 4, tablet: 6, desktop: 8)),
        Text(
          context.l10n.brand,
          style: TextStyle(
            color: kIsWeb ? AppColors.textPrimary : AppColors.mobileTextPrimary,
            fontWeight: FontWeight.w900,
            fontSize: context.responsive(mobile: 15, tablet: 19, desktop: 22),
            letterSpacing: -0.2,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton(final bool isMobile) {
    void onTap() => NavigationHandler.goToSearch(context);

    if (isMobile) {
      return IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.search_rounded,
          size: context.responsive(mobile: 22, tablet: 24, desktop: 26),
        ),
        color: kIsWeb ? AppColors.textPrimary : AppColors.mobileTextPrimary,
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.borderRadius()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 12, tablet: 14, desktop: 16),
          vertical: context.responsive(mobile: 6, tablet: 7, desktop: 8),
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(context.borderRadius(0.8)),
          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: context.responsive(mobile: 18, tablet: 19, desktop: 20),
              color: AppColors.primary,
            ),
            SizedBox(width: context.responsive(mobile: 4, tablet: 6, desktop: 8)),
            Text(
              context.l10n.searchHint,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: context.responsive(mobile: 12, tablet: 14, desktop: 16),
              ),
            ),
            SizedBox(width: context.responsive(mobile: 8, tablet: 12, desktop: 16)),
            const _KbdShortcut(),
          ],
        ),
      ),
    );
  }

  // 1. DÜZELTME: Dönüş tipi PreferredSizeWidget yerine 'Widget' (AppBar) yapıldı
  Widget _buildMobileAppBar() {
    return AppBar(
      backgroundColor:
          (kIsWeb ? AppColors.background : AppColors.mobileBackground).withOpacity(0.85),
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(color: Colors.transparent),
        ),
      ),
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        icon: Icon(
          Icons.menu_rounded,
          size: context.responsive(mobile: 24, tablet: 26, desktop: 28),
        ),
      ),
      title: InkWell(
        onTap: () => _onItemTapped(0),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: _buildLogo(),
      ),
      actions: [
        const LanguageSelector(),
        _buildSearchButton(true),
        const SizedBox(width: 8),
      ],
    );
  }

  // 2. DÜZELTME: Dönüş tipi PreferredSizeWidget yerine 'Widget' (AppBar) yapıldı
  Widget _buildDesktopAppBar(final int currentIndex) {
    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.9),
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Row(
        children: [
          InkWell(
            onTap: () => _onItemTapped(0),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: _buildLogo(),
          ),
          // Nav öğeleri sabit genişlikte bir Row olarak Spacer'ın yanına
          // konulunca, 1024-1200px aralığındaki laptop pencerelerinde
          // toplam genişlik taşıp RenderFlex overflow hatası veriyordu.
          // Expanded + yatay kaydırma bunu kalıcı olarak imkansız kılar.
          // ÖNEMLİ: SingleChildScrollView içindeki Row'a "mainAxisSize.min"
          // verilirse mainAxisAlignment.center etkisiz kalır (Row zaten
          // içeriği kadar dar olur) — öğeler sola yapışık görünür. Bunun
          // yerine LayoutBuilder ile ölçülen genişlik kadar bir minWidth
          // dayatılıyor: sığdığında gerçekten ortalanır, sığmadığında
          // içerik kendi genişliğini alıp sessizce kayar.
          Expanded(
            child: LayoutBuilder(
              builder: (final context, final constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _navItems
                        .map((final item) => _DesktopNavItem(
                              item: item,
                              isActive: currentIndex == item.index,
                              onTap: () => _onItemTapped(item.index),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: context.responsive(mobile: 16, tablet: 20, desktop: 24)),
          const LanguageSelector(),
          const SizedBox(width: 12),
          _buildSearchButton(false),
          SizedBox(width: context.responsive(mobile: 16, tablet: 20, desktop: 24)),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 1024;
    final currentIndex = widget.navigationShell.currentIndex;

    final authState = ref.watch(authProvider);
    final bool isLoggedIn = authState.value != null && !authState.isLoading;

    // Responsive AppBar yüksekliğini güvenli ve sabit hesapla
    final double calculatedBarHeight = context.responsive(mobile: 60, tablet: 70, desktop: 80);

    // Native mobil uygulamada Ana Sayfa dalı (index 0) artık kendi
    // Scaffold'unu ve alt navigasyon çubuğunu (MobileBottomNav) taşıyan
    // yeni müşteri deneyimi — bu durumda eski AppBar/Drawer kabuğunu hiç
    // göstermiyoruz. Yeni/Spot dalları (1, 2) şimdilik eski davranışını
    // (AppBar + Drawer) korur, herhangi bir regresyon riski almadan.
    final bool isNativeHomeBranch = !kIsWeb && currentIndex == 0;

    if (isNativeHomeBranch) {
      return widget.navigationShell;
    }

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK): const SearchIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK): const SearchIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SearchIntent: CallbackAction<SearchIntent>(
            onInvoke: (final intent) => NavigationHandler.goToSearch(context),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: kIsWeb ? AppColors.background : AppColors.mobileBackground,

            // 3. KESİN ÇÖZÜM: Hata veren alan PreferredSize sarmalayıcısı ile tip uyuşmazlığından arındırıldı
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(calculatedBarHeight),
              child: isMobile
                  ? _buildMobileAppBar()
                  : _buildDesktopAppBar(currentIndex),
            ),

            drawer: isMobile
                ? _MobileDrawer(
              navItems: _navItems,
              currentIndex: currentIndex,
              onItemTapped: _onItemTapped,
              logo: _buildLogo(),
              onLogoutTapped: _showLogoutDialog,
              isLoggedIn: isLoggedIn,
            )
                : null,
            body: widget.navigationShell,
          ),
        ),
      ),
    );
  }
}

class _DesktopNavItem extends StatefulWidget {
  final NavigationItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _DesktopNavItem({required this.item, required this.isActive, required this.onTap});

  @override
  State<_DesktopNavItem> createState() => _DesktopNavItemState();
}

class _DesktopNavItemState extends State<_DesktopNavItem> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    // Eski ince alt çizgi yerine, hover/aktif durumda beliren yumuşak bir
    // "hap" arka planı — daha modern ve sıcak paletle bütünleşen bir his.
    final highlighted = widget.isActive || _isHovered;
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 12, tablet: 14, desktop: 18),
            vertical: context.responsive(mobile: 8, tablet: 9, desktop: 10),
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary.withOpacity(0.09)
                : (_isHovered ? AppColors.secondary : Colors.transparent),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Icon(
                widget.item.icon,
                size: context.responsive(mobile: 16, tablet: 17, desktop: 18),
                color: highlighted ? AppColors.primary : AppColors.textSecondary,
              ),
              SizedBox(width: context.responsive(mobile: 4, tablet: 6, desktop: 8)),
              Text(
                widget.item.label,
                style: TextStyle(
                  color: highlighted ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                  fontSize: context.responsive(mobile: 12, tablet: 13, desktop: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  final List<NavigationItem> navItems;
  final int currentIndex;
  final Function(int) onItemTapped;
  final Widget logo;
  final VoidCallback onLogoutTapped;
  final bool isLoggedIn;

  const _MobileDrawer({
    required this.navItems,
    required this.currentIndex,
    required this.onItemTapped,
    required this.logo,
    required this.onLogoutTapped,
    required this.isLoggedIn,
  });

  @override
  Widget build(final BuildContext context) {
    return Drawer(
      backgroundColor: kIsWeb ? AppColors.surface : AppColors.mobileSurface,
      shadowColor: kIsWeb ? AppColors.accentDark : AppColors.mobileAccentDark,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
              child: Row(
                children: [
                  logo,
                  const SizedBox(width: 8),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            const Divider(),
            const LanguageSelector(isDrawer: true),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: navItems.length,
                itemBuilder: (final context, final index) {
                  final item = navItems[index];
                  return ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    leading: Icon(
                      item.icon,
                      color: currentIndex == item.index
                          ? (kIsWeb ? AppColors.primary : AppColors.mobilePrimary)
                          : null,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: currentIndex == item.index ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: currentIndex == item.index,
                    selectedTileColor:
                        (kIsWeb ? AppColors.primary : AppColors.mobilePrimary).withOpacity(0.08),
                    onTap: () => onItemTapped(item.index),
                  );
                },
              ),
            ),
            if (isLoggedIn && !PlatformChecker.isWeb) ...[
              const Divider(),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: Text(
                  context.l10n.logout,
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
                onTap: onLogoutTapped,
              ),
            ],
            const Divider(),
            if (PlatformChecker.isMobile) const AdBannerWidget() else const AdsenseBanner(height: 100, type: AdUnitType.multiplex),
            _DrawerFooter(),
          ],
        ),
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.responsive(mobile: 16, tablet: 20, desktop: 24)),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => NavigationHandler.goToSearch(context),
            icon: Icon(
              Icons.search_rounded,
              size: context.responsive(mobile: 20, tablet: 22, desktop: 24),
            ),
            label: Text(
              context.l10n.searchHint,
              style: TextStyle(
                fontSize: context.responsive(mobile: 14, tablet: 16, desktop: 18),
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                double.infinity,
                context.responsive(mobile: 45, tablet: 50, desktop: 55),
              ),
              backgroundColor: kIsWeb ? AppColors.primary : AppColors.mobilePrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: context.responsive(mobile: 8, tablet: 10, desktop: 12)),
          Text(
            context.l10n.qualityFurniture,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.responsive(mobile: 11, tablet: 12, desktop: 13),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _KbdShortcut extends StatelessWidget {
  const _KbdShortcut();

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 4, tablet: 5, desktop: 6),
        vertical: context.responsive(mobile: 1, tablet: 1.5, desktop: 2),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.borderRadius(0.5)),
      ),
      child: Text(
        'Ctrl+K',
        style: TextStyle(
          color: Colors.white,
          fontSize: context.responsive(mobile: 9, tablet: 10, desktop: 11),
        ),
      ),
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final int index;

  NavigationItem({required this.label, required this.icon, required this.index});
}
