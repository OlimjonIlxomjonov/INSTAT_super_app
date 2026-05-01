import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';

class CommentsState {
  const CommentsState();
}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final CommentsResponse response;

  CommentsLoaded({required this.response});
}

class CommentsError extends CommentsState {}
