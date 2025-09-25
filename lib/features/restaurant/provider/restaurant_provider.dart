import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/provider/pagination_provider.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_model.dart';
import 'package:flutterskills/features/restaurant/repository/restaurant_repository.dart';
import 'package:collection/collection.dart';

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({required super.repository});

  void getDetail({required String id}) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPaginationModel이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPaginationModel) {
      await paginate();
    }

    // state가 CursorPaginationModel이 아닐 때 그냥 리턴
    if (state is! CursorPaginationModel) {
      return;
    }

    final pState = state as CursorPaginationModel;

    final response = await repository.getRestaurantDetail(id: id);

    // [RestaurantModel(1), RestaurantModel(2), ...]
    // 요청 id가 10번 이라면
    // list.where((e) => e.id == 10)) 데이터 X
    // 데이터가 없을때는 그냥 캐시의 끝에다가 데이터를 추가해버린다
    // [RestaurantModel(1), RestaurantModel(2), ..., RestaurantDetailModel(10)]
    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[...pState.data, response],
      );
    } else {
      // [RestaurantModel(1), RestaurantModel(2), ...]
      // id : 2인 친구를 Detail모델을 가져와라
      // getDetail(id:2)
      // [RestaurantModel(1), RestaurantDetailModel(2), ...]
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? response : e)
            .toList(),
      );
    }
  }
}

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
      final repository = ref.watch(restaurantRepositoryProvider);

      final notifier = RestaurantStateNotifier(repository: repository);

      return notifier;
    });

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((
  ref,
  id,
) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPaginationModel) {
    return null;
  }

  // firstWhereOrNull -> 데이터가 없으면 null을 리턴
  return state.data.firstWhereOrNull((element) => element.id == id);
});
