import 'package:flutter/material.dart';
import 'package:flutterskills/common/styles/app_colors.dart';

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
  const RestaurantCard({
    super.key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(12.0), child: image),
        const SizedBox(height: 16),
        Column(
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
                _IconText(icon: Icons.star, label: '$ratings ($ratingsCount+)'),
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
          ],
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
