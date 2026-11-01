import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class LessonFaceIdUseCase {
  final UserCoursesRepository repository;

  LessonFaceIdUseCase({required this.repository});

  Future<bool> call(int lessonId) =>
      repository.getLessonFaceIdEnabled(lessonId);
}
