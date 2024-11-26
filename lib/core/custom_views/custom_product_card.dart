import 'package:cached_network_image/cached_network_image.dart';
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
      width: 280, // Yatay genişlik
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Görsel ve Oklar
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  GestureDetector(
                      onTap: () {
                        _showFullScreenImage(
                            context, product.imageUrl[_currentImageIndex]);
                      },
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl[_currentImageIndex],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
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

              // Ürün Adı
              Text(
                product.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              // Açıklama
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  product.desc,
                  style: const TextStyle(fontSize: 15),
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
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    '${product.price} TL',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Görsel Tam Ekran Fonksiyonu
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
          backgroundColor: Colors.black,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Tam ekran modundan çıkış
            },
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity * 0.5,
              height: double.infinity * 0.5,
              fit: BoxFit.cover,
            ),
          )),
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
