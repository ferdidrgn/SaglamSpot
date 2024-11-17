import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
        BottomNavigationBarItem(icon: Icon(Icons.chair), label: 'Sıfır Ürünler'),
        BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'İkinci El'),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Bilgiler'),
        BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'SSS'),
      ],
    );
  }
}
