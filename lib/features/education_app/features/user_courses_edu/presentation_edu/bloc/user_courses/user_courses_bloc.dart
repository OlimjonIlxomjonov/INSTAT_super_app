import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course/courses_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class UserCoursesBloc extends Bloc<CoursesEvent, UserCoursesState> {
  final CoursesUseCase useCase;

  UserCoursesBloc(this.useCase) : super(UserCoursesInitial()) {
    on<UserCoursesEvent>((event, emit) async {
      if (state is UserCoursesLoading) return;
      emit(UserCoursesLoading());
      try {
        // Always start from page 1 so a reload replaces rather than appends.
        final response = await useCase.call(
          params: UserCoursesParams(
            state: event.params.state,
            page: 1,
            perPage: event.params.perPage,
          ),
        );
        emit(
          UserCoursesLoaded(
            response: response,
            filterState: event.params.state,
          ),
        );
      } on DioException catch (e) {
        emit(
          UserCoursesError(
            isConnectionError: isNoInternetError(e),
            message: e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        // Fallback for any non-Dio exception (e.g. SocketException not wrapped
        // by Dio, JSON parsing errors, etc.) — ensures the state is always updated.
        final isSocketError = e is SocketException;
        emit(
          UserCoursesError(
            isConnectionError: isSocketError,
            message: e.toString(),
          ),
        );
      }
    });

    on<LoadMoreUserCoursesEvent>((event, emit) async {
      final current = state;

      // Only meaningful once a first page exists.
      if (current is! UserCoursesLoaded) return;

      // Drop the event if a page is already in flight or the last page has
      // been reached. Safe against duplicates because `emit` updates `state`
      // synchronously and nothing awaits between this check and the emit
      // below, so a second event sees the raised flag.
      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      try {
        final next = await useCase.call(
          params: UserCoursesParams(
            // Extend the *same* filter this data belongs to.
            state: current.filterState,
            page: current.response.meta.currentPage + 1,
          ),
        );

        // The filter may have been switched (or reloaded) while this page
        // was in flight — discard a now-irrelevant result rather than
        // appending "finished" courses onto the "in progress" list.
        final latest = state;
        if (latest is! UserCoursesLoaded ||
            latest.filterState != current.filterState) {
          return;
        }

        emit(
          UserCoursesLoaded(
            response: CourseListResponse(
              links: next.links,
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
            filterState: current.filterState,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        // Keep what is already on screen — a failed "load more" must never
        // wipe out the pages the user is looking at, so this deliberately
        // does not emit UserCoursesError. Clearing the flag lets them retry
        // by simply scrolling again.
        final latest = state;
        if (latest is UserCoursesLoaded &&
            latest.filterState == current.filterState) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
