import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class ContinueWithOptions extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String continueWithText;

  const ContinueWithOptions({
    super.key,
    required this.onTap,
    required this.icon,
    required this.continueWithText,
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
        label: Text(continueWithText),
        icon: Icon(icon),
      ),
    );
  }
}
