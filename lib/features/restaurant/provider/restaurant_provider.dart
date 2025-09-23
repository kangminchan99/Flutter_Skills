import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/features/restaurant/repository/restaurant_repository.dart';

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;
  RestaurantStateNotifier({required this.repository})
    : super(CursorPaginationLoading()) {
    paginate();
  }

  paginate() async {
    final response = await repository.paginate();

    state = response;
  }
}

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
      final repository = ref.watch(restaurantRepositoryProvider);

      final notifier = RestaurantStateNotifier(repository: repository);

      return notifier;
    });
