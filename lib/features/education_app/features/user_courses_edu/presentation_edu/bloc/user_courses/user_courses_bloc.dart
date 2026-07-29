import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
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
        final response = await useCase.call(params: event.params);
        emit(UserCoursesLoaded(response: response));
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
  }
}
