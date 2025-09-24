import 'package:flutter/material.dart';
import 'package:flutterskills/common/styles/app_colors.dart';
// map에서 index를 사용하고 싶을 때
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  // Network image
  // Asset image
  // CircleAvatar
  final ImageProvider avatarImage;
  // 리스트로 위젯 이미지를 보여줄 때
  final List<Image> images;
  // 별점
  final int rating;
  // 이메일
  final String email;
  // 리뷰 내용
  final String content;

  const RatingCard({
    super.key,
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(avatarImage: avatarImage, email: email, rating: rating),
        SizedBox(height: 8),
        _Body(content: content),
        if (images.isNotEmpty)
          SizedBox(height: 100, child: _Images(images: images)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;
  const _Header({
    required this.avatarImage,
    required this.email,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 12, backgroundImage: avatarImage),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;
  const _Body({required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(fontSize: 14, color: AppColors.bodyTextColor),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;
  const _Images({required this.images});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, e) => Padding(
              padding: EdgeInsets.only(
                // 마지막 이미지에는 패딩을 주지 않는다
                right: index == images.length - 1 ? 0 : 16,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: e,
              ),
            ),
          )
          .toList(),
    );
  }
}
