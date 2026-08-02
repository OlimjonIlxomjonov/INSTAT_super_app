import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/get_search_books_usecase.dart';
import 'search_books_event.dart';
import 'search_books_state.dart';

class SearchBooksBloc extends Bloc<SearchBooksBaseEvent, SearchBooksState> {
  final GetSearchBooksUseCase _useCase;

  SearchBooksBloc({required GetSearchBooksUseCase useCase})
    : _useCase = useCase,
      super(SearchBooksInitial()) {
    on<SearchBooksEvent>(_onSearchBooks);
    on<LoadMoreSearchBooksEvent>(_onLoadMore);
  }

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<SearchBooksState> emit,
  ) async {
    emit(SearchBooksLoading());
    try {
      // Always page 1 — a new query replaces results rather than appending.
      final response = await _useCase.call(
        SearchBooksParams(search: event.params.search, page: 1),
      );
      emit(
        SearchBooksLoaded(response: response, query: event.params.search),
      );
    } on DioException catch (e) {
      emit(
        SearchBooksError(
          message: e.message ?? 'Unknown error',
          isConnectionError: isNoInternetError(e),
        ),
      );
    } catch (e) {
      emit(SearchBooksError(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreSearchBooksEvent event,
    Emitter<SearchBooksState> emit,
  ) async {
    final current = state;

    // Only meaningful once a first page of results exists.
    if (current is! SearchBooksLoaded) return;

    // Drop the event while a page is in flight or at the last page. Safe
    // against duplicates because `emit` updates `state` synchronously and
    // nothing awaits between this check and the emit below.
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final next = await _useCase.call(
        SearchBooksParams(
          // Extend the *same* query these results belong to.
          search: current.query,
          page: current.response.meta!.currentPage + 1,
        ),
      );

      // The user may have typed a new query while this page was loading —
      // discard a now-stale page rather than mixing it into different
      // results.
      final latest = state;
      if (latest is! SearchBooksLoaded || latest.query != current.query) {
        return;
      }

      emit(
        SearchBooksLoaded(
          response: BookListResponse(
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
      if (latest is SearchBooksLoaded && latest.query == current.query) {
        emit(latest.copyWith(isLoadingMore: false));
      }
    }
  }
}
