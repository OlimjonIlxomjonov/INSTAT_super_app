import 'package:flutter/material.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_course_comments/see_all_course_comments.dart';

class CourseCommentsTab extends StatelessWidget {
  const CourseCommentsTab({super.key});

  static const List<Widget> _comments = [
    UserCommentsWg(),
    UserCommentsWg(),
    UserCommentsWg(),
  ];

  void _openAllComments(BuildContext context) {
    subBottomSheetOpener(
      context,
      child: const SeeAllCourseComments(),
      isExpanded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: AppPadding.horizontal20x(),
          sliver: SliverToBoxAdapter(
            child: ExtendSectionSeeAllWg(
              title: 'Qoldirilgan izohlar',
              onTap: () => _openAllComments(context),
            ),
          ),
        ),
        SliverList(delegate: SliverChildListDelegate.fixed(_comments)),
      ],
    );
  }
}
