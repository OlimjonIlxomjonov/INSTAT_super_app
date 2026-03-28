import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';

class UserCoursesState {
  UserCoursesState();
}

class UserCoursesInitial extends UserCoursesState {}

class UserCoursesLoading extends UserCoursesState {}

class UserCoursesLoaded extends UserCoursesState {
  final CourseListResponse response;

  UserCoursesLoaded({required this.response});
}

class UserCoursesError extends UserCoursesState {
  final bool isConnectionError;
  final String message;

  UserCoursesError({required this.isConnectionError, required this.message});
}
