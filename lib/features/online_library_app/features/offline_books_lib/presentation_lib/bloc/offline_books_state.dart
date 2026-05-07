import 'package:equatable/equatable.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class OfflineBooksState extends Equatable {
  const OfflineBooksState();

  @override
  List<Object?> get props => [];
}

class OfflineBooksInitial extends OfflineBooksState {}

class OfflineBooksLoading extends OfflineBooksState {}

class OfflineBooksLoaded extends OfflineBooksState {
  final BookListResponse response;

  const OfflineBooksLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class OfflineBooksError extends OfflineBooksState {
  final String message;

  const OfflineBooksError({required this.message});

  @override
  List<Object?> get props => [message];
}
