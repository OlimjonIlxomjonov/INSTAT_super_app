import 'package:my_template/core/common/params/edu_params/params.dart';

class HomeEvent {
  HomeEvent();
}

class UserMeEvent extends HomeEvent {}

class AvailableCoursesEvent extends HomeEvent {
  final int? categoryId;
  final String search;

  AvailableCoursesEvent({this.categoryId, this.search = ''});
}

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

class MarkNotifReadEvent extends HomeEvent {
  final int id;

  MarkNotifReadEvent({required this.id});
}

class MarkAllNotifsReadEvent extends HomeEvent {}

class ActiveDevicesEvent extends HomeEvent {}

class DeleteActiveDevicesEvent extends HomeEvent {}

class DeleteDeviceByIdEvent extends HomeEvent {
  final int id;

  DeleteDeviceByIdEvent({required this.id});
}

/// Drops an already-deleted device from the loaded list without a refetch.
class RemoveActiveDeviceEvent extends HomeEvent {
  final int id;

  RemoveActiveDeviceEvent({required this.id});
}

class ModuleCategoryEvent extends HomeEvent {
  final ModuleCategoryParams params;

  ModuleCategoryEvent({required this.params});
}

class NotificationsCountEvent extends HomeEvent {}

class SiteFaqsEvent extends HomeEvent {
  final SiteFaqsParams params;

  SiteFaqsEvent({required this.params});
}
