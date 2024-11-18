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
      width: 350, // Yatay genişlik 300
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            // Görselleri gösteren alan
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    // Görsel tam ekran göstermek için
                    showDialog(
                      context: context,
                      builder: (_) =>
                          Dialog(
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
                    height: 280,
                    width: 350,
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
                          _currentImageIndex = (_currentImageIndex -
                              1 +
                              product.imageUrl.length) %
                              product.imageUrl.length;
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
                          _currentImageIndex = (_currentImageIndex + 1) %
                              product.imageUrl.length;
                        });
                      },
                    ),
                  ),
              ],
            ),
            Text(product.desc,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 17)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(product.isSpotProduct ? "2. El Ürün" : "Sıfır Ürün",
                    style: customStyle()),
                Text('${product.price} TL',
                    style: customStyle()),
              ],
            )
          ],
        ),
      ),
    );
  }

  customStyle() {
    const TextStyle(
        fontWeight: FontWeight.normal, fontSize: 17);
  }
}
