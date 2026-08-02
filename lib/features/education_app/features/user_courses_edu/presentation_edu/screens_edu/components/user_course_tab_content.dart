import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
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
      // The scrollable lives here while the slivers live inside
      // CoursesInProgressComponent, so the load-more trigger has to wrap the
      // CustomScrollView from this side. The Builder gets a context that
      // sits below the BlocProvider above.
      child: Builder(
        builder: (context) {
          return BlocBuilder<UserCoursesBloc, UserCoursesState>(
            buildWhen: (prev, curr) {
              // Only rebuild this wrapper when the paging flags actually
              // change — the list content itself is rebuilt by the
              // BlocConsumer inside CoursesInProgressComponent.
              final p = prev is UserCoursesLoaded ? prev : null;
              final c = curr is UserCoursesLoaded ? curr : null;
              return p?.hasMore != c?.hasMore ||
                  p?.isLoadingMore != c?.isLoadingMore;
            },
            builder: (context, state) {
              final loaded = state is UserCoursesLoaded ? state : null;
              return LoadMoreOnScroll(
                canLoadMore:
                    (loaded?.hasMore ?? false) &&
                    !(loaded?.isLoadingMore ?? false),
                onLoadMore: () => context.read<UserCoursesBloc>().add(
                  const LoadMoreUserCoursesEvent(),
                ),
                child: CustomScrollView(
                  slivers: [
                    CoursesInProgressComponent(
                      layout: widget.layout,
                      state: widget.state,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
