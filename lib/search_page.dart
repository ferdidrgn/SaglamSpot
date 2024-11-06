import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arama'),
      ),
      body: Center(
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Aramak için bir şey yazın...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            // Arama işlemini gerçekleştirin
          },
        ),
      ),
    );
  }
}
