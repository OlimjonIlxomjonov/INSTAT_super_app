import 'package:my_template/core/common/params/edu_params/params.dart';

class CoursesEvent {
  const CoursesEvent();
}

class UserCoursesEvent extends CoursesEvent {
  final UserCoursesParams params;

  UserCoursesEvent({required this.params});
}

class UserCategoryByIdEvent extends CoursesEvent {
  final CourseCategoryByIdParams params;

  UserCategoryByIdEvent({required this.params});
}

class CourseLessonTopicsEvent extends CoursesEvent {
  final CourseCategoryByIdParams params;

  CourseLessonTopicsEvent({required this.params});
}

class CourseLessonItemsEvent extends CoursesEvent {
  final CourseLessonItemsParams params;

  CourseLessonItemsEvent({required this.params});
}

class ResetCourseLessonItemsEvent extends CoursesEvent {
  const ResetCourseLessonItemsEvent();
}

class AboutCourseFeaturesEvent extends CoursesEvent {
  final CourseCategoryByIdParams params;

  AboutCourseFeaturesEvent({required this.params});
}

class CourseFilesEvent extends CoursesEvent {
  final CourseFilesParams params;

  CourseFilesEvent({required this.params});
}

class BuyCourseEvent extends CoursesEvent {
  final BuyCourseParams params;

  BuyCourseEvent({required this.params});
}

class CheckFinalTestAccessEvent extends CoursesEvent {
  final CheckFinalTestAccessParams params;

  CheckFinalTestAccessEvent({required this.params});
}

class OfflineCourseEvent extends CoursesEvent {}

class ScanQrEvent extends CoursesEvent {
  final ScanQrParams params;

  ScanQrEvent({required this.params});
}

class OfflineLessonsEvent extends CoursesEvent {
  final OfflineLessonsParams params;

  OfflineLessonsEvent({required this.params});
}
