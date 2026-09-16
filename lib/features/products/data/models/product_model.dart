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
  final bool isReserved;
  final String? dimensions;
  final String? material;
  final double? previousPrice;
  final List<String> availableColors;
  final List<String> studioImagesUrl;

  /// Firestore'da 'wearTier' alanı olarak, enum adı (string) şeklinde
  /// tutulur. Eski dokümanlarda yok — null güvenli varsayılan.
  final String? wearTier;

  /// Ürün detay sayfasının platforma göre AYRI görüntülenme sayaçları —
  /// bkz. product.dart'taki aynı alanların dokümantasyonu.
  final int viewCountWeb;
  final int viewCountMobile;

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
    this.isReserved = false,
    this.dimensions,
    this.material,
    this.previousPrice,
    this.availableColors = const [],
    this.studioImagesUrl = const [],
    this.wearTier,
    this.viewCountWeb = 0,
    this.viewCountMobile = 0,
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
        // Boş string girdiler (ör. başarısız bir yükleme sonrası dizide
        // kalan) kart üzerinde kırık-görsel ikonuna düşmesin diye filtrelenir.
        imagesUrl: List<String>.from(data['imagesUrl'] ?? [])
            .where((final u) => u.isNotEmpty)
            .toList(),
        // Eski dokümanlarda bu alanlar yok, güvenli varsayılanlar.
        isReserved: data['isReserved'] ?? false,
        dimensions: data['dimensions'] as String?,
        material: data['material'] as String?,
        previousPrice: (data['previousPrice'] as num?)?.toDouble(),
        availableColors: List<String>.from(data['availableColors'] ?? []),
        studioImagesUrl: List<String>.from(data['studioImagesUrl'] ?? [])
            .where((final u) => u.isNotEmpty)
            .toList(),
        wearTier: data['wearTier'] as String?,
        viewCountWeb: (data['viewCountWeb'] as num?)?.toInt() ?? 0,
        viewCountMobile: (data['viewCountMobile'] as num?)?.toInt() ?? 0,
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
        'isReserved': isReserved,
        'dimensions': dimensions,
        'material': material,
        'previousPrice': previousPrice,
        'imagesUrl': imagesUrl,
        'availableColors': availableColors,
        'studioImagesUrl': studioImagesUrl,
        'wearTier': wearTier,
        'viewCountWeb': viewCountWeb,
        'viewCountMobile': viewCountMobile,
      };
}
