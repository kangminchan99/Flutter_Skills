import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/layout/default_layout.dart';
import 'package:flutterskills/features/product/components/product_card.dart';
import 'package:flutterskills/features/restaurant/components/restaurant_card.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_detail_model.dart';
import 'package:flutterskills/features/restaurant/repository/restaurant_repository.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      appBarTitle: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
        future: ref
            .watch(restaurantRepositoryProvider)
            .getRestaurantDetail(id: id),
        builder: (context, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator.adaptive());
          }

          return CustomScrollView(
            slivers: [
              _renderTop(model: snapshot.data!),
              _renderLabel(),
              _renderProducts(products: snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverPadding _renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverToBoxAdapter _renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(model: model, isDetail: true),
    );
  }

  SliverPadding _renderProducts({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final model = products[index];
          return Padding(
            padding: EdgeInsets.only(top: 16),
            child: ProductCard.fromModel(model: model),
          );
        }, childCount: products.length),
      ),
    );
  }
}
