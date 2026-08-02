import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/main_app/home/domain/usecase/courses/courses_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class CoursesBloc extends Bloc<HomeEvent, CoursesState> {
  final ActiveCoursesUseCase useCase;

  CoursesBloc(this.useCase) : super(CoursesInitial()) {
    on<AvailableCoursesEvent>((event, emit) async {
      emit(CoursesLoading());
      try {
        final response = await useCase.call(page: 1);
        emit(CoursesLoaded(response: response));
      } on DioException catch (e) {
        emit(
          CoursesError(
            isConnectionError: isNoInternetError(e),
            message: e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        final isSocketError = e is SocketException;
        emit(
          CoursesError(isConnectionError: isSocketError, message: e.toString()),
        );
      }
    });

    on<LoadMoreCoursesEvent>((event, emit) async {
      final current = state;

      // Only meaningful once a first page exists.
      if (current is! CoursesLoaded) return;

      // Drop the event if a page is already in flight or the last page has
      // been reached. This check is safe against duplicate events because
      // `emit` updates `state` synchronously and there is no `await`
      // between reading it and setting isLoadingMore below — so a second
      // event arriving while the first awaits the network sees the guard.
      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      final nextPage = current.response.meta.currentPage + 1;

      try {
        final next = await useCase.call(page: nextPage);

        emit(
          CoursesLoaded(
            response: CourseListResponse(
              links: next.links,
              // Accumulate: previously loaded items followed by the new page.
              data: [...current.response.data, ...next.data],
              // Meta from the newest page, so currentPage/lastPage advance.
              meta: next.meta,
            ),
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        // Keep whatever is already on screen — a failed "load more" must
        // never wipe out the pages the user is currently looking at, so
        // this deliberately does not emit CoursesError. Clearing the flag
        // lets the user retry simply by scrolling again.
        emit(current.copyWith(isLoadingMore: false));
      }
    });
  }
}
