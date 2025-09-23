import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/features/restaurant/components/restaurant_card.dart';
import 'package:flutterskills/features/restaurant/provider/restaurant_provider.dart';
import 'package:flutterskills/features/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔을 때 새로운 데이터를 추가 요청
    if (scrollController.offset >
        scrollController.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 타입 비교 - is

    // 완전 처음 로딩일 때
    if (data is CursorPaginationLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }

    // 에러가 발생했을 때
    if (data is CursorPaginationError) {
      return Center(child: Text(data.errorMsg));
    }

    // CursorPaginationModel
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching
    final cp = data as CursorPaginationModel;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: scrollController,
        itemCount: cp.data.length + 1,
        itemBuilder: (context, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? CircularProgressIndicator.adaptive()
                    : Text('마지막 데이터입니다 ㅠㅠ'),
              ),
            );
          }
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
