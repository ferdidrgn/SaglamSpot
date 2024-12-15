import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.5),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
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
