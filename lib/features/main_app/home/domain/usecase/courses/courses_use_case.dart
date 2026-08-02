import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class ActiveCoursesUseCase {
  final HomeRepository repository;

  ActiveCoursesUseCase({required this.repository});

  Future<CourseListResponse> call({int page = 1}) {
    return repository.getActiveCourses(page: page);
  }
}
