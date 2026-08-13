import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/common/extentions/app_context_ui_extension.dart';

/// Alt navigasyon çubuğunun Ana Sayfa DIŞINDAKİ köklerinde (Keşfet/Sepet/
/// Profil) kullanılır: sekmeler birbirinin "üstünde" değil yan yana
/// olduğu için doğal bir geri-yığını (back stack) yoktur — cihazın geri
/// tuşuna basınca uygulamadan aniden ÇIKMAK yerine Ana Sayfa sekmesine
/// döner.
class BackToHomeGuard extends StatelessWidget {
  final Widget child;

  const BackToHomeGuard({super.key, required this.child});

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (didPop) return;
        context.go('/');
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
