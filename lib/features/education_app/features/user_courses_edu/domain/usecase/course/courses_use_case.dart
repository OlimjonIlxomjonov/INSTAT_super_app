import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class CoursesUseCase {
  final UserCoursesRepository repository;

  CoursesUseCase({required this.repository});

  Future<CourseListResponse> call({required UserCoursesParams params}) {
    return repository.getUserCourses(params: params);
  }
}
