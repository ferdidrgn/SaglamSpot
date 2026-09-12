import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/common/extentions/app_context_ui_extension.dart';
import 'nav_handler.dart';

/// Uygulamanın HEMEN HEMEN TÜM sayfa geçişleri `context.go(...)` ile
/// yapılıyor (GoRouter'ın push/pop yığını değil, tek-konumlu bir
/// "değiştirme" mantığı) — bu yüzden `Navigator.canPop` çoğu sayfada
/// zaten false'tur. Bu guard olmadan cihazın geri tuşuna basmak Flutter'ın
/// varsayılan davranışına düşer: yığın boşsa UYGULAMADAN ANINDA ÇIKAR.
///
/// Bunun yerine [NavigationHandler.smartGoBack] çağrılır: önce "nereden
/// geldiyse oraya" (`from` query parametresi), sonra gerçek bir
/// Navigator yığını varsa ona pop, hiçbiri yoksa (bu sayfa zaten bir
/// giriş noktasıysa) Ana Sayfa'ya döner — "her şey sırasıyla geri gitmeli,
/// en sonda ana sayfaya inmeli" davranışı budur.
class BackToHomeGuard extends StatelessWidget {
  final Widget child;

  const BackToHomeGuard({super.key, required this.child});

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        NavigationHandler.smartGoBack(context);
      },
      child: child,
    );
  }
}

/// Ana Sayfa sekmesinde kullanılır: cihazın geri tuşuna ilk basışta sadece
/// bir uyarı gösterir; KISA SÜRE içinde (2 sn) ikinci kez basılırsa
/// uygulamadan çıkılır — tek yanlış dokunuşla uygulamadan atılmayı önler.
class HomeExitGuard extends StatefulWidget {
  final Widget child;

  const HomeExitGuard({super.key, required this.child});

  @override
  State<HomeExitGuard> createState() => _HomeExitGuardState();
}

class _HomeExitGuardState extends State<HomeExitGuard> {
  DateTime? _lastBackPress;

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        final DateTime now = DateTime.now();
        if (_lastBackPress != null &&
            now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
          SystemNavigator.pop();
          return;
        }
        _lastBackPress = now;
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(context.l10n.doubleBackToExit),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      child: widget.child,
    );
  }
}
