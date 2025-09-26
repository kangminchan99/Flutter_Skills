import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/features/product/model/product_model.dart';
import 'package:flutterskills/features/user/model/basket_item_model.dart';

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  BasketProvider() : super([]);

  Future<void> addToBasket({required ProductModel product}) async {
    // 1) 아직 장바구니에 해당되는 상품이 없다면 장바구니에 상품을 추가한다
    // 2) 이미 장바구니에 해당되는 상품이 있다면, 수량만 증가시킨다
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count + 1) : e,
          )
          .toList();
    } else {
      state = [...state, BasketItemModel(product: product, count: 1)];
    }
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    // 카운트와 상관없이 아예 삭제
    bool isDelete = false,
  }) async {
    // 1) 장바구니에 상품이 존재할 때 (1 - 상품의 카운트가 1보다 크면 -1, 아니면 장바구니에서 상품 제거)
    // 2) 장바구니에 상품이 존재하지 않을 때 즉시 함수를 반환하고 아무것도 하지 않는다.
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count - 1) : e,
          )
          .toList();
    }
  }
}

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
      return BasketProvider();
    });
