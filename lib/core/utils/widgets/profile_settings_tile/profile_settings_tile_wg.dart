import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';

class ProfileSettingsTileWg extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final Widget? trailingIcon;
  final VoidCallback onTap;
  final bool isLogOut;

  const ProfileSettingsTileWg({
    super.key,
    this.leadingIcon,
    required this.title,
    this.trailingIcon,
    required this.onTap,
    this.isLogOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.greyScale.grey200)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: AppPadding.horizontal20x(),
        leading: leadingIcon != null
            ? Icon(
                leadingIcon,
                color: isLogOut ? AppColors.red : AppColors.greyScale.grey800,
              )
            : null,
        title: Text(
          title,
          style: AppTextStyles.source.medium(
            fontSize: 15,
            color: isLogOut ? AppColors.red : AppColors.greyScale.grey600,
          ),
        ),
        trailing: trailingIcon ?? Icon(IconlyLight.arrow_right_2, size: 20),
      ),
    );
  }
}
