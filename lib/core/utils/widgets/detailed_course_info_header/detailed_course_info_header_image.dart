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
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: RepaintBoundary(
          child: Image.asset(
            filterQuality: .low,
            'assets/home_page/temp_course_dummy.png',
            fit: .cover,
          ),
        ),
      ),
      leading: Padding(
        padding: .only(left: 10, top: 10),
        child: IconButton(
          onPressed: () {
            FamilyNavigation.familyClose(context); // main
          },
          style: IconButton.styleFrom(
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: .circular(50)),
          ),
          icon: const Icon(IconlyLight.arrow_left_2, size: 20),
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
