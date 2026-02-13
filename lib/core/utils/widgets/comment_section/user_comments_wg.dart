import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class UserCommentsWg extends StatelessWidget {
  const UserCommentsWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text('User name', style: AppTextStyles.source.medium(fontSize: 16)),
            StarRating(rating: 4, color: AppColors.orange),
          ],
        ),
        SizedBox(height: appH(8)),
        Text(
          'This course is carefully crafted to take you on a complete learning journey—from understanding the core principles of design to building real-world projects that showcase your skills.',
          style: AppTextStyles.source.regular(
            fontSize: 14,
            color: AppColors.greyScale.grey600,
          ),
        ),
        Divider(color: AppColors.greyScale.grey200),
        SizedBox(height: appH(10)),
      ],
    );
  }
}
