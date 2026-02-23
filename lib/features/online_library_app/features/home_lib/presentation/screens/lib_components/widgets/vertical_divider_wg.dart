import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class VerticalDividerWg extends StatelessWidget {
  const VerticalDividerWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 40, width: 1, color: AppColors.greyScale.grey300);
  }
}
