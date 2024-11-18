import 'package:flutter/material.dart';
import 'package:saglamspot/data/model/product.dart';

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

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Görselleri gösteren alan
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // Görsel tam ekran göstermek için
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: Image.network(
                        product.imageUrl[_currentImageIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                child: Image.network(
                  product.imageUrl[_currentImageIndex],
                  fit: BoxFit.cover,
                  height: 120,
                  width: 180,
                ),
              ),
              // Sol Navigasyon
              if (product.imageUrl.length > 1)
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex = (_currentImageIndex - 1 + product.imageUrl.length) % product.imageUrl.length;
                      });
                    },
                  ),
                ),
              // Sağ Navigasyon
              if (product.imageUrl.length > 1)
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex = (_currentImageIndex + 1) % product.imageUrl.length;
                      });
                    },
                  ),
                ),
            ],
          ),

          // Ürün Adı ve Fiyat
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${product.price} TL'),
          ),
        ],
      ),
    );
  }
}
