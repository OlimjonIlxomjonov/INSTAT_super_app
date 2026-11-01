import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/test_answer/test_answer_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class LessonTestAnswersUseCase {
  final UserCoursesRepository repository;

  LessonTestAnswersUseCase({required this.repository});

  Future<List<TestAnswerEntity>> call(int lessonId) =>
      repository.getLessonTestAnswers(lessonId);
}

class CourseTestAnswersUseCase {
  final UserCoursesRepository repository;

  CourseTestAnswersUseCase({required this.repository});

  Future<List<TestAnswerEntity>> call(int courseId) =>
      repository.getCourseTestAnswers(courseId);
}
