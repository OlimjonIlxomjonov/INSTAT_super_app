import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';

class DetailedCourseInfoHeaderImage extends StatelessWidget {
  const DetailedCourseInfoHeaderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      stretch: true,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'assets/home_page/temp_course_dummy.png',
          fit: .cover,
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
      ),
      leading: Container(
        margin: .only(left: 10, top: 10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: IconButton(
            onPressed: () {
              // AppRoute.close();
              // FamilyModalSheet.of(context).popPage();
              FamilyNavigation.familyClose(context); // main
            },
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
            ),
            icon: Icon(IconlyLight.arrow_left_2, size: 20),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: .only(
              topLeft: .circular(32),
              topRight: .circular(32),
            ),
          ),
        ),
      ),
    );
  }
}
