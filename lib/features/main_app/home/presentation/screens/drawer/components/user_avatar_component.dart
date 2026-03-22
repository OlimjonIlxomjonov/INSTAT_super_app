import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';

class UserAvatarComponent extends StatelessWidget {
  const UserAvatarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const .only(left: 8.0),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(50),
                  side: BorderSide(color: AppColors.greyScale.grey200),
                ),
              ),
              onPressed: () {
                AppRoute.close();
              },
              icon: Icon(IconlyLight.arrow_left_2, size: 20),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: .center,
              mainAxisAlignment: .start,
              children: [
                /// User Avatar
                SizedBox(height: 15),
                CircleAvatar(
                  radius: 75,
                  child: Icon(
                    Icons.person,
                    color: AppColors.greyScale.grey600,
                    size: 90,
                  ),
                ),

                /// User Name/Surname
                SizedBox(height: 15),
                AutoSizeText(
                  'Afzal Pulatov',
                  style: AppTextStyles.source.medium(
                    fontSize: isMobile ? 22 : 32,
                  ),
                ),

                /// is verified user?
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
          ),
        ],
      ),
    );
  }
}
