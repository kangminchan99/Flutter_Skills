import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/features/restaurant/components/restaurant_card.dart';
import 'package:flutterskills/features/restaurant/provider/restaurant_provider.dart';
import 'package:flutterskills/features/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    // 타입 비교 - is
    if (data is CursorPaginationLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }

    final cp = data as CursorPaginationModel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemCount: cp.data.length,
        itemBuilder: (context, index) {
          final pItem = cp.data[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(id: pItem.id),
                ),
              );
            },
            child: RestaurantCard.fromModel(model: pItem),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 16);
        },
      ),
    );
  }
}
