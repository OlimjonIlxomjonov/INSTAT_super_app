import 'package:my_template/features/education_app/features/user_courses_edu/data/models/about_course_features/about_course_features_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_this_course_response.dart';

class AboutCourseResponseModel extends AboutCourseResponse {
  AboutCourseResponseModel({required super.data});

  factory AboutCourseResponseModel.fromJson(List<dynamic> json) {
    return AboutCourseResponseModel(
      data: json
          .map(
            (e) => AboutCourseFeaturesModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
