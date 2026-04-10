import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class GetCourseFinalTestUseCase {
  final UserCoursesRepository repository;

  GetCourseFinalTestUseCase({required this.repository});

  Future<List<LessonTestEntity>> call({
    required CourseLessonTestParams params,
  }) {
    return repository.getCourseTests(params: params);
  }
}
