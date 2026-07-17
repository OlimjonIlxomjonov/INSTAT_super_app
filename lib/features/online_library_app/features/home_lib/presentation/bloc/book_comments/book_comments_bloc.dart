import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/book_comments/book_comments_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_comments/book_comments_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_comments/book_comments_state.dart';

class BookCommentsBloc extends Bloc<BookCommentsEvent, BookCommentsState> {
  final BookCommentsUseCase useCase;

  BookCommentsBloc({required this.useCase}) : super(BookCommentsInitial()) {
    on<BookCommentsEvent>((event, emit) async {
      emit(BookCommentsLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(BookCommentsLoaded(response: response));
      } catch (e) {
        emit(BookCommentsError());
      }
    });
  }
}
