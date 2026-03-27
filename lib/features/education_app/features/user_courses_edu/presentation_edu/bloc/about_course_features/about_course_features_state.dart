import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_this_course_response.dart';

class AboutCourseFeaturesState {
  final Map<int, AboutCourseResponse> cachedResponses;

  AboutCourseFeaturesState({this.cachedResponses = const {}});
}

class AboutCourseFeaturesInitial extends AboutCourseFeaturesState {
  AboutCourseFeaturesInitial() : super(cachedResponses: {});
}

class AboutCourseFeaturesLoading extends AboutCourseFeaturesState {
  AboutCourseFeaturesLoading({required Map<int, AboutCourseResponse> cachedResponses}) : super(cachedResponses: cachedResponses);
}

class AboutCourseFeaturesLoaded extends AboutCourseFeaturesState {
  final AboutCourseResponse response;

  AboutCourseFeaturesLoaded({required this.response, required Map<int, AboutCourseResponse> cachedResponses}) : super(cachedResponses: cachedResponses);
}

class AboutCourseFeaturesError extends AboutCourseFeaturesState {
  AboutCourseFeaturesError({required Map<int, AboutCourseResponse> cachedResponses}) : super(cachedResponses: cachedResponses);
}
