import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_course_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class OfflineCourseUseCase {
  final UserCoursesRepository repository;

  OfflineCourseUseCase({required this.repository});

  Future<OfflineCourseResponse> call() {
    return repository.getOfflineCourse();
  }
}
