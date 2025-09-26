import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/provider/pagination_provider.dart';
import 'package:flutterskills/features/order/model/order_model.dart';
import 'package:flutterskills/features/order/model/post_order_body.dart';
import 'package:flutterskills/features/order/repository/order_repository.dart';
import 'package:flutterskills/features/user/provider/basket_provider.dart';
import 'package:uuid/uuid.dart';

class OrderStateNotifier
    extends PaginationProvider<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({required this.ref, required super.repository});

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();

      final id = uuid.v4();
      final state = ref.read(basketProvider);

      final response = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map(
                (e) => PostOrderBodyProducts(
                  productId: e.product.id,
                  count: e.count,
                ),
              )
              .toList(),
          totalPrice: state.fold<int>(
            0,
            (previousValue, element) =>
                previousValue + (element.product.price * element.count),
          ),
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
      final orderRepository = ref.watch(orderRepositoryProvider);
      return OrderStateNotifier(ref: ref, repository: orderRepository);
    });
