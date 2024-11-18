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

    return SizedBox(
      width: 500, // Yatay genişlik 300
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Ürün Adı
              Text(
                product.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              // Görsel ve Oklar
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.network(
                    product.imageUrl[_currentImageIndex],
                    fit: BoxFit.cover,
                    height: 280,
                    width: double.infinity,
                  ),
                  // Oklar
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildArrowButton(
                      Icons.arrow_back,
                      onPressed: () =>
                          _changeImageIndex(-1, product.imageUrl.length),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildArrowButton(
                      Icons.arrow_forward,
                      onPressed: () =>
                          _changeImageIndex(1, product.imageUrl.length),
                    ),
                  ),
                  // İndikatör
                  Positioned(
                    bottom: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        product.imageUrl.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: _currentImageIndex == index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Açıklama
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  product.desc,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2, // Maksimum 2 satır
                  overflow: TextOverflow.ellipsis, // Üç nokta ekler
                ),
              ),

              // Ürün Detayları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.isSpotProduct ? "2. El Ürün" : "Sıfır Ürün",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${product.price} TL',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ok Butonları
  Widget _buildArrowButton(IconData icon, {required VoidCallback onPressed}) {
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

  // Görsel İndeksi Değiştirme
  void _changeImageIndex(int direction, int length) {
    setState(() {
      _currentImageIndex = (_currentImageIndex + direction + length) % length;
    });
  }
}
