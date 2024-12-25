import 'package:flutter/material.dart';

import 'custom_gradient_background_image.dart';

class CustomDecoratedCard extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final String imageUrl;

  const CustomDecoratedCard({
    super.key,
    required this.title,
    required this.content,
    required this.color,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(16));
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 10, bottom: 20),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          ClipRRect(
            borderRadius: borderRadius,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                    child: Icon(Icons.error, color: Colors.red));
              },
            ),
          ),
          const GradientStrip(
            isAlignmentCenterLeft: true,
          ),
          const GradientStrip(
            isAlignmentCenterLeft: false,
          ),
          // Bilgiler adı overlay'i
          Positioned.fill(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      backgroundColor: Colors.black.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
