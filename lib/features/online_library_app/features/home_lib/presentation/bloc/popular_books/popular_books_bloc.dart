import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
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
        final response = await useCase.call(page: 1);
        emit(PopularBooksLoaded(response: response));
      } on DioException catch (e) {
        emit(
          PopularBooksError(
            isConnectionError: isNoInternetError(e),
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

    on<LoadMorePopularBooksEvent>((event, emit) async {
      final current = state;

      if (current is! PopularBooksLoaded) return;

      if (current.isLoadingMore || !current.hasMore) return;

      emit(current.copyWith(isLoadingMore: true));

      try {
        final next = await useCase.call(
          page: current.response.meta!.currentPage + 1,
        );

        emit(
          PopularBooksLoaded(
            response: BookListResponse(
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        final latest = state;
        if (latest is PopularBooksLoaded) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
