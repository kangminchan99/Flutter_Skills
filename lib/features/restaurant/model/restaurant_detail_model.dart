import 'package:flutterskills/common/utils/data_utils.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;
  RestaurantDetailModel({
    required this.detail,
    required this.products,
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.ratings,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RestaurantDetailModelToJson(this);
}

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  final String detail;
  final int price;
  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String imgUrl;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.price,
    required this.imgUrl,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantProductModelToJson(this);
}
