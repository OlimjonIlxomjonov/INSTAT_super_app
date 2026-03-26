import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';

class UserMeState {
  UserMeState();
}

class UserMeInitial extends UserMeState {}

class UserMeLoading extends UserMeState {}

class UserMeLoaded extends UserMeState {
  final UserEntity entity;

  UserMeLoaded({required this.entity});
}

class UserMeError extends UserMeState {}
