import 'package:flutter/material.dart';
import 'package:flutterskills/common/components/pagination_listview.dart';

import 'package:flutterskills/features/restaurant/components/restaurant_card.dart';
import 'package:flutterskills/features/restaurant/provider/restaurant_provider.dart';
import 'package:flutterskills/features/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListview(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(context, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(id: model.id),
              ),
            );
          },
          child: RestaurantCard.fromModel(model: model),
        );
      },
    );
  }
}
