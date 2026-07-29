import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/main_app/home/domain/usecase/courses/courses_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class CoursesBloc extends Bloc<HomeEvent, CoursesState> {
  final ActiveCoursesUseCase useCase;

  CoursesBloc(this.useCase) : super(CoursesInitial()) {
    on<AvailableCoursesEvent>((event, emit) async {
      emit(CoursesLoading());
      try {
        final response = await useCase.call();
        emit(CoursesLoaded(response: response));
      } on DioException catch (e) {
        emit(CoursesError(
          isConnectionError: isNoInternetError(e),
          message: e.message ?? 'Unknown error',
        ));
      } catch (e) {
        final isSocketError = e is SocketException;
        emit(CoursesError(
          isConnectionError: isSocketError,
          message: e.toString(),
        ));
      }
    });
  }
}
