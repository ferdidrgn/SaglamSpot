import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saglamspot/presentation/pages/main_pages/main_screen.dart';
import 'core/theme/app_theme.dart';
import 'web_config.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      appId: firebaseConfig['appId']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket']!,
    ),
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sağlam Spot',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

