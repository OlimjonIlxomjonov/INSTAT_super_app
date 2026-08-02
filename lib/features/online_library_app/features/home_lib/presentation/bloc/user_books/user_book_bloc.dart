import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/user_books/user_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_books_event.dart';

class UserBookBloc extends Bloc<UserBooksBaseEvent, UserBookState> {
  final UserBooksUseCase useCase;

  UserBookBloc({required this.useCase}) : super(UserBookInitial()) {
    on<UserBooksEvent>((event, emit) async {
      emit(UserBookLoading());
      try {
        // Always page 1 so a reload replaces rather than appends.
        final response = await useCase.call(page: 1);
        emit(UserBookLoaded(response: response));
      } catch (e) {
        emit(UserBookError());
      }
    });

    on<LoadMoreUserBooksEvent>((event, emit) async {
      final current = state;

      // Only meaningful once a first page exists.
      if (current is! UserBookLoaded) return;

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
          UserBookLoaded(
            response: BookListResponse(
              data: [...current.response.data, ...next.data],
              meta: next.meta,
            ),
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        // Keep the books already on screen — emitting UserBookError here
        // would blank the list over one failed page.
        final latest = state;
        if (latest is UserBookLoaded) {
          emit(latest.copyWith(isLoadingMore: false));
        }
      }
    });
  }
}
