import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskills/common/layout/default_layout.dart';
import 'package:flutterskills/common/model/cursor_pagination_model.dart';
import 'package:flutterskills/common/styles/app_colors.dart';
import 'package:flutterskills/common/utils/pagination_utils.dart';
import 'package:flutterskills/features/product/components/product_card.dart';
import 'package:flutterskills/features/product/model/product_model.dart';
import 'package:flutterskills/features/rating/components/rating_card.dart';
import 'package:flutterskills/features/rating/model/rating_model.dart';
import 'package:flutterskills/features/restaurant/components/restaurant_card.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_detail_model.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_model.dart';
import 'package:flutterskills/features/restaurant/provider/restaurant_provider.dart';
import 'package:flutterskills/features/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutterskills/features/user/provider/basket_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:badges/badges.dart' as badges;

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';

  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: scrollController,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return DefaultLayout(
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return DefaultLayout(
      appBarTitle: state.name,
      floactingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        onPressed: () {},
        child: badges.Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold(0, (prev, next) => prev + next.count).toString(),
            style: TextStyle(color: AppColors.primaryColor, fontSize: 10),
          ),
          badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
          child: Icon(Icons.shopping_basket_outlined, color: Colors.white),
        ),
      ),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          _renderTop(model: state),
          if (state is! RestaurantDetailModel) ...[
            Skeletonizer.sliver(child: _renderLoading()),
          ],
          if (state is RestaurantDetailModel) ...[
            _renderLabel(),
            _renderProducts(products: state.products, restaurant: state),
          ],
          if (ratingState is CursorPaginationModel<RatingModel>)
            _renderRatings(model: ratingState.data),
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

  SliverPadding _renderRatings({required List<RatingModel> model}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RatingCard.fromModel(model: model[index]),
          ),
          childCount: model.length,
        ),
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
    required RestaurantModel restaurant,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final model = products[index];
          return InkWell(
            onTap: () {
              ref
                  .read(basketProvider.notifier)
                  .addToBasket(
                    product: ProductModel(
                      id: model.id,
                      name: model.name,
                      price: model.price,
                      detail: model.detail,
                      imgUrl: model.imgUrl,
                      restaurant: restaurant,
                    ),
                  );
            },
            child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: ProductCard.fromRestaurantProductModel(model: model),
            ),
          );
        }, childCount: products.length),
      ),
    );
  }
}
