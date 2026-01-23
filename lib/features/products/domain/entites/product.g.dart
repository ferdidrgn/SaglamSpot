// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      soldAt: json['soldAt'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String,
      category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
      price: (json['price'] as num).toDouble(),
      imagesUrl: (json['imagesUrl'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isSold: json['isSold'] as bool? ?? false,
      isSpotProduct: json['isSpotProduct'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'soldAt': instance.soldAt,
      'name': instance.name,
      'desc': instance.desc,
      'category': _$ProductCategoryEnumMap[instance.category]!,
      'price': instance.price,
      'imagesUrl': instance.imagesUrl,
      'isSold': instance.isSold,
      'isSpotProduct': instance.isSpotProduct,
    };

const _$ProductCategoryEnumMap = {
  ProductCategory.sofa: 'sofa',
  ProductCategory.chair: 'chair',
  ProductCategory.table: 'table',
  ProductCategory.bed: 'bed',
  ProductCategory.wardrobe: 'wardrobe',
  ProductCategory.white: 'white',
  ProductCategory.other: 'other',
};
