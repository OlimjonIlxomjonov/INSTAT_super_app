import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class GetLessonTestOptionsUseCase {
  final UserCoursesRepository repository;

  GetLessonTestOptionsUseCase({required this.repository});

  Future<List<LessonTestOptionEntity>> call(CourseLessonTestOptionsParams params) {
    return repository.getLessonTestOptions(params: params);
  }
}
