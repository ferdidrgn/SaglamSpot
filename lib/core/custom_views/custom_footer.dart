import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: const Column(
        children: [
          Text(
            'Bize Ulaşın',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'info@example.com',
            style: TextStyle(color: Colors.blueAccent),
          ),
          SizedBox(height: 10),
          Text(
            '© 2024 Tüm Hakları Saklıdır.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
