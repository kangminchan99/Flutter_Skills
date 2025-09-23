import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/features/restaurant/components/restaurant_card.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_model.dart';
import 'package:flutterskills/features/restaurant/repository/restaurant_repository.dart';
import 'package:flutterskills/features/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder<CursorPaginationModel<RestaurantModel>>(
        future: ref.watch(restaurantRepositoryProvider).paginate(),
        builder:
            (
              context,
              AsyncSnapshot<CursorPaginationModel<RestaurantModel>> snapshot,
            ) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator.adaptive());
              }

              return ListView.separated(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  final pItem = snapshot.data!.data[index];
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
              );
            },
      ),
    );
  }
}
