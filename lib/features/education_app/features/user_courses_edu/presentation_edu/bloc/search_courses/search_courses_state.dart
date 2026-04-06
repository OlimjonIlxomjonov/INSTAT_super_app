import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';

class SearchCoursesState {
  const SearchCoursesState();
}

class SearchCoursesInitial extends SearchCoursesState {}

class SearchCoursesLoading extends SearchCoursesState {}

class SearchCoursesLoaded extends SearchCoursesState {
  final CourseListResponse response;

  SearchCoursesLoaded({required this.response});
}

class SearchCoursesError extends SearchCoursesState {
  final bool isConnectionError;
  final String message;

  SearchCoursesError({
    required this.isConnectionError,
    required this.message,
  });
}
