import 'package:flutterskills/common/const/data.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_model.dart';

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

  factory RestaurantDetailModel.fromJson({required Map<String, dynamic> json}) {
    return RestaurantDetailModel(
      detail: json['detail'],
      products: List<RestaurantProductModel>.from(
        json['products'].map(
          (item) => RestaurantProductModel.fromJson(json: item),
        ),
      ),
      id: json['id'],
      name: json['name'],
      thumbUrl: 'http://$ip${json['thumbUrl']}',
      tags: List<String>.from(json['tags']),
      priceRange: RestaurantPriceRange.values.firstWhere(
        (e) => e.name == json['priceRange'],
      ),
      ratingsCount: json['ratingsCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
      ratings: json['ratings'].toDouble(),
    );
  }
}

class RestaurantProductModel {
  final String id;
  final String name;
  final String detail;
  final int price;
  final String imgUrl;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.price,
    required this.imgUrl,
  });

  factory RestaurantProductModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantProductModel(
      id: json['id'],
      name: json['name'],
      detail: json['detail'],
      price: json['price'],
      imgUrl: 'http://$ip${json['imgUrl']}',
    );
  }
}
