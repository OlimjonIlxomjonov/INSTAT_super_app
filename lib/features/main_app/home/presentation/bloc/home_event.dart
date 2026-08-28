import 'package:my_template/core/common/params/edu_params/params.dart';

class HomeEvent {
  HomeEvent();
}

class UserMeEvent extends HomeEvent {}

class AvailableCoursesEvent extends HomeEvent {}

class LoadMoreCoursesEvent extends HomeEvent {}

class AvatarEvent extends HomeEvent {
  final AvatarParams params;

  AvatarEvent({required this.params});
}

//! face rec
class FaceRecEvent extends HomeEvent {
  final FaceRecParams params;

  FaceRecEvent({required this.params});
}

class GetMyIdSessionEvent extends HomeEvent {
  final String birthDate;
  final String passportData;

  GetMyIdSessionEvent({required this.birthDate, required this.passportData});
}

class ResetFaceRecEvent extends HomeEvent {}

class NotifEvent extends HomeEvent {
  final NotifParams params;

  NotifEvent({required this.params});
}

class ActiveDevicesEvent extends HomeEvent {}

class DeleteActiveDevicesEvent extends HomeEvent {}
