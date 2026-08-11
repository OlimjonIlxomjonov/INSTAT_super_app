import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class ContinueWithOptions extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String continueWithText;
  final bool isLoading;

  const ContinueWithOptions({
    super.key,
    required this.onTap,
    required this.iconPath,
    required this.continueWithText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .only(bottom: appH(12)),
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greyScale.grey50,
          foregroundColor: AppColors.greyScale.grey500,
        ),
        onPressed: onTap,
        label: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 1,
                ),
              )
            : AutoSizeText(continueWithText),
        icon: SvgPicture.asset(iconPath),
      ),
    );
  }
}
