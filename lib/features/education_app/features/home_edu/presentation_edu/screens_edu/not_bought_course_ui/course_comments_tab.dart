import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/core/utils/widgets/extend_comment/extend_comment_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_entity.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/comments/comments_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/comments/comments_state.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_course_comments/see_all_course_comments.dart';

class CourseCommentsTab extends StatefulWidget {
  const CourseCommentsTab({super.key});

  @override
  State<CourseCommentsTab> createState() => _CourseCommentsTabState();
}

class _CourseCommentsTabState extends State<CourseCommentsTab>
    with AutomaticKeepAliveClientMixin {
  void _openAllComments(BuildContext context, List<CommentsEntity> response) {
    subBottomSheetOpener(
      context,
      child: SeeAllCourseComments(response: response),
      isExpanded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentsBloc = context.watch<CommentsBloc>().state;
    final items = commentsBloc is CommentsLoaded
        ? commentsBloc.response.reviews
        : null;

    super.build(context);
    return Column(
      children: [
        (items?.isNotEmpty ?? false)
            ? Padding(
                padding: AppPadding.horizontal20x(),
                child: ExtendSectionSeeAllWg(
                  title: AppLocalizations.of(context)!.commentsLeft,
                  onTap: () => _openAllComments(context, items!),
                ),
              )
            : SizedBox.shrink(),
        BlocBuilder<CommentsBloc, CommentsState>(
          builder: (context, state) {
            if (state is CommentsLoaded) {
              final data = state.response.reviews;
              if (data.isEmpty) {
                return SizedBox(width: 200, child: EmptyState());
              }

              return SizedBox(
                height: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: appW(320),
                      child: GestureDetector(
                        onTap: () {
                          extendCommentWg(context, data[index]);
                        },
                        child: UserCommentsWg(entity: data[index]),
                      ),
                    );
                  },
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
