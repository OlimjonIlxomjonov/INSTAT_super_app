import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_course_features.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_this_course_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class AboutCourseFeaturesUseCase {
  final UserCoursesRepository repository;

  AboutCourseFeaturesUseCase({required this.repository});

  Future<AboutCourseResponse> call({required CourseCategoryByIdParams params}) {
    return repository.getAboutCourseFeatures(params: params);
  }
}
