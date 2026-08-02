import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/saved_books/saved_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/bloc/saved_books/saved_books_event.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/bloc/saved_books/saved_books_state.dart';

class SavedBooksBloc extends Bloc<SavedBooksBaseEvent, SavedBooksState> {
  final SavedBooksUseCase useCase;

  SavedBooksBloc({required this.useCase}) : super(SavedBooksInitial()) {
    on<SavedBooksEvent>((event, emit) async {
      emit(SavedBooksLoading());
      try {
        // Always page 1 so a reload replaces rather than appends.
        final response = await useCase.call(page: 1);
        emit(SavedBooksLoaded(response: response));
      } catch (e) {
        emit(SavedBooksError());
      }
    });

    on<LoadMoreSavedBooksEvent>((event, emit) async {
      final current = state;

      // Only meaningful once a first page exists.
      if (current is! SavedBooksLoaded) return;

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
          SavedBooksLoaded(
            response: BookListResponse(
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        // Keep the books already on screen — a failed "load more" must not
        // clear them, and emitting SavedBooksError would wipe the list.
        final latest = state;
        if (latest is SavedBooksLoaded) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
