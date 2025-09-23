import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/model/pagination_params.dart';
import 'package:flutterskills/features/restaurant/repository/restaurant_repository.dart';

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;
  RestaurantStateNotifier({required this.repository})
    : super(CursorPaginationLoading()) {
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    // 추가로 데이터 가져오기
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 가능성 (State의 상태)
      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때

      // 바로 반환하는 상황
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2) 로딩중 - fetchMore : true
      //    로딩중인데 fetchMore가 아닐때 - 새로고침의 의도가 있을 수 있다.
      // 1번 반환 상황
      if (state is CursorPaginationModel && !forceRefetch) {
        final pState = state as CursorPaginationModel;

        // hasMore =false
        if (!pState.meta.hasMore) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      // fetchMore - true
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPaginationModel;

        state = CursorPaginationFetchingMore(
          data: pState.data,
          meta: pState.meta,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        // 데이터를 처음부터 가져오는 상황
        // 만약 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 Fetch (API요청)를 진행
        if (state is CursorPaginationModel && !forceRefetch) {
          final pState = state as CursorPaginationModel;
          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          // 나머지 상황 - 기존 데이터를 유지할 필요가 없는 상황
          state = CursorPaginationLoading();
        }
      }

      final response = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        state = response.copyWith(
          // 기존 데이터에 응답 받은 데이터 추가
          data: [...pState.data, ...response.data],
        );
      } else {
        state = response;
      }
    } catch (e) {
      state = CursorPaginationError(errorMsg: '데이터를 가져오지 못했습니다.');
    }
  }
}

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
      final repository = ref.watch(restaurantRepositoryProvider);

      final notifier = RestaurantStateNotifier(repository: repository);

      return notifier;
    });
