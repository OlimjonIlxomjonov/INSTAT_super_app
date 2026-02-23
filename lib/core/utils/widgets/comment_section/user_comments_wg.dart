import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class UserCommentsWg extends StatelessWidget {
  const UserCommentsWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(bottom: 9),
      padding: .all(12),
      decoration: BoxDecoration(
        color: AppColors.greyScale.grey50,
        borderRadius: .circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: .zero,
            leading: CircleAvatar(),
            title: Text(
              'User name',
              maxLines: 1,
              overflow: .ellipsis,
              style: AppTextStyles.source.medium(fontSize: 16),
            ),
            subtitle: Text(
              '16 Oktyabr, 2026',
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey600,
              ),
            ),
            trailing: Text(
              '4.5 ⭐',
              style: AppTextStyles.source.medium(fontSize: 15),
            ),
          ),
          SizedBox(height: appH(8)),
          Text(
            'This course is carefully crafted to take you on a complete learning journey—from understanding the core principles of design to building real-world projects that showcase your skills.',
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
          SizedBox(height: appH(10)),
        ],
      ),
    );
  }
}
