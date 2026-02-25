import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class CustomRatingStarWg extends StatelessWidget {
  final double starRating;
  final double starSize;

  const CustomRatingStarWg({
    super.key,
    required this.starRating,
    required this.starSize,
  });

  @override
  Widget build(BuildContext context) {
    return StarRating(
      mainAxisAlignment: .start,
      rating: starRating,
      size: starSize,
      color: AppColors.yellow500,
      borderColor: AppColors.greyScale.grey200,
    );
  }
}
