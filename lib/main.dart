import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Anasayfa', style: TextStyle(fontSize: 24))),
    Center(child: Text('Sıfır Ürünler', style: TextStyle(fontSize: 24))),
    Center(child: Text('İkinci El Ürünler', style: TextStyle(fontSize: 24))),
    Center(child: Text('Bilgiler', style: TextStyle(fontSize: 24))),
    Center(child: Text('SSS', style: TextStyle(fontSize: 24))),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobilya Dükkânı'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.chair), label: 'Sıfır Ürünler'),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'İkinci El'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Bilgiler'),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'SSS'),
        ],
      ),
    );
  }
}
