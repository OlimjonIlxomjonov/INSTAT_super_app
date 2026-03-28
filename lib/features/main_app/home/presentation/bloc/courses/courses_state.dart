import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';

class CoursesState {
  CoursesState();
}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final CourseListResponse response;

  CoursesLoaded({required this.response});
}

class CoursesError extends CoursesState {
  final bool isConnectionError;
  final String message;

  CoursesError({required this.isConnectionError, required this.message});
}
