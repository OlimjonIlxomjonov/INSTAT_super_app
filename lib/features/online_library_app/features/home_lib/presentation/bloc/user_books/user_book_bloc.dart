import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/user_books/user_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_books_event.dart';

class UserBookBloc extends Bloc<UserBooksEvent, UserBookState> {
  final UserBooksUseCase useCase;

  UserBookBloc({required this.useCase}) : super(UserBookInitial()) {
    on<UserBooksEvent>((event, emit) async {
      emit(UserBookLoading());
      try {
        final response = await useCase.call();
        emit(UserBookLoaded(response: response));
      } catch (e) {
        emit(UserBookError());
      }
    });
  }
}
