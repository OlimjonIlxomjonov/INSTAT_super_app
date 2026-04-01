import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_this_course_response.dart';

class AboutCourseFeaturesState {
  final Map<int, AboutCourseResponse> cachedResponses;

  AboutCourseFeaturesState({this.cachedResponses = const {}});
}

class AboutCourseFeaturesInitial extends AboutCourseFeaturesState {
  AboutCourseFeaturesInitial() : super(cachedResponses: {});
}

class AboutCourseFeaturesLoading extends AboutCourseFeaturesState {
  AboutCourseFeaturesLoading({required super.cachedResponses});
}

class AboutCourseFeaturesLoaded extends AboutCourseFeaturesState {
  final AboutCourseResponse response;

  AboutCourseFeaturesLoaded({
    required this.response,
    required super.cachedResponses,
  });
}

class AboutCourseFeaturesError extends AboutCourseFeaturesState {
  AboutCourseFeaturesError({required super.cachedResponses});
}
