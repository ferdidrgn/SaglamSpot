import '../../domain/entities/product.dart';

class ProductModel {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String soldAt;
  final String name;
  final String desc;
  final String category;
  final double price;
  final List<String> imagesUrl;
  final bool isSold;
  final bool isSpotProduct;

  const ProductModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.soldAt,
    required this.name,
    required this.desc,
    required this.category,
    required this.price,
    required this.isSold,
    required this.isSpotProduct,
    required this.imagesUrl,
  });

  // Firestore'dan veri alırken kullanılan factory
  factory ProductModel.fromFirestore(final Map<String, dynamic> data) {
    return ProductModel(
      id: data['_id'] ?? '',
      createdAt: data['_createdAt'] ?? '',
      updatedAt: data['_updatedAt'] ?? '',
      soldAt: data['_soldAt'] ?? '',
      name: data['name'] ?? '',
      desc: data['desc'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] as num).toDouble(),
      isSold: data['isSold'] ?? false,
      isSpotProduct: data['isSpotProduct'] ?? false,
      imagesUrl: List<String>.from(data['imagesUrl'] ?? []),
    );
  }

  // Firestore'a veri gönderirken kullanılan metod
  Map<String, dynamic> toFirestore() {
    return {
      '_id': id,
      '_createdAt': createdAt,
      '_updatedAt': updatedAt,
      '_soldAt': soldAt,
      'name': name,
      'desc': desc,
      'category': category,
      'price': price,
      'isSold': isSold,
      'isSpotProduct': isSpotProduct,
      'imagesUrl': imagesUrl,
    };
  }

  // Kopyalama metodu
  ProductModel copyWith({
    final String? id,
    final String? createdAt,
    final String? updatedAt,
    final String? soldAt,
    final String? name,
    final String? desc,
    final String? category,
    final double? price,
    final List<String>? imagesUrl,
    final bool? isSold,
    final bool? isSpotProduct,
  }) {
    return ProductModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      soldAt: soldAt ?? this.soldAt,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      category: category ?? this.category,
      price: price ?? this.price,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      isSold: isSold ?? this.isSold,
      isSpotProduct: isSpotProduct ?? this.isSpotProduct,
    );
  }

  // Entity'e dönüştürme metodu
  Product toEntity() {
    return Product(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      soldAt: soldAt,
      name: name,
      desc: desc,
      category: category,
      price: price,
      imagesUrl: imagesUrl,
      isSold: isSold,
      isSpotProduct: isSpotProduct,
    );
  }

  // Entity'den ProductModel oluşturma metodu
  factory ProductModel.fromEntity(final Product product) {
    return ProductModel(
      id: product.id,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      soldAt: product.soldAt,
      name: product.name,
      desc: product.desc,
      category: product.category,
      price: product.price,
      imagesUrl: product.imagesUrl,
      isSold: product.isSold,
      isSpotProduct: product.isSpotProduct,
    );
  }
}
