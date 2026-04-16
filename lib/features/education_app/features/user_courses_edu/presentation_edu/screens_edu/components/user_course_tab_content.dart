import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/courses_in_progress_compnent.dart';

class UserCoursesTabContent extends StatefulWidget {
  final String state;
  final CoursesLayout layout;

  const UserCoursesTabContent({
    super.key,
    required this.state,
    required this.layout,
  });

  @override
  State<UserCoursesTabContent> createState() => UserCoursesTabContentState();
}

class UserCoursesTabContentState extends State<UserCoursesTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => GetIt.instance<UserCoursesBloc>(),
      child: CustomScrollView(
        slivers: [
          CoursesInProgressComponent(
            layout: widget.layout,
            state: widget.state,
          ),
        ],
      ),
    );
  }
}
