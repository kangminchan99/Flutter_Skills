import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/layout/default_layout.dart';
import 'package:flutterskills/common/styles/app_colors.dart';
import 'package:flutterskills/features/product/components/product_card.dart';
import 'package:flutterskills/features/user/provider/basket_provider.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return DefaultLayout(
        appBarTitle: '장바구니',
        child: Center(child: Text('장바구니가 비어있습니다 ㅠㅠ')),
      );
    }

    final productsTotal = basket.fold<int>(
      0,
      (previousValue, element) =>
          previousValue + (element.product.price * element.count),
    );

    final deliveryFee = basket.isNotEmpty
        ? basket.first.product.restaurant.deliveryFee
        : 0;
    return DefaultLayout(
      appBarTitle: '장바구니',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: basket.length,
                  separatorBuilder: (context, index) => Divider(height: 32),
                  itemBuilder: (context, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '장바구니 금액',
                        style: TextStyle(color: AppColors.bodyTextColor),
                      ),
                      Text('₩$productsTotal'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '배달비',
                        style: TextStyle(color: AppColors.bodyTextColor),
                      ),
                      Text('₩$deliveryFee'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('총액', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('₩${(deliveryFee + productsTotal).toString()}'),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Text(
                        '결제하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
