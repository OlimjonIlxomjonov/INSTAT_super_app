import 'package:flutter/material.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';

class SeeAllCourseComments extends StatelessWidget {
  const SeeAllCourseComments({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: .symmetric(horizontal: appW(20)),
          child: Column(
            children: List.generate(10, (index) {
              return UserCommentsWg();
            }),
          ),
        ),
      ),
    );
  }
}
