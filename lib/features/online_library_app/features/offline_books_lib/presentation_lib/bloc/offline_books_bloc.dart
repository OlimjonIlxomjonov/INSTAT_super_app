import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/domain/usecase/get_offline_books_use_case.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/presentation_lib/bloc/offline_books_event.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/presentation_lib/bloc/offline_books_state.dart';

class OfflineBooksBloc extends Bloc<OfflineBooksEvent, OfflineBooksState> {
  final GetOfflineBooksUseCase _getOfflineBooksUseCase;

  OfflineBooksBloc({required GetOfflineBooksUseCase getOfflineBooksUseCase})
    : _getOfflineBooksUseCase = getOfflineBooksUseCase,
      super(OfflineBooksInitial()) {
    on<FetchOfflineBooks>(_onFetchOfflineBooks);
  }

  Future<void> _onFetchOfflineBooks(
    FetchOfflineBooks event,
    Emitter<OfflineBooksState> emit,
  ) async {
    emit(OfflineBooksLoading());
    try {
      final response = await _getOfflineBooksUseCase(
        SearchBooksParams(search: event.search, page: event.page),
      );
      emit(OfflineBooksLoaded(response: response));
    } catch (e) {
      emit(OfflineBooksError(message: e.toString()));
    }
  }
}
