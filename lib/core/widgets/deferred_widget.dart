import 'package:flutter/material.dart';

/// Bir Dart `deferred as` kütüphanesini ilk kullanımda indirip yükleyen
/// sarmalayıcı — web derlemesinde bu kütüphanenin kodu ana `main.dart.js`
/// paketine dahil edilmez, ayrı bir parça (chunk) olarak yalnızca kullanıcı
/// gerçekten bu sayfaya gittiğinde indirilir. Admin paneli ve yasal
/// metinler gibi nadiren ziyaret edilen, ağır sayfalar için kullanılır.
///
/// `libraryLoader` her çağrıldığında `prefix.loadLibrary()` verilir —
/// Dart'ın kendi çalışma zamanı bunu zaten önbelleğe alır (aynı kütüphane
/// ikinci kez çağrıldığında anında tamamlanan bir Future döner), bu yüzden
/// burada ayrıca önbellekleme yapmaya gerek yok.
class DeferredWidget extends StatelessWidget {
  const DeferredWidget({
    super.key,
    required this.libraryLoader,
    required this.builder,
    this.placeholder,
  });

  final Future<void> Function() libraryLoader;
  final WidgetBuilder builder;
  final Widget? placeholder;

  @override
  Widget build(final BuildContext context) => FutureBuilder<void>(
        future: libraryLoader(),
        builder: (final context, final snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return placeholder ??
                const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Yüklenemedi: ${snapshot.error}'),
              ),
            );
          }
          return builder(context);
        },
      );
}
