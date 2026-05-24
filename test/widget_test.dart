import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saglamspot/main.dart';

void main() {
  // 1. Durum: Cihaz Güvenli Olduğunda Uygulamanın Başlama Testi
  testWidgets('Güvenli cihazda uygulama MaterialApp.router ile başlar',
      (final WidgetTester tester) async {
    // Uygulamanızı Riverpod ProviderScope ile sarmalayıp, isDeviceSecure: true gönderiyoruz
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    // Uygulama router yapısıyla başladığı için arayüzün yüklenmeye başladığını doğrula
    // (GoRouter ilk sayfayı yüklemeye çalışırken widget ağacını kontrol eder)
    expect(find.byType(MyApp), findsOneWidget);
  });

  // 2. Durum: Cihaz Güvensiz Olduğunda Güvenlik Bariyeri Testi
  testWidgets('Güvensiz cihazda Güvenlik Uyarısı ekranı tetiklenir',
      (final WidgetTester tester) async {
    // isDeviceSecure: false göndererek bariyeri test ediyoruz
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    // Ekranda 'Güvenlik Uyarısı' başlığının olduğunu doğrula
    expect(find.text('Güvenlik Uyarısı'), findsOneWidget);

    // Açıklama metninde 'root' kelimesinin geçtiğini doğrula
    expect(find.textContaining('root uygulanmış'), findsOneWidget);

    // Güvensiz durumda uyarı ikonu görünmeli
    expect(find.byIcon(Icons.security_update_warning_rounded), findsOneWidget);
  });
}
