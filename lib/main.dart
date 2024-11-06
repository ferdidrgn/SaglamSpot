import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    runApp(MaterialApp(
        home: Scaffold(
      body: Center(child: Text('Firebase başlatılamadı: $e')),
    )));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sağlam Spot',
      theme: ThemeData(primarySwatch: Colors.brown),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        // Diğer sayfaları buraya ekleyin
        '/urunler': (context) => const PlaceholderPage('Ürünler'),
        '/sifir': (context) => const PlaceholderPage('Sıfır'),
        '/ikinciel': (context) => const PlaceholderPage('2. El'),
        '/sss': (context) => const PlaceholderPage('SSS'),
        '/hakkinda': (context) => const PlaceholderPage('Hakkında'),
        '/ulasim': (context) => const PlaceholderPage('Ulaşım'),
        '/iletisim': (context) => const PlaceholderPage('İletişim'),
      },
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: Text('$title sayfası içeriği burada olacak')),
    );
  }
}
