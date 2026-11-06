import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/lesson_status/lesson_status_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class LessonStatusUseCase {
  final UserCoursesRepository repository;

  LessonStatusUseCase({required this.repository});

  Future<LessonStatusEntity> call(int lessonId) =>
      repository.getLessonStatus(lessonId);
}
