import 'package:flutter/material.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_entity.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';

class SeeAllCourseComments extends StatelessWidget {
  final List<CommentsEntity> response;

  const SeeAllCourseComments({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(response.length, (index) {
            return UserCommentsWg(entity: response[index]);
          }),
        ),
      ),
    );
  }
}
