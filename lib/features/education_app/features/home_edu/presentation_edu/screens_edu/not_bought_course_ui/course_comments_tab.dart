import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_entity.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/comments/comments_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/comments/comments_state.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
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
        items!.isNotEmpty
            ? Padding(
                padding: AppPadding.horizontal20x(),
                child: ExtendSectionSeeAllWg(
                  title: 'Qoldirilgan izohlar',
                  onTap: () => _openAllComments(context, items),
                ),
              )
            : SizedBox.shrink(),
        BlocBuilder<CommentsBloc, CommentsState>(
          builder: (context, state) {
            if (state is CommentsLoaded) {
              final data = state.response.reviews;
              if (data.isEmpty) {
                return SizedBox(
                  width: 200,
                  child: EmptyState(message: 'Bosh!'),
                );
              }

              return Column(
                children: List.generate(data.length, (index) {
                  return UserCommentsWg(entity: data[index]);
                }),
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
