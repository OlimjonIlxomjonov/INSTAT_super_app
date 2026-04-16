import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';

class TestHeaderWg extends StatelessWidget {
  final double progress;

  const TestHeaderWg({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      sliver: SliverAppBar(
        floating: true,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   style: IconButton.styleFrom(
        //     backgroundColor: AppColors.white,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(50),
        //       side: BorderSide(color: AppColors.greyScale.grey200),
        //     ),
        //   ),
        //   onPressed: () {
        //     // AppRoute.close();
        //     FamilyNavigation.familyClose(context);
        //   },
        //   icon: const Icon(IconlyLight.arrow_left_2, size: 20),
        // ),
        centerTitle: true,
        title: LinearProgressIndicator(
          value: progress,
          minHeight: 16,
          borderRadius: BorderRadius.circular(35),
          color: AppColors.primaryColor,
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(color: AppColors.greyScale.grey200),
              ),
            ),
            onPressed: () {
              AppRoute.close();
            },
            icon: const Icon(Icons.close, size: 20),
          ),
        ],
      ),
    );
  }
}
