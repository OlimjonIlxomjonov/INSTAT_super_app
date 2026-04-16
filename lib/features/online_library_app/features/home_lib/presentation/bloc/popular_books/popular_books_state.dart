import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class PopularBooksState {}

class PopularBooksInitial extends PopularBooksState {}

class PopularBooksLoading extends PopularBooksState {}

class PopularBooksLoaded extends PopularBooksState {
  final BookListResponse response;

  PopularBooksLoaded({required this.response});
}

class PopularBooksError extends PopularBooksState {
  final bool isConnectionError;
  final String message;

  PopularBooksError({required this.isConnectionError, required this.message});
}
