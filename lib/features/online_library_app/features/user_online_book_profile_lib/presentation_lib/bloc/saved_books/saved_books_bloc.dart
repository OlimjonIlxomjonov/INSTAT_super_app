import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/saved_books/saved_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/bloc/saved_books/saved_books_event.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/bloc/saved_books/saved_books_state.dart';

class SavedBooksBloc extends Bloc<SavedBooksEvent, SavedBooksState> {
  final SavedBooksUseCase useCase;

  SavedBooksBloc({required this.useCase}) : super(SavedBooksInitial()) {
    on<SavedBooksEvent>((event, emit) async {
      emit(SavedBooksLoading());
      try {
        final response = await useCase.call();
        emit(SavedBooksLoaded(response: response));
      } catch (e) {
        emit(SavedBooksError());
      }
    });
  }
}
