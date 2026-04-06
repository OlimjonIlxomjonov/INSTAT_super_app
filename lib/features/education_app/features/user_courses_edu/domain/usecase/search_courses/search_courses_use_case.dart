import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class SearchCoursesUseCase {
  final UserCoursesRepository repository;

  SearchCoursesUseCase({required this.repository});

  Future<CourseListResponse> call({required SearchCoursesParams params}) {
    return repository.searchCourses(params: params);
  }
}
