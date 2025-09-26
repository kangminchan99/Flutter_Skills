import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/features/order/model/order_model.dart';
import 'package:flutterskills/features/order/model/post_order_body.dart';
import 'package:flutterskills/features/order/repository/order_repository.dart';
import 'package:flutterskills/features/user/provider/basket_provider.dart';
import 'package:uuid/uuid.dart';

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository orderRepository;
  OrderStateNotifier({required this.ref, required this.orderRepository})
    : super([]);

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();

      final id = uuid.v4();
      final state = ref.read(basketProvider);

      final response = await orderRepository.postOrder(
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
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
      final orderRepository = ref.watch(orderRepositoryProvider);
      return OrderStateNotifier(ref: ref, orderRepository: orderRepository);
    });
