import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_topics/course_lesson_topics_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class LessonsTopicsUseCase {
  final UserCoursesRepository repository;

  LessonsTopicsUseCase({required this.repository});

  Future<CourseLessonTopicsResponse> call({
    required CourseCategoryByIdParams params,
  }) {
    return repository.getLessonTopics(params: params);
  }
}
