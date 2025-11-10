import 'package:flutter/material.dart';
import 'custom_gradient_background_image.dart';

class CustomDecoratedCard extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final String imagesUrl;

  const CustomDecoratedCard({
    super.key,
    required this.title,
    required this.content,
    required this.color,
    required this.imagesUrl,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 5, bottom: 20),
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: _cardDecoration(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          const GradientStrip(isAlignmentCenterLeft: true),
          const GradientStrip(isAlignmentCenterLeft: false),
          _buildOverlay(),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.8),
          blurRadius: 5,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imagesUrl,
        fit: BoxFit.cover,
        loadingBuilder: (final context, final child, final progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (final context, final error, final stackTrace) {
          return const Center(child: Icon(Icons.error, color: Colors.red));
        },
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      top: 20,
      left: 20,
      right: 20,
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(color: color.withOpacity(0.4)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: _textStyle(32, FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: _textStyle(20, FontWeight.w700).copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle(final double fontSize, final FontWeight fontWeight) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.7),
    );
  }
}
