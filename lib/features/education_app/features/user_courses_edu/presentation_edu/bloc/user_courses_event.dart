import 'package:my_template/core/common/params/edu_params/params.dart';

class CoursesEvent {
  CoursesEvent();
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
