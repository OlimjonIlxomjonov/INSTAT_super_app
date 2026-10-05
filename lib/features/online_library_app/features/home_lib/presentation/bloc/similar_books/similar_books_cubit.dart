import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/similar_book/similar_book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/similar_books/similar_books_use_case.dart';

class SimilarBooksState extends Equatable {
  const SimilarBooksState();

  @override
  List<Object?> get props => [];
}

class SimilarBooksLoading extends SimilarBooksState {}

class SimilarBooksLoaded extends SimilarBooksState {
  final List<SimilarBookEntity> items;
  final int? openingId;

  const SimilarBooksLoaded({required this.items, this.openingId});

  SimilarBooksLoaded copyWith({int? openingId, bool clearOpening = false}) {
    return SimilarBooksLoaded(
      items: items,
      openingId: clearOpening ? null : (openingId ?? this.openingId),
    );
  }

  @override
  List<Object?> get props => [items, openingId];
}

class SimilarBooksError extends SimilarBooksState {
  final String? message;

  const SimilarBooksError({this.message});

  @override
  List<Object?> get props => [message];
}

class SimilarBooksCubit extends Cubit<SimilarBooksState> {
  final SimilarBooksUseCase similarBooksUseCase;
  final BookByIdUseCase bookByIdUseCase;

  SimilarBooksCubit({
    required this.similarBooksUseCase,
    required this.bookByIdUseCase,
  }) : super(SimilarBooksLoading());

  Future<void> load(int bookId) async {
    emit(SimilarBooksLoading());
    try {
      final items = await similarBooksUseCase(bookId);
      if (isClosed) return;
      emit(SimilarBooksLoaded(items: items));
    } catch (e) {
      if (isClosed) return;
      emit(SimilarBooksError(message: apiErrorMessage(e)));
    }
  }

  /// Ro'yxatdagi javob qisqa — to'liq kitob alohida olinadi.
  Future<void> openBook(
    int bookId, {
    required void Function(BookEntity book) onLoaded,
    required void Function(String? message) onError,
  }) async {
    final current = state;
    if (current is! SimilarBooksLoaded || current.openingId != null) return;

    emit(current.copyWith(openingId: bookId));
    try {
      final book = await bookByIdUseCase(bookId);
      if (isClosed) return;
      emit(current.copyWith(clearOpening: true));
      onLoaded(book);
    } catch (e) {
      if (isClosed) return;
      emit(current.copyWith(clearOpening: true));
      onError(apiErrorMessage(e));
    }
  }
}
