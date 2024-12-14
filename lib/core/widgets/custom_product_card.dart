import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saglamspot/domain/entities/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return SizedBox(
      width: 280,
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildImageSection(product),
              _buildProductName(product.name),
              _buildProductDescription(product.desc),
              _buildProductDetails(product),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(Product product) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        GestureDetector(
          onTap: () => _showFullScreenImage(context, product.imageUrl[_currentImageIndex]),
          child: CachedNetworkImage(
            imageUrl: product.imageUrl[_currentImageIndex],
            height: 250,
            width: double.infinity,
            fit: BoxFit.contain,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        _buildArrowButtons(product),
        _buildImageIndicator(product.imageUrl.length),
      ],
    );
  }

  Widget _buildArrowButtons(Product product) {
    return Positioned(
      top: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildArrowButton(Icons.arrow_back, () => _changeImageIndex(-1, product.imageUrl.length)),
          _buildArrowButton(Icons.arrow_forward, () => _changeImageIndex(1, product.imageUrl.length)),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      child: Icon(icon, color: Colors.black),
    );
  }

  Widget _buildImageIndicator(int length) {
    return Positioned(
      bottom: 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CircleAvatar(
              radius: 4,
              backgroundColor: _currentImageIndex == index ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductName(String name) {
    return Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildProductDescription(String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        desc,
        style: const TextStyle(fontSize: 15),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProductDetails(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          product.isSpotProduct ? "2. El Ürün" : "Sıfır Ürün",
          style: const TextStyle(fontSize: 15),
        ),
        Text(
          '${product.price} TL',
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _changeImageIndex(int direction, int length) {
    setState(() {
      _currentImageIndex = (_currentImageIndex + direction + length) % length;
    });
  }
}