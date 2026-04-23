import 'package:my_template/core/common/params/edu_params/params.dart';

class HomeEvent {
  HomeEvent();
}

class UserMeEvent extends HomeEvent {}

class AvailableCoursesEvent extends HomeEvent {}

class AvatarEvent extends HomeEvent {
  final AvatarParams params;

  AvatarEvent({required this.params});
}
