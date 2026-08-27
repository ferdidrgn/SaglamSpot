class ProductModel {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String soldAt;
  final String name;
  final String desc;
  final String category; // Firestore'da String tutuluyor
  final double price;
  final List<String> imagesUrl;
  final bool isSold;
  final bool isSpotProduct;
  final List<String> availableColors;
  final List<String> studioImagesUrl;

  /// Firestore'da 'wearTier' alanı olarak, enum adı (string) şeklinde
  /// tutulur. Eski dokümanlarda yok — null güvenli varsayılan.
  final String? wearTier;

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
    this.availableColors = const [],
    this.studioImagesUrl = const [],
    this.wearTier,
  });

  factory ProductModel.fromFirestore(final Map<String, dynamic> data) =>
      ProductModel(
        id: data['_id'] ?? '',
        createdAt: data['_createdAt'] ?? '',
        updatedAt: data['_updatedAt'] ?? '',
        soldAt: data['_soldAt'] ?? '',
        name: data['name'] ?? '',
        desc: data['desc'] ?? '',
        category: data['category'] ?? '',
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        isSold: data['isSold'] ?? false,
        isSpotProduct: data['isSpotProduct'] ?? false,
        imagesUrl: List<String>.from(data['imagesUrl'] ?? []),
        // Eski dokümanlarda bu alan yok, boş liste ile güvenli varsayılan.
        availableColors: List<String>.from(data['availableColors'] ?? []),
        studioImagesUrl: List<String>.from(data['studioImagesUrl'] ?? []),
        wearTier: data['wearTier'] as String?,
      );

  Map<String, dynamic> toFirestore() => {
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
        'availableColors': availableColors,
        'studioImagesUrl': studioImagesUrl,
        'wearTier': wearTier,
      };
}
