import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/usecase/search_students/search_students_use_case.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/search_students/search_students_event.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/search_students/search_students_state.dart';

class SearchStudentsBloc
    extends Bloc<SearchStudentsEvent, SearchStudentsState> {
  final SearchStudentsUseCase useCase;

  SearchStudentsBloc({required this.useCase})
    : super(SearchStudentsInitial()) {
    on<SearchStudentsEvent>((event, emit) async {
      emit(SearchStudentsLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(SearchStudentsLoaded(response: response));
      } on DioException catch (e) {
        emit(
          SearchStudentsError(
            isConnectionError: isNoInternetError(e),
            message: e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        final isSocketError = e is SocketException;
        emit(
          SearchStudentsError(
            isConnectionError: isSocketError,
            message: e.toString(),
          ),
        );
      }
    });
  }
}
