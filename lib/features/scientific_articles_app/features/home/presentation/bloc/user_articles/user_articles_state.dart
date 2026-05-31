import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_response.dart';

class UserArticlesState extends Equatable {
  const UserArticlesState();

  @override
  List<Object?> get props => [];
}

class UserArticlesInitial extends UserArticlesState {}

class UserArticlesLoading extends UserArticlesState {}

class UserArticlesLoaded extends UserArticlesState {
  final UserArticlesResponse response;

  const UserArticlesLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class UserArticlesError extends UserArticlesState {}
