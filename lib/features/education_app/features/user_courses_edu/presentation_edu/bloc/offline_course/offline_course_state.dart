import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_course_response.dart';

class OfflineCourseState {
  const OfflineCourseState();
}

class OfflineCourseInitial extends OfflineCourseState {}

class OfflineCourseLoading extends OfflineCourseState {}

class OfflineCourseLoaded extends OfflineCourseState {
  final OfflineCourseResponse response;

  OfflineCourseLoaded({required this.response});
}

class OfflineCourseError extends OfflineCourseState {}
