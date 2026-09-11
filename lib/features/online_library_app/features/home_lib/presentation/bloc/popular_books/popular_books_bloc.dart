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

  /// Tanlangan filtrlar — keyingi sahifalar ham shular bo'yicha olinadi.
  int? _categoryId;
  String _search = '';

  /// Ro'yxat ayni damda qaysi filtr bilan turganini UI o'qiy olsin.
  int? get categoryId => _categoryId;

  PopularBooksBloc({required this.useCase}) : super(PopularBooksInitial()) {
    on<FetchPopularBooksEvent>((event, emit) async {
      final current = state;
      if (current is PopularBooksLoading) return;
      if (current is PopularBooksLoaded && current.isRefreshing) return;

      _categoryId = event.categoryId;
      _search = event.search;

      // Ro'yxatda kitob bo'lsa uni o'chirmaymiz — aks holda sliver qisqarib
      // sahifa tepaga sakraydi.
      final previous =
          current is PopularBooksLoaded && current.response.data.isNotEmpty
          ? current
          : null;
      emit(
        previous != null
            ? previous.copyWith(isRefreshing: true)
            : PopularBooksLoading(),
      );

      try {
        final response = await useCase.call(
          page: 1,
          categoryId: _categoryId,
          search: _search,
        );
        emit(PopularBooksLoaded(response: response));
      } on DioException catch (e) {
        emit(
          previous?.copyWith(isRefreshing: false) ??
              PopularBooksError(
                isConnectionError: isNoInternetError(e),
                message: e.message ?? 'Unknown error',
              ),
        );
      } catch (e) {
        final isSocketError = e is SocketException;
        emit(
          previous?.copyWith(isRefreshing: false) ??
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
          categoryId: _categoryId,
          search: _search,
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
