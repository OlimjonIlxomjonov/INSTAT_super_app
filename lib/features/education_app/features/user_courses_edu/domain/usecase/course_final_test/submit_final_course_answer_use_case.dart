import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_answer_response_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class SubmitFinalCourseAnswerUseCase {
  final UserCoursesRepository repository;

  SubmitFinalCourseAnswerUseCase({required this.repository});

  Future<LessonTestAnswerResponseEntity> call({
    required SubmitLessonTestAnswerParams params,
  }) {
    return repository.submitCourseTestAnswer(params: params);
  }
}
