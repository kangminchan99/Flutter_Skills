// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_order_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostOrderBody _$PostOrderBodyFromJson(Map<String, dynamic> json) =>
    PostOrderBody(
      id: json['id'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => PostOrderBodyProducts.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$PostOrderBodyToJson(PostOrderBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'products': instance.products,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt,
    };

PostOrderBodyProducts _$PostOrderBodyProductsFromJson(
  Map<String, dynamic> json,
) => PostOrderBodyProducts(
  productId: json['productId'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$PostOrderBodyProductsToJson(
  PostOrderBodyProducts instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'count': instance.count,
};
