import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_this_course_response.dart';

class AboutCourseFeaturesState {
  AboutCourseFeaturesState();
}

class AboutCourseFeaturesInitial extends AboutCourseFeaturesState {}

class AboutCourseFeaturesLoading extends AboutCourseFeaturesState {}

class AboutCourseFeaturesLoaded extends AboutCourseFeaturesState {
  final AboutCourseResponse response;

  AboutCourseFeaturesLoaded({required this.response});
}

class AboutCourseFeaturesError extends AboutCourseFeaturesState {}
