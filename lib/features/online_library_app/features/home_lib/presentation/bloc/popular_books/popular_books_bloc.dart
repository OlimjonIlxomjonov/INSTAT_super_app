import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/get_popular_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_state.dart';

class PopularBooksBloc extends Bloc<PopularBooksEvent, PopularBooksState> {
  final GetPopularBooksUseCase useCase;

  PopularBooksBloc({required this.useCase}) : super(PopularBooksInitial()) {
    on<FetchPopularBooksEvent>((event, emit) async {
      if (state is PopularBooksLoading) return;
      emit(PopularBooksLoading());
      try {
        final response = await useCase.call();
        emit(PopularBooksLoaded(response: response));
      } on DioException catch (e) {
        final isNoInternet =
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.unknown ||
            e.error is SocketException;

        emit(
          PopularBooksError(
            isConnectionError: isNoInternet,
            message: e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        final isSocketError = e is SocketException;
        emit(
          PopularBooksError(
            isConnectionError: isSocketError,
            message: e.toString(),
          ),
        );
      }
    });
  }
}
