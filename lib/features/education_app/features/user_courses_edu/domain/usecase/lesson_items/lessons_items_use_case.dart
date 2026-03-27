import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_response_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class LessonsItemsUseCase {
  final UserCoursesRepository repository;

  LessonsItemsUseCase(this.repository);

  Future<CourseLessonItemsResponseEntity> call({
    required CourseLessonItemsParams params,
  }) async {
    return await repository.getCourseLessonItems(params: params);
  }
}
