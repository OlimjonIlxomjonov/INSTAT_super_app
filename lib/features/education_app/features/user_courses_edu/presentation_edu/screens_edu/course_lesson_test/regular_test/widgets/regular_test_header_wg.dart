import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class RegularTestHeaderWg extends StatelessWidget {
  final double progress;

  const RegularTestHeaderWg({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .only(left: 10, right: 10),
      sliver: SliverAppBar(
        floating: true,
        leading: IconButton(
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
        centerTitle: true,
        title: LinearProgressIndicator(
          value: progress,
          minHeight: 16,
          borderRadius: .circular(35),
          color: AppColors.primaryColor,
        ),
        actions: [
          IconButton(
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
            icon: Icon(Icons.close, size: 20),
          ),
        ],
      ),
    );
  }
}
