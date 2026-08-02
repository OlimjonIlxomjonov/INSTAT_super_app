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
        // Always page 1 so a reload replaces rather than appends.
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

      // Only meaningful once a first page exists.
      if (current is! PopularBooksLoaded) return;

      // Drop the event while a page is in flight or at the last page. Safe
      // against duplicates because `emit` updates `state` synchronously and
      // nothing awaits between this check and the emit below.
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
              // Meta from the newest page so currentPage/lastPage advance.
              meta: next.meta,
            ),
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        // Keep what is already on screen — a failed "load more" must never
        // wipe out the books the user is looking at. Clearing the flag lets
        // them retry by scrolling again.
        final latest = state;
        if (latest is PopularBooksLoaded) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
