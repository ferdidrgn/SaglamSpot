import 'package:equatable/equatable.dart';
import '../../../../core/common/enum/enums.dart';

class Product extends Equatable {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String soldAt;
  final String name;
  final String desc;
  final ProductCategory category;
  final double price;
  final List<String> imagesUrl;
  final bool isSold;
  final bool isSpotProduct;

  /// Sadece SIFIR (isSpotProduct == false) ürünlerde anlamlıdır. İkinci el/spot
  /// ürünlerde tek bir fiziksel parça satıldığı için renk seçeneği gösterilmez.
  /// Hex renk kodları olarak saklanır (örn: '#2E7D6B'). Boşsa hiç gösterilmez.
  final List<String> availableColors;

  /// remove.bg ile arka planı kaldırılmış "stüdyo" versiyonlar —
  /// `imagesUrl` ile AYNI SIRADA, aynı uzunlukta bir dizi. Bir index için
  /// stüdyo görseli üretilemediyse (kota dolu/hata) o slotta boş string
  /// ('') bulunur. Bkz. core/services/studio_image_service.dart.
  final List<String> studioImagesUrl;

  const Product({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.soldAt,
    required this.name,
    required this.desc,
    required this.category,
    required this.price,
    required this.imagesUrl,
    required this.isSold,
    required this.isSpotProduct,
    this.availableColors = const [],
    this.studioImagesUrl = const [],
  });

  factory Product.empty() => Product(
        id: '',
        createdAt: '',
        updatedAt: '',
        soldAt: '',
        name: '',
        desc: '',
        category: ProductCategory.other,
        // Varsayılan enum
        price: 0.0,
        imagesUrl: const [],
        isSold: false,
        isSpotProduct: false,
      );

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        soldAt,
        name,
        desc,
        category,
        price,
        imagesUrl,
        isSold,
        isSpotProduct,
        availableColors,
        studioImagesUrl,
      ];

  Product copyWith({
    final String? id,
    final String? createdAt,
    final String? updatedAt,
    final String? soldAt,
    final String? name,
    final String? desc,
    final ProductCategory? category,
    final double? price,
    final List<String>? imagesUrl,
    final bool? isSold,
    final bool? isSpotProduct,
    final List<String>? availableColors,
    final List<String>? studioImagesUrl,
  }) =>
      Product(
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
        availableColors: availableColors ?? this.availableColors,
        studioImagesUrl: studioImagesUrl ?? this.studioImagesUrl,
      );
}
