import 'package:flutter/material.dart';
import 'dart:async'; // Timer kullanmak için

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2 saniye sonra home sayfasına geçiş yap
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100], // Arka plan rengi
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo görselini animasyonlu şekilde göster
            AnimatedContainer(
              duration: const Duration(seconds: 2), // Animasyon süresi
              curve: Curves.easeInOut,
              child: Image.asset(
                'assets/images/logo.png',
                width: 150, // Genişlik ayarı
                height: 150, // Yükseklik ayarı
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sağlam Spot',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
