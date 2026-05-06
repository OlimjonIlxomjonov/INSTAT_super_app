import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/get_search_books_usecase.dart';
import 'search_books_event.dart';
import 'search_books_state.dart';

class SearchBooksBloc extends Bloc<SearchBooksEvent, SearchBooksState> {
  final GetSearchBooksUseCase _useCase;

  SearchBooksBloc({required GetSearchBooksUseCase useCase})
      : _useCase = useCase,
        super(SearchBooksInitial()) {
    on<SearchBooksEvent>(_onSearchBooks);
  }

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<SearchBooksState> emit,
  ) async {
    emit(SearchBooksLoading());
    try {
      final response = await _useCase.call(event.params);
      emit(SearchBooksLoaded(response: response));
    } on DioException catch (e) {
      emit(SearchBooksError(
        message: e.message ?? 'Unknown error',
        isConnectionError: true,
      ));
    } catch (e) {
      emit(SearchBooksError(message: e.toString()));
    }
  }
}
