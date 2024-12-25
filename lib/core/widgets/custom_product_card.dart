import 'package:flutter/material.dart';
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

    return Container(
      width: 280,
      margin: const EdgeInsets.only(bottom: 20),
      height: MediaQuery.of(context).size.height * 0.8,
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
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => _showFullScreenImage(
                context,
                product.imageUrl.isNotEmpty
                    ? product.imageUrl[_currentImageIndex]
                    : ''),
            child: product.imageUrl.isNotEmpty
                ? Image.network(
                    product.imageUrl[_currentImageIndex],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.brown),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, size: 50),
                      );
                    },
                  )
                : const Center(
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
          ),
          _buildArrowButtons(product),
          _buildImageIndicator(product.imageUrl.length),
        ],
      ),
    );
  }

  Widget _buildArrowButtons(Product product) {
    return Positioned(
      top: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildArrowButton(Icons.arrow_back,
              () => _changeImageIndex(-1, product.imageUrl.length)),
          _buildArrowButton(Icons.arrow_forward,
              () => _changeImageIndex(1, product.imageUrl.length)),
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
              backgroundColor:
                  _currentImageIndex == index ? Colors.black : Colors.grey,
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
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error, size: 50),
                    );
                  },
                )
              : const Center(
                  child: Icon(Icons.image, size: 100, color: Colors.grey),
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
