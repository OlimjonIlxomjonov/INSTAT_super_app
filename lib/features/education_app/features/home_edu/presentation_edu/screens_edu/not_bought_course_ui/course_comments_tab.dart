import 'package:flutter/material.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/custom_bottom_sheet_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_course_comments/see_all_course_comments.dart';

class CourseCommentsTab extends StatelessWidget {
  const CourseCommentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: appW(20)),
      child: ListView(
        padding: .only(bottom: appH(20)),
        children: [
          ExtendSectionSeeAllWg(
            title: 'Qoldirilgan izohlar',
            onTap: () {
              customBottomSheetWg(context, child: SeeAllCourseComments());
            },
          ),
          ...List.generate(6, (index) {
            return UserCommentsWg();
          }),
        ],
      ),
    );
  }
}
