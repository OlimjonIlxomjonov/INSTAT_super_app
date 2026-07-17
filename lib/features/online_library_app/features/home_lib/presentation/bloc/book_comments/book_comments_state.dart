import 'package:equatable/equatable.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';

class BookCommentsState extends Equatable {
  const BookCommentsState();

  @override
  List<Object?> get props => [];
}

class BookCommentsInitial extends BookCommentsState {}

class BookCommentsLoading extends BookCommentsState {}

class BookCommentsLoaded extends BookCommentsState {
  final CommentsResponse response;

  const BookCommentsLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class BookCommentsError extends BookCommentsState {}
