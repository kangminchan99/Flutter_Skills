import 'package:flutter/material.dart';
import 'package:flutterskills/common/styles/app_colors.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_detail_model.dart';
import 'package:flutterskills/features/restaurant/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  // image
  final Widget image;
  // 레스토랑 이름
  final String name;
  // 레스토랑 태그
  final List<String> tags;
  // 레스토랑 평점 갯수
  final int ratingsCount;
  // 배송 걸리는 시간
  final int deliveryTime;
  // 배송 비용
  final int deliveryFee;
  // 평균 평점
  final double ratings;
  // 상세 페이지 여부
  final bool isDetail;
  // 상세 내용
  final String? detail;

  // Hero 위젯을 위한 Key
  final String? heroKey;
  const RestaurantCard({
    super.key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
    this.heroKey,
  });

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(model.thumbUrl, fit: BoxFit.cover),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
      heroKey: model.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        heroKey != null
            ? Hero(
                tag: ObjectKey(heroKey),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
                  child: image,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
                child: image,
              ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                tags.join(' · '),
                style: TextStyle(color: AppColors.bodyTextColor, fontSize: 14),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: '$ratings ($ratingsCount+)',
                  ),
                  _renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime분',
                  ),
                  _renderDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label: deliveryFee == 0 ? '무료' : '$deliveryFee원',
                  ),
                ],
              ),
              if (detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(detail!),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconText({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primaryColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

Widget _renderDot() {
  return Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 4),
    child: Text(
      '·',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );
}
