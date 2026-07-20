import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class CustomRatingStarWg extends StatelessWidget {
  final double starRating;
  final double starSize;
  final Function(double)? onRatingChanged;

  const CustomRatingStarWg({
    super.key,
    required this.starRating,
    required this.starSize,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StarRating(
      onRatingChanged: onRatingChanged,
      mainAxisAlignment: .start,
      rating: starRating,
      size: starSize,
      color: AppColors.yellow500,
      borderColor: AppColors.greyScale.grey200,
    );
  }
}
