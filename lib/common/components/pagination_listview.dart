import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/model/model_with_id.dart';
import 'package:flutterskills/common/provider/pagination_provider.dart';
import 'package:flutterskills/common/utils/pagination_utils.dart';

// typedef로 선언 시 typedef에 해당되는 함수를 입력받겠다고 할 수 있다.
typedef PaginationWidgetBuilder<T extends IModelWithId> =
    Widget Function(BuildContext context, int index, T model);

class PaginationListview<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
  provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  const PaginationListview({
    super.key,
    required this.provider,
    required this.itemBuilder,
  });

  @override
  ConsumerState<PaginationListview> createState() =>
      _PaginationListviewState<T>();
}

class _PaginationListviewState<T extends IModelWithId>
    extends ConsumerState<PaginationListview> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_listener);
  }

  void _listener() {
    PaginationUtils.paginate(
      controller: scrollController,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    // 타입 비교 - is

    // 완전 처음 로딩일 때
    if (state is CursorPaginationLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }

    // 에러가 발생했을 때
    if (state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(state.errorMsg, textAlign: TextAlign.center),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            child: Text('다시시도'),
          ),
        ],
      );
    }

    // CursorPaginationModel
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching
    final cp = state as CursorPaginationModel<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(widget.provider.notifier).paginate(forceRefetch: true);
        },
        child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
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
                  child: cp is CursorPaginationFetchingMore
                      ? CircularProgressIndicator.adaptive()
                      : Text('마지막 데이터입니다 ㅠㅠ'),
                ),
              );
            }
            final pItem = cp.data[index];
            return widget.itemBuilder(context, index, pItem);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 16);
          },
        ),
      ),
    );
  }
}
