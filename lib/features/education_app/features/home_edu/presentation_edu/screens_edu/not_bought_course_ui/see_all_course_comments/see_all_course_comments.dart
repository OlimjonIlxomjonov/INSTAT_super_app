import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_entity.dart';

import '../../../../../../../../core/utils/constants/textstyles/app_text_style.dart';

class SeeAllCourseComments extends StatelessWidget {
  final List<CommentsEntity> response;

  const SeeAllCourseComments({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .only(left: 20, bottom: 20),
            sliver: SliverToBoxAdapter(
              child: Text(
                AppLocalizations.of(context)!.commentsLeft,
                style: AppTextStyles.source.medium(fontSize: 18),
              ),
            ),
          ),
          SliverFillRemaining(
            child: ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: UserCommentsWg(entity: response[index], showAll: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
