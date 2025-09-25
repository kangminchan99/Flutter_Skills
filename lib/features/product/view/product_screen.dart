import 'package:flutter/material.dart';
import 'package:flutterskills/common/components/pagination_listview.dart';
import 'package:flutterskills/features/product/components/product_card.dart';
import 'package:flutterskills/features/product/model/product_model.dart';
import 'package:flutterskills/features/product/provider/product_provider.dart';
import 'package:flutterskills/features/restaurant/view/restaurant_detail_screen.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListview<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            context.goNamed(
              RestaurantDetailScreen.routeName,
              pathParameters: {'rid': model.restaurant.id},
            );
          },
          child: ProductCard.fromProductModel(model: model),
        );
      },
    );
  }
}
