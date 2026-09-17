import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/user_books/user_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_books_event.dart';

class UserBookBloc extends Bloc<UserBooksBaseEvent, UserBookState> {
  final UserBooksUseCase useCase;

  // current filters
  UserBookType _type = UserBookType.all;
  String _search = '';

  // Bumped on every fresh fetch so a slow, stale response (previous tab or
  // an earlier search term) can't overwrite a newer one.
  int _requestId = 0;

  UserBookBloc({required this.useCase}) : super(UserBookInitial()) {
    on<UserBooksEvent>((event, emit) {
      _type = event.type;
      _search = event.search;
      return _loadFirstPage(emit);
    });

    on<RefreshUserBooksEvent>((event, emit) => _loadFirstPage(emit));

    on<LoadMoreUserBooksEvent>((event, emit) async {
      final current = state;

      // Only meaningful once a first page exists.
      if (current is! UserBookLoaded) return;

      // Drop the event while a page is in flight or at the last page. Safe
      // against duplicates because `emit` updates `state` synchronously and
      // nothing awaits between this check and the emit below.
      if (current.isLoadingMore || !current.hasMore) return;

      final requestId = _requestId;
      emit(current.copyWith(isLoadingMore: true));

      try {
        final next = await useCase.call(
          page: current.response.meta!.currentPage + 1,
          type: _type.query,
          search: _search,
        );

        // Filters changed while this page was loading — the fresh fetch owns
        // the state now.
        if (requestId != _requestId) return;

        emit(
          UserBookLoaded(
            response: BookListResponse(
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        if (requestId != _requestId) return;
        // Keep the books already on screen — emitting UserBookError here
        // would blank the list over one failed page.
        final latest = state;
        if (latest is UserBookLoaded) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }

  Future<void> _loadFirstPage(Emitter<UserBookState> emit) async {
    final requestId = ++_requestId;

    emit(UserBookLoading());
    try {
      // Always page 1 so a reload replaces rather than appends.
      final response = await useCase.call(
        page: 1,
        type: _type.query,
        search: _search,
      );
      if (requestId != _requestId) return;
      emit(UserBookLoaded(response: response));
    } catch (e) {
      if (requestId != _requestId) return;
      emit(UserBookError(message: apiErrorMessage(e)));
    }
  }
}
