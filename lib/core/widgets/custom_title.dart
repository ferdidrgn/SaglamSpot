import 'package:flutter/material.dart';

class CustomSectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;

  // Constructor
  const CustomSectionTitle({
    super.key,
    required this.title,
    this.fontSize = 24,
    this.color = Colors.black, // Varsayılan renk
  });

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color, // Renk özelliği ekleniyor
          ),
        ),
      ),
    );
  }
}
