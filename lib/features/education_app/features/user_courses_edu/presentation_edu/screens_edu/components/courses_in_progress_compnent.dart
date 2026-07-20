import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_shimmer.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/common/ui_states/lost_internet_connection_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';

import '../../../../home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';

class CoursesInProgressComponent extends StatefulWidget {
  final CoursesLayout layout;
  final String state;

  const CoursesInProgressComponent({
    super.key,
    required this.layout,
    required this.state,
  });

  @override
  State<CoursesInProgressComponent> createState() =>
      _CoursesInProgressComponentState();
}

class _CoursesInProgressComponentState
    extends State<CoursesInProgressComponent> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasDisconnected = false;

  void sheetOpener({required CourseEntity data, required String categoryName}) {
    openMiniAppSheetFamily(
      showHandler: false,
      context,
      child: DetailedUserBoughtCoursesEduPage(
        data: data,
        categoryName: categoryName,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkInitialConnectivity();
    _listenToConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    final hasInternet = results.any((r) => r != ConnectivityResult.none);
    if (!hasInternet) {
      _wasDisconnected = true;
    }
  }

  void _loadData() {
    context.read<UserCoursesBloc>().add(
      UserCoursesEvent(params: UserCoursesParams(state: widget.state)),
    );
  }

  void _listenToConnectivity() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final hasInternet = results.any((r) => r != ConnectivityResult.none);

      if (hasInternet && _wasDisconnected) {
        // Internet came back — reload
        _wasDisconnected = false;
        _loadData();
      } else if (!hasInternet) {
        _wasDisconnected = true;
      }
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  /// EXTENDED COURSES
  Widget _buildList(List<CourseEntity> data) {
    if (widget.layout == CoursesLayout.grid) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: appW(20)),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final entity = data[index];
            return CourseCategoryBuilder(
              categoryId: entity.category,
              loadingBuilder: (context) => const SkeletonExpandedCourseCard(),
              builder: (context, categoryName) {
                return ExpandedCoursesCardWg(
                  onTap: () =>
                      sheetOpener(data: entity, categoryName: categoryName),
                  entity: entity,
                  categoryName: categoryName,
                );
              },
            );
          }, childCount: data.length),
        ),
      );
    }

    /// MINIMIZED COURSES
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: appW(20)),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final entity = data[index];
          return CourseCategoryBuilder(
            categoryId: entity.category,
            loadingBuilder: (context) => const SkeletonMinimalCourseCard(),
            builder: (context, categoryName) {
              return MinimalCoursesCardWg(
                onTap: () =>
                    sheetOpener(data: entity, categoryName: categoryName),
                data: entity,
                categoryName: categoryName,
              );
            },
          );
        }, childCount: data.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCoursesBloc, UserCoursesState>(
      listener: (context, state) {
        //? control states
      },
      builder: (context, state) {
        final localization = AppLocalizations.of(context)!;
        if (state is UserCoursesLoaded) {
          final data = state.response.data;

          /// EMPTY STATE
          if (data.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: AppEmptyState(
                title: widget.state == 'finished'
                    ? localization.courseNotFinishedYetTitle
                    : localization.courseNotStartedYetTitle,
                subtitle: widget.state == 'finished'
                    ? localization.finishedCoursesEmptySubtitle
                    : localization.startedCoursesEmptySubtitle,
                buttonLabel: localization.viewCoursesButton,
                onAction: () {
                  openMiniAppSheetFamily(
                    context,
                    showHandler: false,
                    child: const ShowAllCoursesBottomSheetPage(),
                  );
                },
              ),
            );
          }

          return _buildList(data);
        }

        if (state is UserCoursesLoading) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: appW(20)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => widget.layout == CoursesLayout.grid
                    ? const SkeletonExpandedCourseCard()
                    : const SkeletonMinimalCourseCard(),
                childCount: 5,
              ),
            ),
          );
        }

        if (state is UserCoursesError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: state.isConnectionError
                ? LostInternetConnectionState(onRetry: _loadData)
                : Center(child: ErrorPage()),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
