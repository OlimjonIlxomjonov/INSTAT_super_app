import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/search_courses/search_courses_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/search_courses/search_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/search_courses/search_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class SearchCoursesBloc extends Bloc<CoursesEvent, SearchCoursesState> {
  final SearchCoursesUseCase useCase;

  SearchCoursesBloc({required this.useCase}) : super(SearchCoursesInitial()) {
    on<SearchCoursesEvent>((event, emit) async {
      emit(SearchCoursesLoading());
      try {
        // Always page 1 — a new query replaces results rather than appending.
        final response = await useCase.call(
          params: SearchCoursesParams(search: event.params.search, page: 1),
        );
        emit(
          SearchCoursesLoaded(
            response: response,
            query: event.params.search,
          ),
        );
      } on DioException catch (e) {
        emit(
          SearchCoursesError(
            isConnectionError: isNoInternetError(e),
            message: e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        final isSocketError = e is SocketException;
        emit(
          SearchCoursesError(
            isConnectionError: isSocketError,
            message: e.toString(),
          ),
        );
      }
    });

    on<LoadMoreSearchCoursesEvent>((event, emit) async {
      final current = state;

      // Only meaningful once a first page of results exists.
      if (current is! SearchCoursesLoaded) return;

      // Drop the event while a page is in flight or at the last page. Safe
      // against duplicates because `emit` updates `state` synchronously and
      // nothing awaits between this check and the emit below.
      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      try {
        final next = await useCase.call(
          params: SearchCoursesParams(
            // Extend the *same* query these results belong to.
            search: current.query,
            page: current.response.meta.currentPage + 1,
          ),
        );

        // The user may have typed a new query while this page was loading —
        // discard a now-stale page rather than mixing it into other results.
        final latest = state;
        if (latest is! SearchCoursesLoaded || latest.query != current.query) {
          return;
        }

        emit(
          SearchCoursesLoaded(
            response: CourseListResponse(
              links: next.links,
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
            query: current.query,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        // Keep the results already on screen — a failed "load more" must not
        // clear them. Clearing the flag lets the user retry by scrolling.
        final latest = state;
        if (latest is SearchCoursesLoaded && latest.query == current.query) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
