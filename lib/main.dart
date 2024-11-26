import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saglamspot/presentation/pages/main_pages/main_container.dart';
import 'core/util/app_theme.dart';
import 'web_config.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      home: const MainContainer(),
    );
  }
}
