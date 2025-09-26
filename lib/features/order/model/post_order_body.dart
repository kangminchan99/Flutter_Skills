import 'package:flutterskills/features/user/model/basket_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_order_body.g.dart';

@JsonSerializable()
class PostOrderBody {
  final String id;
  final List<PostOrderBodyProducts> products;
  final int totalPrice;
  final String createdAt;

  PostOrderBody({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createdAt,
  });

  factory PostOrderBody.fromJson(Map<String, dynamic> json) =>
      _$PostOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyToJson(this);
}

@JsonSerializable()
class PostOrderBodyProducts {
  final String productId;
  final int count;

  PostOrderBodyProducts({required this.productId, required this.count});

  factory PostOrderBodyProducts.fromJson(Map<String, dynamic> json) =>
      _$PostOrderBodyProductsFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyProductsToJson(this);
}
