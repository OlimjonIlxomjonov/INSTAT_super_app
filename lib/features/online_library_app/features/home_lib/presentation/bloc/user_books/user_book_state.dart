import 'package:equatable/equatable.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

class UserBookState extends Equatable {
  const UserBookState();

  @override
  List<Object?> get props => [];
}

class UserBookInitial extends UserBookState {}

class UserBookLoading extends UserBookState {}

class UserBookLoaded extends UserBookState {
  final BookListResponse response;

  const UserBookLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class UserBookError extends UserBookState {}
