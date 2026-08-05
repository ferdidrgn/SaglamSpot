import '../../../../core/common/extentions/product_category_ex.dart';
import '../../domain/entites/product.dart';
import '../models/product_model.dart';

extension ProductModelMapper on ProductModel {
  /// Model'den Entity'ye dönüşüm (Data -> Domain)
  Product toEntity() => Product(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        soldAt: soldAt,
        name: name,
        desc: desc,
        // Enum dönüşümünü burada merkezi olarak yönetiyoruz
        category: category.toProductCategory(),
        price: price,
        imagesUrl: imagesUrl,
        isSold: isSold,
        isSpotProduct: isSpotProduct,
        availableColors: availableColors,
      );
}

extension ProductEntityMapper on Product {
  /// Entity'den Model'e dönüşüm (Domain -> Data)
  ProductModel toModel() => ProductModel(
        id: id,
        createdAt: createdAt,
        updatedAt: updatedAt,
        soldAt: soldAt,
        name: name,
        desc: desc,
        category: category.toFirestore(),
        price: price,
        imagesUrl: imagesUrl,
        isSold: isSold,
        isSpotProduct: isSpotProduct,
        availableColors: availableColors,
      );
}
