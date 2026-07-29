import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
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
        final response = await useCase.call(params: event.params);
        emit(SearchCoursesLoaded(response: response));
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
  }
}
