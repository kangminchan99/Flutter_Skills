import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/provider/pagination_provider.dart';
import 'package:flutterskills/features/rating/model/rating_model.dart';
import 'package:flutterskills/features/restaurant/repository/restaurant_rating_repository.dart';

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingStateNotifier({required super.repository});
}

final restaurantRatingProvider =
    StateNotifierProvider.family<
      RestaurantRatingStateNotifier,
      CursorPaginationBase,
      String
    >((ref, rid) {
      final repo = ref.watch(restaurantRatingRepositoryProvider(rid));
      return RestaurantRatingStateNotifier(repository: repo);
    });
