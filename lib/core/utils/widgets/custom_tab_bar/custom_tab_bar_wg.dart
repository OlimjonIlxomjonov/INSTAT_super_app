import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class CustomTabBarWg extends StatelessWidget {
  final String firstTab, secondTab;
  final String? thirdTab;

  const CustomTabBarWg({
    super.key,
    required this.firstTab,
    required this.secondTab,
    this.thirdTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.greyScale.grey50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        indicatorWeight: 0,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: AppTextStyles.source.medium(fontSize: 13),
        labelColor: AppColors.white,
        labelPadding: .zero,
        unselectedLabelColor: AppColors.greyScale.grey400,
        tabs: [
          Tab(text: firstTab),
          Tab(text: secondTab),
          if (thirdTab != null) Tab(text: thirdTab!),
        ],
      ),
    );
  }
}
