import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/styles/app_colors.dart';
import 'package:flutterskills/features/product/model/product_model.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_detail_model.dart';
import 'package:flutterskills/features/user/provider/basket_provider.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onAdd;
  final VoidCallback? onSubtract;
  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    required this.id,
    this.onAdd,
    this.onSubtract,
  });

  factory ProductCard.fromProductModel({
    required ProductModel model,
    VoidCallback? onAdd,
    VoidCallback? onSubtract,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onAdd: onAdd,
      onSubtract: onSubtract,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
    VoidCallback? onAdd,
    VoidCallback? onSubtract,
  }) {
    return ProductCard(
      id: model.id,
      image: Image.network(
        model.imgUrl,
        fit: BoxFit.cover,
        width: 110,
        height: 110,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
      onAdd: onAdd,
      onSubtract: onSubtract,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    // IntrinsicHeight - 내부에 있는 모든 위젯들이 최대 크기를 차지한 위젯만큼 크기를 차지하게 된다
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(8), child: image),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.bodyTextColor,
                      ),
                    ),
                    Text(
                      '$price원',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _Footer(
              total:
                  (basket.firstWhere((e) => e.product.id == id).count *
                          basket
                              .firstWhere((e) => e.product.id == id)
                              .product
                              .price)
                      .toString(),
              count: basket.firstWhere((e) => e.product.id == id).count,
              onSubtract: onSubtract!,
              onAdd: onAdd!,
            ),
          ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;
  const _Footer({
    required this.total,
    required this.count,
    required this.onSubtract,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '총액 ₩$total',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        Row(
          children: [
            _renderButton(icon: Icons.remove, onTap: onSubtract),
            SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 8),
            _renderButton(icon: Icons.add, onTap: onAdd),
          ],
        ),
      ],
    );
  }

  Widget _renderButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(icon, color: AppColors.primaryColor),
      ),
    );
  }
}
