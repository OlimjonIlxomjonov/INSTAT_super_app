import 'package:equatable/equatable.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

class SavedBooksState extends Equatable {
  const SavedBooksState();

  @override
  List<Object?> get props => [];
}

class SavedBooksInitial extends SavedBooksState {}

class SavedBooksLoading extends SavedBooksState {}

class SavedBooksLoaded extends SavedBooksState {
  final BookListResponse response;

  const SavedBooksLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class SavedBooksError extends SavedBooksState {}
