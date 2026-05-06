import 'package:equatable/equatable.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class SearchBooksState extends Equatable {
  const SearchBooksState();

  @override
  List<Object?> get props => [];
}

class SearchBooksInitial extends SearchBooksState {}

class SearchBooksLoading extends SearchBooksState {}

class SearchBooksLoaded extends SearchBooksState {
  final BookListResponse response;

  const SearchBooksLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class SearchBooksError extends SearchBooksState {
  final String message;
  final bool isConnectionError;

  const SearchBooksError({
    required this.message,
    this.isConnectionError = false,
  });

  @override
  List<Object?> get props => [message, isConnectionError];
}
