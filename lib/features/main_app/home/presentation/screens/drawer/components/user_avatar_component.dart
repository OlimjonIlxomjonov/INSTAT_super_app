import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';

class UserAvatarComponent extends StatelessWidget {
  const UserAvatarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .start,
        children: [
          SizedBox(height: 15),
          CircleAvatar(
            radius: 75,
            child: Icon(
              Icons.person,
              color: AppColors.greyScale.grey600,
              size: 90,
            ),
          ),
          SizedBox(height: 15),
          AutoSizeText(
            'Afzal Pulatov',
            style: AppTextStyles.source.medium(fontSize: isMobile ? 22 : 32),
          ),
          SizedBox(height: 8),
          Container(
            padding: .all(4),
            decoration: BoxDecoration(
              color: AppColors.orange50,
              borderRadius: .circular(6),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(IconlyLight.danger, color: AppColors.orange500),
                AutoSizeText(
                  'Shaxsingizni tasdiqlang',
                  style: AppTextStyles.source.medium(
                    fontSize: 13,
                    color: AppColors.orange500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
