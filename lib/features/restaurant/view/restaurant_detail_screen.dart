import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/layout/default_layout.dart';
import 'package:flutterskills/features/product/components/product_card.dart';
import 'package:flutterskills/features/rating/components/rating_card.dart';
import 'package:flutterskills/features/restaurant/components/restaurant_card.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_detail_model.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_model.dart';
import 'package:flutterskills/features/restaurant/provider/restaurant_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return DefaultLayout(
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return DefaultLayout(
      appBarTitle: '불타는 떡볶이',
      child: CustomScrollView(
        slivers: [
          _renderTop(model: state),
          if (state is! RestaurantDetailModel) ...[
            Skeletonizer.sliver(child: _renderLoading()),
          ],
          if (state is RestaurantDetailModel) ...[
            _renderLabel(),
            _renderProducts(products: state.products),
          ],
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: RatingCard(
                avatarImage: AssetImage('assets/img/logo/codefactory_logo.png'),
                images: [],
                rating: 4,
                email: 'kangminchan99@gmail.com',
                content: '맛있습니당',
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Bone.circle(size: 48),
              title: Bone.text(words: 2),
              subtitle: Bone.text(),
              trailing: Bone.icon(),
            ),
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

  SliverToBoxAdapter _renderTop({required RestaurantModel model}) {
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
